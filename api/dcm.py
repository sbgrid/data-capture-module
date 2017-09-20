#!/usr/bin/env python
# tested with:
# - Flask-0.11-py2.py3-none-any.whl on Python 2.7 (OS X 10.10)
# - python-flask-0.9-7.el6.noarch on Python 2.6 (CentOS 6)

'''
Integration stub / mock DCM API endpoint.
'''

from flask import Flask, Response, request
import json

# `sr.py` can fail with status code 400,404,500
SR_FAIL_WITH=None

# `ur.py` can fail with 500; but more likely by not responding
UR_FAIL_WITH=None

# pydoc doesn't support docstrings for module variables
app = Flask(__name__)

@app.route('/')
def idx():
    '''
    index page with message pointing to useful urls
    '''
    return 'Mock DCM endpoint is running; you want /ur.py or /sr.py'

@app.route('/ur.py', methods=['POST'])
def upload_request():
    '''
    request creation of an upload script.
    '''
    if None != UR_FAIL_WITH:
        return Response('',status=UR_FAIL_WITH)
    xdat = json.loads( request.data )
    print('debug: recieved request for creation of transfer script for dataset "%s" for user "%s"' % ( xdat['datasetIdentifier'], xdat['userId'] ) )
    data = {}
    data['status'] = 'OK'
    resp = Response(response=json.dumps(data),
        # 202 "accepted" would be more appropriate, but non-200 breaks things
        status=200, \
        mimetype="application/json")
    return(resp)

@app.route('/sr.py', methods=['POST'])
def script_request():
    '''
    request the upload script.
    "Happy path" only - 404 will be returned in normal use if the script is not available.
    '''
    if None != SR_FAIL_WITH:
        return Response('',status=SR_FAIL_WITH)
    dset_id  = request.form['datasetIdentifier'] 
    print('debug: recieved script request for dataset "%s" ' % dset_id)
    with open('rsync.sh', 'r') as myfile:
        script=myfile.read()
    data = { 'script' : script ,"datasetIdentifier":dset_id ,"userId":42 }
    resp = Response(response=json.dumps(data),
        status=200, \
        mimetype="application/json")
    return(resp)

if __name__ == "__main__":
    app.run(host='0.0.0.0')
