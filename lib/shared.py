#!/usr/bin/env python

import re

'''
Shared functionality for DCM
'''

def ulid_check_and_sanitize ( ulid ):
    ''' check for invalid characters. Error if:
    ulid with special chars removed doesn't match orig (contains special chars)
    ulid with / removed is more than 1 character shorter (ulid contains more than 1 '/')'''
    ulidNoSpecial = re.sub(r'[^a-zA-Z0-9_/\-\.]|( ){2,}','',ulid )
    ulidNoSlash = re.sub(r'[/]|( ){2,}','',ulid )
    if ulid != ulidNoSpecial or len(ulid) > ( len(ulidNoSlash) + 1 ):
        raise ValueError('invalid pid')
        
    return ulid.replace("/","") #removing the / from the UID w/ shoulder
