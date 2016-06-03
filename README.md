# data-capture-module

Data Capture Module to recieve uploaded datasets, and validate checksums.

System configuration from `databank-upload` and (relevant portions of) `databank-backend roles`.
Code adapted from `sbgrid-databank`

For now:

    export FLASK_APP=dcm.py
    flask run
