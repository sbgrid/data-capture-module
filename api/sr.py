#!/usr/bin/env python

'''
API endpoint for script requests
'''

import cgi
import json
import os.path
import sys

#TODO - read from environmental variable
UPLOAD_ROOT='/deposit/'

def proc():
    form = cgi.FieldStorage()
    try:
        # retrieve upload ID from form data
        ulid = form['datasetIdentifier'].value
    except KeyError:
        # meaningless to ask for a transfer script if request doesn't specify which one
        print('Status:400\n\n')
        sys.stderr.write('no datasetIdentifierField in FORM data\n')
        return
    fn = '/%s/gen/upload-%s.bash' % (UPLOAD_ROOT, ulid)
    if not os.path.exists( fn ):
        # transfer script not generated; return 404 according to API docs.
        # not logging errors, because it's not an error condition
        print('Status:404\n\n')
        return
    # read transfer script for handoff
    with open(fn, 'r') as inp:
        dat = inp.read()
    # read request file (transfer "metadata") 
    with open( os.path.join( UPLOAD_ROOT, 'processed', '%s.json' % ulid ) ) as inp:
        req = json.load( inp )

    # "validate" request file
    if int(req['datasetIdentifier']) != int(ulid):
        # should never happen - defensive programming, or paranoia depending on perspective
        print('Status:500\n\n')
        sys.stderr.write('datasetIdentifier in request file does not match base filename\n')
        return
    req['script'] = dat
    print('Content-Type: application/json\n\n%s' % json.dumps( req ) )

if __name__ == '__main__':
    proc()

