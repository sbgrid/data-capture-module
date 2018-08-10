#!/usr/bin/env python

from flask import Flask
from unittest import TestCase
import dcm
import json
import requests

class TestDCMMock(TestCase):
    def setUp(self):
        dcm.app.testing=True
        self.app=dcm.app.test_client()
    def test_ur0(self):
        r=self.app.post('/ur.py',data=json.dumps({'datasetId':'d0','userId':'u0'}), content_type='application/json')
        self.assertEqual(200, r.status_code)
        j_r = json.loads( r.get_data() )
        j_e = {'status':'OK'}
        # I miss assertDictEqual...
        self.assertEqual( len(j_e), len(j_r) )
        self.assertEqual( j_e.keys()[0], j_r.keys()[0] )
        self.assertEqual( j_e['status'], j_r['status'])
    def test_sr0(self):
        r = self.app.post('/sr.py',data={'datasetIdentifier':'d0'})
        self.assertEqual(200, r.status_code)
        x_e={'datasetIdentifier':'d0','userId':'42','script':'placeholder'}
        x_r = json.loads( r.get_data() )
        self.assertEqual( len(x_e), len(x_r) )
        for k_e in x_e.keys():
            self.assertIn( k_e, x_e.keys() ) #yes, inefficient
            if 'script' != k_e:
                self.assertEqual( x_e[k_e], x_r[k_e] )
