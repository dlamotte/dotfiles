#!/usr/bin/env python

import os
import socket
import sys
import time

def main(argv):
    while True:
        update_hosts()
        time.sleep(60)

    return 0

def tokenize(fp):
    for line in fp:
        try:
            stripped = line[:line.index('#')]
        except ValueError:
            stripped = line
        stripped = stripped.strip()
        tokens = stripped.split()
        yield line, tokens

def update_hosts():
    fp = open('/etc/hosts')
    content = ''
    hostname = socket.gethostname()
    modified = False
    for line, tokens in tokenize(fp):
        if 'localhost' in tokens and hostname not in tokens:
            modified = True
            line = '%s %s\n' % (line.rstrip(), hostname)
        content += line
    fp.close()

    if modified:
        fp = open('/etc/hosts', 'w')
        fp.write(content)
        fp.close()

if __name__ == '__main__':
    sys.exit(main(sys.argv))
