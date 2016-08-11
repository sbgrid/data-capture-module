#!/usr/bin/env python

import cgi
import json
import os.path

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
    x = {'datasetIdentifier':uid, 'script':dat}
    print('Content-Type: application/json\n\n%s' % json.dumps( x ) )

if __name__ == '__main__':
    proc()

