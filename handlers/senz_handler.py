import time
import sys
import os

#TODO refactore paths
sys.path.append(os.path.abspath('./utils'))
sys.path.append(os.path.abspath('./models'))

from senz_parser import *


class SenzHandler():
    """
    Handler incoming senz messages from here. We are dealing with following
    senz types
        1. GET
        2. PUT
        3. SHARE
        4. DATA

    According to the senz type different operations need to be carry out
    """
    def __init__(self, transport):
        """
        Initilize udp transport from here. We can use transport to send message
        to udp socket

        Arg
            trnsport - twisted transport instance
        """
        self.transport = transport

    def handleSenz(self, senz):
        """
        Handle differennt types of senz from here. This function will be called
        asynchronously. Whenc senz message receives this function will be
        called by twisted thread(thread safe mode via twisted library)
        """

        print 'senz received %s' % senz.type

        time.sleep(5)

    def postHandle(self, arg):
        """
        After handling senz message this function will be called. Basically
        this is a call back funcion
        """
        #self.transport.write('senz')
