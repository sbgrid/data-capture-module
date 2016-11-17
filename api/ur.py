#!/usr/bin/env python

'''
upload request handler 

'''

DATADIR='/deposit/requests/'

import sys
sys.path.append('../gen')
import os
from usg import proc
from rq import Queue
from redis import Redis

#at least with current lighttpd cgi config, PID is unique to each call
pid = os.getpid() 

# dump to unique file
fname = '%s/%d.json' % (DATADIR, pid)
opf = open( fname, 'w' )
opf.write( sys.stdin.read() )
opf.close()

# put it in the queue
conn = Redis()
queue = Queue('normal', connection = conn )
job = queue.enqueue( proc, fname )
# may or may not be useful to return job identifier to caller

# this sets reponse headers to 200, aparently
print('Content-Type: text/plain\n\n')
print('recieved')

