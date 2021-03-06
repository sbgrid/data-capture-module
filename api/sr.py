#!/usr/bin/env python

'''
API endpoint for script requests
'''

import cgi
import json
import os.path
import commands
import datetime
import sys
sys.path.append('../lib')
import shared

#TODO - read from environmental variable
UPLOAD_ROOT='/deposit/'
DURATION_DAYS=7

def increment_transfer_expiration( ulid ):
    '''
    increment expiration date of transfer account on script request.
    '''
    t = datetime.date.today() + datetime.timedelta( days = DURATION_DAYS)
    cmd = 'sudo /usr/bin/chage -E %s %s' % ( t.isoformat(), ulid )
    (e,r) = commands.getstatusoutput( cmd )
    if 0 != e:
        sys.stderr.write('error re-setting expiration date for %s:' % ulid)
        # since there's still a change that this is called before ur.py has finished due to
        # dv command handling, don't error out (aka - interpret as a warning).
        sys.stderr.write(r)

def proc():
    form = cgi.FieldStorage()
    try:
        # retrieve upload ID from form data
        ulid = form['datasetIdentifier'].value
        ulid = shared.ulid_check_and_sanitize(ulid)
    except KeyError:
        # meaningless to ask for a transfer script if request doesn't specify which one
        print('Status:400\nContent-Type: application/json\n\n[]\n')
        sys.stderr.write('no datasetIdentifierField in FORM data\n')
        return
    except ValueError:
        print('Status:400\nContent-Type: application/json\n\n[]\n')
        sys.stderr.write('invalid pid for dataset\n')
        return
    fn = '/%s/gen/upload-%s.bash' % (UPLOAD_ROOT, ulid)
    if not os.path.exists( fn ):
        # transfer script not generated; return 404 according to API docs.
        # not logging errors, because it's not an error condition
        print('Status:404\nContent-Type: application/json\n\n[]\n')
        return
    # read transfer script for handoff
    with open(fn, 'r') as inp:
        dat = inp.read()
    # read request file (transfer "metadata") 
    with open( os.path.join( UPLOAD_ROOT, 'processed', '%s.json' % ulid ) ) as inp:
        req = json.load( inp )

    req['script'] = dat
    increment_transfer_expiration( ulid )
    print('Content-Type: application/json\n\n%s' % json.dumps( req ) )

if __name__ == '__main__':
    proc()

