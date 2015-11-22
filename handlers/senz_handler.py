import time
import sys
import os

#TODO refactore paths
sys.path.append(os.path.abspath('./utils'))
sys.path.append(os.path.abspath('./models'))

from senz_parser import *


class SenzHandler():
    def __init__(self, transport):
        self.transport = transport

    def handleSenz(self, senz):
        print 'senz received %s' % senz.type

        time.sleep(5)

    def postHandle(self, arg):
        self.transport.write('senz')
