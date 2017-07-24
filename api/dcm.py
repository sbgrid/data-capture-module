#!/usr/bin/env python
# tested with:
# - Flask-0.11-py2.py3-none-any.whl on Python 2.7 (OS X 10.10)
# - python-flask-0.9-7.el6.noarch on Python 2.6 (CentOS 6)

'''
Integration stub / mock DCM API endpoint.
'''

from flask import Flask, Response, request
import json

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
    print('debug: recieved request for creation of transfer script for dataset "%s" for user "%s"' % ( request.json['datasetIdentifier'], request.json['userId'] ) )
    data = {}
    data['status'] = 'OK'
    resp = Response(response=json.dumps(data),
        # 202 "accepted"
        status=202, \
        mimetype="application/json")
    return(resp)

@app.route('/sr.py', methods=['POST'])
def script_request():
    '''
    request the upload script.
    "Happy path" only - 404 will be returned in normal use if the script is not available.
    '''
    dset_id  = request.form['datasetIdentifier'] 
    print('debug: recieved script request for dataset "%s" ' % dset_id)
    with open('rsync.sh', 'r') as myfile:
        script=myfile.read()
    data = { 'script' : script }
    resp = Response(response=json.dumps(data),
        status=200, \
        mimetype="application/json")
    return(resp)

if __name__ == "__main__":
    app.run(host='0.0.0.0')
