#!/usr/bin/env python

'''
upload request handler 

'''

import sys
import os
DATADIR='/deposit/requests/'

#at least with current lighttpd cgi config, PID is unique to each call
pid = os.getpid() 

fname = '%s/%d.json' % (DATADIR, pid)
opf = open( fname, 'w' )
opf.write( sys.stdin.read() )
opf.close()

# this sets reponse headers to 200, aparently
print('Content-Type: text/plain\n\n')
print('recieved')

