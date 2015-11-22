import time
import sys
import os

#TODO refactore paths
sys.path.append(os.path.abspath('./utils'))

from senz_parser import *


class SenzHandler():
    def __init__(self, transport):
        self.transport = transport

    def handleSenz(self, message):
        print 'senz received %s' % message

        time.sleep(5)
        # parse senz first
        #senz = parse(message)
        #print senz.type

    def postHandle(self, arg):
        self.transport.write('senz')
