#!/usr/bin/env python
# tested with Flask-0.11-py2.py3-none-any.whl
from flask import Flask
import json
app = Flask(__name__)

@app.route('/')
def hello_world():
        return 'Hello, World!'

@app.route('/ur.py', methods=['POST'])
def login():
    resp = {}
    with open('rsync.sh', 'r') as myfile:
            data=myfile.read()
    resp['script'] = data
    return json.dumps(resp)
