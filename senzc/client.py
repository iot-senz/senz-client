from twisted.internet.protocol import DatagramProtocol
from twisted.internet import reactor, threads

import time
import sys
import os


#TODO refactore paths
sys.path.append(os.path.abspath('./utils'))
sys.path.append(os.path.abspath('./models'))

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
        senz.attributes = {'time': time.time()}
        senz = "SHARE #pubkey %s #time %s @%s ^%s" % \
                         (senz.pubkey, time.time(), senz.receiver, senz.sender)
        signed_senz = sign_senz(senz)
        print signed_senz

        self.transport.write(signed_senz)

    def stopProtocol(self):
        # Called when transport is disconnected
        print 'client stopped'

    def datagramReceived(self, datagram, host):
        print 'Datagram received: ', repr(datagram)
        handler = Handler(self.transport)
        d = threads.deferToThread(handler.handleMessage, datagram)
        d.addCallback(handler.postHandle)


class Handler():
    def __init__(self, transport):
        self.transport = transport

    def handleMessage(self, datagram):
        print 'Handler Message: ', repr(datagram)
        #self.transport.write('senz')

    def postHandle(self, arg):
        print 'post handling'


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
