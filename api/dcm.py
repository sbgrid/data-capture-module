#!/usr/bin/env python
# tested with:
# - Flask-0.11-py2.py3-none-any.whl on Python 2.7 (OS X 10.10)
# - python-flask-0.9-7.el6.noarch on Python 2.6 (CentOS 6)
from flask import Flask, Response
import json
app = Flask(__name__)

@app.route('/')
def hello_world():
        return 'Hello, World!'

@app.route('/ur.py', methods=['POST'])
def upload_request():
    data = {}
    data['status'] = 'OK'
    resp = Response(response=json.dumps(data),
        # FIXME: Should this be 201 instead?
        status=200, \
        mimetype="application/json")
    return(resp)

@app.route('/sr.py/<int:dataset_id>', methods=['GET'])
def script_request(dataset_id):
    data = {}
    data['datasetId'] = dataset_id
    with open('rsync.sh', 'r') as myfile:
            data=myfile.read()
    data['script'] = data
    resp = Response(response=json.dumps(data),
        status=200, \
        mimetype="application/json")
    return(resp)

if __name__ == "__main__":
    app.run(host='0.0.0.0')
