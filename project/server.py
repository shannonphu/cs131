import sys
import time
from datetime import datetime
from twisted.internet import reactor, protocol
from twisted.protocols.basic import LineReceiver

SERVERS = {
    "Alford"   : 12201, 
    "Ball"     : 12202, 
    "Hamilton" : 12203, 
    "Holiday"  : 12204, 
    "Welsh"    : 12205
}

class HerdServerProtocol(LineReceiver):
    def __init__(self, factory):
        self.factory = factory

    def lineReceived(self, line):
        print "Line received: {0}".format(line)

        # Get command from first word
        command = line.split()

        # ie. IAMAT kiwi.cs.ucla.edu +34.068930-118.445127 1479413884.392014450
        if command[0] == "IAMAT":
            print "got an IAMAT"
            self.handleIAMAT(command[1:])
        elif command[0] == "WHATSAT":
            print "got a WHATSAT"
            self.handleWHATSAT(command[1:])
        else:
            print "unrecognized command"

        reactor.connectTCP('localhost', 8080, HerdClient(line))

    def handleIAMAT(self, args):
        if len(args) != 3:
            print "IAMAT requires 3 paramaters"
            return
        client_location, lat_lon, timestamp = args
        print "location: {0}, lat-lon: {1}, timestamp: {2}".format(client_location, lat_lon, timestamp)

        # Format AT response
        time_difference = time.mktime(datetime.now().timetuple()) - float(timestamp)
        response = "AT {0} +{1} {2} {3} {4}".format(self.factory.server_name, time_difference, client_location, lat_lon, timestamp)

        print response

    def handleWHATSAT(self, args):
        if len(args) != 3:
            print "WHATSAT requires 3 paramaters"
            return
        client_location, radius, bound = args
        print "location: {0}, radius: {1}, bound: {2}".format(client_location, radius, bound)

    def connectionMade(self):
        # self.transport.write("Connection made")
        self.factory.connections += 1
        print "Connections made. Total: {0}".format(self.factory.connections)

    def connectionLost(self, reason):
        self.factory.connections -= 1
        print "Connections lost. Total: {0}".format(self.factory.connections)



class HerdServer(protocol.ServerFactory):
    def __init__(self, server_name):
        self.connections = 0
        self.server_name = server_name

    def buildProtocol(self, addr):
        return HerdServerProtocol(self)

    def stopFactory(self):
        print "server shutdown"

#####################
class HerdClientProtocol(LineReceiver):
    def __init__ (self, factory):
        self.factory = factory

    def connectionMade(self):
        print "server connection made" + self.factory.message
        self.sendLine(self.factory.message)

    def lineReceived(self, line):
        print line + "received by client"


class HerdClient(protocol.ClientFactory):
    def __init__(self, message):
        self.message = message

    def startedConnecting(self, connector):
        print "client started connecting"

    def connectionMade(self):
        print "client connection made"

    def buildProtocol(self, addr):
        return HerdClientProtocol(self)

#######################

def main():
    if len(sys.argv) != 2:
        print "Error! You need a servername argument!"
        return

    factory = HerdServer(sys.argv[1])
    reactor.listenTCP(SERVERS[sys.argv[1]], factory)
    reactor.run()


# this only runs if the module was *not* imported
if __name__ == '__main__':
    main()
