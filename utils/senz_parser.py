import sys
import os


#TODO refactore paths
sys.path.append(os.path.abspath('./models'))

from senz import *


def parse(message):
    """
    Parse incoming senz messages and create Senz objects
    SHARE #bal #trans #nm #nic #time <time> @agent1 ^mysensors <sginature>
    """
    senz = Senz()
    tokens = message.split()

    # senz type comes in first place
    senz.type = tokens.pop(0)

    # senz signature comes at the end
    senz.signature = tokens.pop()

    i = 0
    while i < len(tokens):
        token = tokens[i]
        if token.startswith('@'):
            # this is receiver
            senz.receiver = token
        elif token.startswith('^'):
            # this is sender
            senz.sender = token
        elif token.startswith('#'):
            if tokens[i + 1].startswith('#') or tokens[i + 1].startswith('@') \
               or tokens[i + 1].startswith('^'):
                senz.attributes[token] = ''
            else:
                senz.attributes[token] = tokens[i + 1]
                i += 2
                continue

        i += 1

    print senz.type
    print senz.signature
    print senz.sender
    print senz.receiver
    print senz.attributes

    return senz

'''
parse('SHARE #bal #trans #nic 234 #time tim @agent ^myz <sig>')
parse('SHARE #bal #trans #nic #acc 4345234 #time tim @agent ^myz <sig>')
'''
