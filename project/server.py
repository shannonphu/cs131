import sys
import time
from datetime import datetime
from twisted.internet import reactor, protocol
from twisted.protocols.basic import LineReceiver

SERVERS = {
    "Alford"   : { "port" : 12201,
                   "neighbors": ["Hamilton", "Welsh"]
                 }, 
    "Ball"     : { "port" : 12202,
                   "neighbors": ["Holiday", "Welsh"]
                 },
    "Hamilton" : { "port" : 12203,
                   "neighbors": ["Holiday"]
                 },
    "Holiday"  : { "port" : 12204,
                   "neighbors": ["Hamilton", "Ball"]
                 }, 
    "Welsh"    : { "port" : 12205,
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
            # print "got an IAMAT"
            self.handleIAMAT(command[1:])
        elif command[0] == "WHATSAT":
            # print "got a WHATSAT"
            self.handleWHATSAT(command[1:])
        elif command[0] == "AT":
            # print "got an AT"
            self.handleAT(command[1:])
        else:
            print "? {0}".format(command)


    # ie. IAMAT kiwi.cs.ucla.edu +34.068930-118.445127 1479413884.392014450
    def handleIAMAT(self, args):
        if len(args) != 3:
            print "IAMAT requires 3 parameters"
            return
        client_location, lat_lon, timestamp = args
        print "{0} says location: {1}, lat-lon: {2}, timestamp: {3}".format(self.factory.server_name, client_location, lat_lon, timestamp)

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
        print "{0} location: {1}, radius: {2}, bound: {3}".format(this.factory.server_name, client_location, radius, bound)

    # ie. AT Alford +0.263873386 kiwi.cs.ucla.edu +34.068930-118.445127 1479413884.392014450
    def handleAT(self, args):
        if len(args) != 5:
            print "IAMAT requires 5 parameters"
            return
        servername, time_difference, client_location, lat_lon, timestamp = args

        if (client_location in self.factory.clients) and (timestamp <= self.factory.clients[client_location]["timestamp"]):
            return

        print "{0} received AT from {1}: ".format(self.factory.server_name, servername)
        message = "AT {0} {1} {2} {3} {4}".format(servername, time_difference, client_location, lat_lon, timestamp)
        self.factory.clients[client_location] = { "message" : message, "timestamp" : timestamp }
        self.notifyNeighborsLocationChanged(message)

    def notifyNeighborsLocationChanged(self, message):
        neighbors = SERVERS[self.factory.server_name]["neighbors"]
        for n in neighbors:
            reactor.connectTCP('localhost', SERVERS[n]["port"], HerdClient(message))
            print "{0} sends location update to {1}".format(self.factory.server_name, n)



class HerdServer(protocol.ServerFactory):
    def __init__(self, server_name):
        self.connections = 0
        self.server_name = server_name
        self.clients = {}

    def buildProtocol(self, addr):
        return HerdServerProtocol(self)

    def stopFactory(self):
        print "server shutdown"

#####################
class HerdClientProtocol(LineReceiver):
    def __init__ (self, factory):
        self.factory = factory

    def connectionMade(self):
        self.sendLine(self.factory.message)

    def lineReceived(self, line):
        print line + "received by client"


class HerdClient(protocol.ClientFactory):
    def __init__(self, message):
        self.message = message

    def buildProtocol(self, addr):
        return HerdClientProtocol(self)

#######################

def main():
    if len(sys.argv) != 2:
        print "Error! You need a servername argument!"
        return

    factory = HerdServer(sys.argv[1])
    reactor.listenTCP(SERVERS[sys.argv[1]]["port"], factory)
    reactor.run()


# this only runs if the module was *not* imported
if __name__ == '__main__':
    main()
