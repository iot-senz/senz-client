from twisted.internet.protocol import DatagramProtocol
from twisted.internet import reactor, threads

import time
import sys
import os


#TODO refactore paths
sys.path.append(os.path.abspath('./utils'))
sys.path.append(os.path.abspath('./models'))
sys.path.append(os.path.abspath('./handlers'))

from crypto_utils import *
from senz import *


class SenzcProtocol(DatagramProtocol):
    def __init__(self, host, port):
        self.host = host
        self.port = port

    def startProtocol(self):
        print 'client started'
        self.transport.connect(self.host, self.port)

        # generate SHARE senz
        senz = Senz()
        senz.pubkey = get_pubkey()
        senz.receiver = 'mysensors'
        senz.sender = 'test'
        senz.attributes['time'] = time.time()
        senz = "SHARE #pubkey %s #time %s @%s ^%s" % \
                         (senz.pubkey, time.time(), senz.receiver, senz.sender)
        signed_senz = sign_senz(senz)
        print signed_senz

        self.transport.write(signed_senz)

    def stopProtocol(self):
        # Called when transport is disconnected
        print 'client stopped'

    def datagramReceived(self, datagram, host):
        handler = SenzHandler(self.transport)
        d = threads.deferToThread(handler.handleSenz, datagram)
        d.addCallback(handler.postHandle)


def init():
    """
    Init client certificates from here
    """
    # init keys via crypto utils
    init_keys()


def start():
    # TODO get host and port from config
    host = '10.2.2.132'
    port = 9999
    protocol = SenzcProtocol(host, port)
    reactor.listenUDP(0, protocol)
    reactor.run()


if __name__ == '__main__':
    init()
    start()
