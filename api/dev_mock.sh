#!/bin/sh

# wrapper for running DCM mock flask server
FLASK_APP=dcm FLASK_DEBUG=1 python -m flask run -h 0.0.0.0
