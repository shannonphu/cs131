import sys, time, logging, re, json, os, urllib2
import conf
from datetime import datetime
from twisted.internet import reactor, protocol
from twisted.protocols.basic import LineReceiver
from twisted.web.client import getPage

API_ROOT_URL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key={0}&".format(conf.API_KEY)

SERVERS = {
    "Alford"   : { "port" : conf.PORT_NUM["Alford"],
                   "neighbors": ["Hamilton", "Welsh"]
                 }, 
    "Ball"     : { "port" : conf.PORT_NUM["Ball"],
                   "neighbors": ["Holiday", "Welsh"]
                 },
    "Hamilton" : { "port" : conf.PORT_NUM["Hamilton"],
                   "neighbors": ["Holiday"]
                 },
    "Holiday"  : { "port" : conf.PORT_NUM["Holiday"],
                   "neighbors": ["Hamilton", "Ball"]
                 }, 
    "Welsh"    : { "port" : conf.PORT_NUM["Welsh"],
                   "neighbors": ["Alford", "Ball"]
                 }
}

class HerdServerProtocol(LineReceiver):
    def __init__(self, factory):
        self.factory = factory

    def lineReceived(self, line):
        # Get command from first word
        command = line.split()

        if command[0] == "IAMAT":
            self.handleIAMAT(command[1:])
        elif command[0] == "WHATSAT":
            self.handleWHATSAT(command[1:])
        elif command[0] == "AT":
            self.handleAT(command[1:])
        else:
            log = "? {0}".format(line)
            logging.error(log)


    # ie. IAMAT kiwi.cs.ucla.edu +34.068930-118.445127 1479413884.392014450
    def handleIAMAT(self, args):
        if len(args) != 3:
            logging.error("IAMAT requires 3 parameters")
            return

        client_location, lat_lon, timestamp = args
        log = "{0} server received from client location: {1}, lat-lon: {2}, timestamp: {3}".format(self.factory.server_name, client_location, lat_lon, timestamp)
        logging.info(log)

        # Format AT response
        time_difference = time.mktime(datetime.now().timetuple()) - float(timestamp)
        response = "AT {0} +{1} {2} {3} {4}".format(self.factory.server_name, time_difference, client_location, lat_lon, timestamp)

        self.sendLine(response)
        self.factory.clients[client_location] = { "message" : response, "timestamp" : timestamp }
        # Broadcast client location change to neighbors
        self.notifyNeighborsLocationChanged(response)

    # ie. WHATSAT kiwi.cs.ucla.edu 10 5
    def handleWHATSAT(self, args):
        if len(args) != 3:
            print "WHATSAT requires 3 parameters"
            return

        client_location, radius, bound = args
        radius = int(radius)
        bound = int(bound)

        if radius > 50 or bound > 20:
            logging.error("WHATSAT radius must be at max 50 and bound must be at max 20")
            return

        log = "WHATSAT command made to {0} and received parameters location: {1}, radius: {2}, bound: {3}".format(self.factory.server_name, client_location, radius, bound)
        logging.info(log)

        # get stored message of where the current client is
        command = self.factory.clients[client_location]["message"]
        split_command = command.split()[1:]
        server_name, time_difference, client_location, lat_lon, timestamp = split_command

        # parse out lat/lon of location
        lat_lon = re.sub(r'[-]', ' -', lat_lon)
        lat_lon = re.sub(r'[+]', ' +', lat_lon).split()
        coordinate = lat_lon[0] + "," + lat_lon[1]

        request = "{0}location={1}&radius={2}&sensor=false".format(API_ROOT_URL, coordinate, radius)
        log = "accessed API endpoint: {0}".format(request)
        logging.info(log)
        response = urllib2.urlopen(request)
        data = json.load(response)
        json_resp = data["results"]
        json_resp = json_resp[:bound]
        logging.info(command)
        logging.info(json.dumps(json_resp, indent=5))

        #response.addCallback(callback = lambda x:(self.getJSON(x, client_location, int(bound))))


    # ie. AT Alford +0.263873386 kiwi.cs.ucla.edu +34.068930-118.445127 1479413884.392014450
    def handleAT(self, args):
        if len(args) != 5:
            logging.info("IAMAT requires 5 parameters")
            return
        servername, time_difference, client_location, lat_lon, timestamp = args

        if (client_location in self.factory.clients) and (timestamp <= self.factory.clients[client_location]["timestamp"]):
            return

        log = "{0} received AT {1} {2} {3} {4} {5}: ".format(self.factory.server_name, servername, time_difference, client_location, lat_lon, timestamp)
        logging.info(log)
        message = "AT {0} {1} {2} {3} {4}".format(servername, time_difference, client_location, lat_lon, timestamp)
        self.factory.clients[client_location] = { "message" : message, "timestamp" : timestamp }
        self.notifyNeighborsLocationChanged(message)

    def notifyNeighborsLocationChanged(self, message):
        neighbors = SERVERS[self.factory.server_name]["neighbors"]
        for n in neighbors:
            reactor.connectTCP('localhost', SERVERS[n]["port"], HerdClient(message))
            log = "{0} sends location update to {1}".format(self.factory.server_name, n)
            logging.info(log)

    def getJSON(self, data, client_location, bound):
        # print "enter getJSON with {0} {1} {2}".format(data, client_location, bound)
        json_resp = json.loads(data)
        json_resp = json_resp["results"]
        json_resp = json_resp[:bound]
        logging.info(json.dumps(json_resp, indent=5))

class HerdServer(protocol.ServerFactory):
    def __init__(self, server_name):
        self.connections = 0
        self.server_name = server_name
        self.clients = {}
        filename = server_name.lower() + "-debug.log"
        if os.path.isfile(filename): 
            os.remove(filename)
        logging.basicConfig(filename = filename, level=logging.DEBUG)
        log = '{0} server started at port {1}'.format(self.server_name, SERVERS[self.server_name]["port"])
        logging.info(log)

    def buildProtocol(self, addr):
        return HerdServerProtocol(self)

    def stopFactory(self):
        logging.info("{0} server exited".format(self.server_name))

#####################
class HerdClientProtocol(LineReceiver):
    def __init__ (self, factory):
        self.factory = factory

    def connectionMade(self):
        self.sendLine(self.factory.message)


class HerdClient(protocol.ClientFactory):
    def __init__(self, message):
        self.message = message

    def buildProtocol(self, addr):
        return HerdClientProtocol(self)
#######################

def main():
    if len(sys.argv) != 2:
        print "Error! You need a servername argument!"
        print "Call signature: python server.py [Alford, Ball, Welsh, Holiday, Hamilton]"
        return

    factory = HerdServer(sys.argv[1])
    reactor.listenTCP(SERVERS[sys.argv[1]]["port"], factory)
    reactor.run()


if __name__ == '__main__':
    main()
