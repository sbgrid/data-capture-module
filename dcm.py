#!/usr/bin/env python
# tested with:
# - Flask-0.11-py2.py3-none-any.whl on Python 2.7 (OS X 10.10)
# - python-flask-0.9-7.el6.noarch on Python 2.6 (CentOS 6)
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

if __name__ == "__main__":
    app.run(host='0.0.0.0')
