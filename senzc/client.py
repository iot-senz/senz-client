from twisted.internet.protocol import DatagramProtocol
from twisted.internet.task import LoopingCall
from twisted.internet import reactor, threads

import time
import sys
import os

#TODO refactore paths
sys.path.append(os.path.abspath('./utils'))
sys.path.append(os.path.abspath('./models'))
sys.path.append(os.path.abspath('./handlers'))

from crypto_utils import *
from senz_handler import *
from senz import *


class SenzcProtocol(DatagramProtocol):
    def __init__(self, host, port):
        self.host = host
        self.port = port

    def startProtocol(self):
        print 'client started'
        self.transport.connect(self.host, self.port)

        # share public key on start
        self.share_pubkey()

        # start ping sender to send ping messages to server in everty 30 mins
        lc = LoopingCall(self.send_ping)
        lc.start(60 * 30)

    def stopProtocol(self):
        # Called when transport is disconnected
        print 'client stopped'

    def datagramReceived(self, datagram, host):
        print 'datagram received %s' % datagram
        # parse datagram and get senz
        self.handle_datagram(datagram)

    def share_pubkey(self):
        # TODO get sender and receiver config
        # send pubkey to server via SHARE senz
        pubkey = get_pubkey()
        receiver = 'mysensors'
        sender = 'test'
        senz = "SHARE #pubkey %s #time %s @%s ^%s" % \
                         (pubkey, time.time(), receiver, sender)
        signed_senz = sign_senz(senz)

        self.transport.write(signed_senz)

    def send_ping(self):
        # TODO get sender and receiver config
        # send ping message to server via DATA senz
        receiver = 'mysensors'
        sender = 'test'
        senz = "DATA #time %s @%s ^%s" % \
                                    (time.time(), receiver, sender)
        signed_senz = sign_senz(senz)

        self.transport.write(signed_senz)

    def handle_datagram(self, datagram):
        # parse senz first
        senz = parse(datagram)

        if senz.type == 'PING':
            # we ingnore ping messages
            print 'ping received'
        else:
            # start threads for GET, PUT, DATA, SHARE senz
            handler = SenzHandler(self.transport)
            d = threads.deferToThread(handler.handleSenz, senz)
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
