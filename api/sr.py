#!/usr/bin/env python

'''
API endpoint for script requests
'''

import cgi
import json
import os.path

#TODO - read from environmental variable
UPLOAD_ROOT='/deposit/'

def proc():
    form = cgi.FieldStorage()
    try:
        uid = form['datasetIdentifier'].value
    except KeyError:
        print('Status:400\n\n')
        return
    fn = '/%s/gen/upload-%s.bash' % (UPLOAD_ROOT, uid)
    if not os.path.exists( fn ):
        print('Status:404\n\n')
        return
    with open(fn, 'r') as inp:
        dat = inp.read()
    with open( os.path.join( UPLOAD_ROOT, 'processed', '%s.json' % uid ) ) as inp:
        req = json.load( inp )
    if req['datasetIdentifier'] != uid:
        # should never happen - defensive programming, or paranoia depending on perspective
        print('Status:500\n\n')
        return
    req['script'] = dat
    print('Content-Type: application/json\n\n%s' % json.dumps( req ) )

if __name__ == '__main__':
    proc()

