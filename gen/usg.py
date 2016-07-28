#!/usr/bin/env python

'''
upload script generator
'''


import commands
import datetime
import json
import glob
import os
import os.path
import sys

HOMEDIR = 'deposit' # upload directory
DURATION_DAYS = 7 # number of days upload accounts will be active
UPLOADHOST = 'dcm-dev.internal' # hostname that uploads will land on
TEMPLATE = '/usr/local/dcm/gen/upload_script.m4' 
LOCKFILE = '/var/run/usg.pid'

BCCS = []

def err(msg):
    print(msg)
    sys.exit(1)

def create_temporary_account(uid):
    ''' create temporary account from upload id
    '''
    def set_expdate(duration):
        x = datetime.date.today() + datetime.timedelta(days=duration)
        return x.isoformat()
    # transfer only account
    expdate = set_expdate(DURATION_DAYS) #account expiration date
    cmd0 = 'useradd --create-home -g upload --no-user-group --home-dir /%s/%s -s /usr/bin/rssh --inactive 0 --expiredate %s %s ' % ( HOMEDIR, uid, expdate, uid, ) 
    (e0, r0) = commands.getstatusoutput( cmd0 )
    if 0 != e0:
        print(cmd0)
        print(r0)
        print(e0)
        err('problem creating user %s' % uid)

    # keypair; empty passphrase
    # it actually makes more sense to use a fixed name for the key
    cmd1 = 'sudo -u %s ssh-keygen -q -t dsa -P "" -f /%s/%s/.ssh/id_dsa ' % ( uid, HOMEDIR, uid, ) 
    (e1, r1) = commands.getstatusoutput( cmd1 )
    if 0 != e1:
        err('problem creating key for %s (%s)' % (uid,r1) )

    # create authorized_keys file w\ new pubkey
    cmd2 = 'sudo -u %s cp /%s/%s/.ssh/id_dsa.pub /%s/%s/.ssh/authorized_keys' % (uid, HOMEDIR,  uid, HOMEDIR, uid, )
    (e2, r2) = commands.getstatusoutput( cmd2 )
    if 0 != e2:
        err('problem adding key to authorized_keys for %s (%s)' % (uid,r2) )
    cmd3 = 'sudo -u %s chmod og-r /%s/%s/.ssh/authorized_keys' % (uid, HOMEDIR, uid, )
    (e3, r3) = commands.getstatusoutput( cmd3 )
    if 0 != e3:
        print(cmd3)
        print(r3)
        err('problem with permission change for authorized_keys for %s (%s)' % (uid,r3) )

def generate_upload_script(uid):
    cmd0 = 'cd /%s/%s ; sudo -u %s m4 -D UPLOADHOST=%s -D UID=%s %s > upload-%s.bash' % (HOMEDIR, uid, uid, UPLOADHOST, uid, TEMPLATE,uid) #upload permission will be owned by system user, not upload user - shouldn't matter
    #redirect is in home directories; no concurrency problem.
    (e0, r0) = commands.getstatusoutput( cmd0 )
    if 0 != e0 :
        print(cmd0)
        print(r0)
        err('problem generating upload script for %s' % uid)
    # return path to the script for simpler emailing
    fn = '/%s/%s/upload-%s.bash' % ( HOMEDIR, uid, uid )
    return fn
    

def proc( req_file, verbose = True ):
    inp = open( req_file, 'r' )
    x = json.load( inp )
    inp.close()
    uid = x['uid']
    if verbose:
        print('request uid = %s ' % uid )

    create_temporary_account( uid )
    _ = generate_upload_script( uid )
    return uid

def test1():
    uid='u17'
    create_temporary_account(uid)

def test2():
    uid='u17'
    generate_upload_script( uid )

def proc_requests( req_dir = '/deposit/requests', done_dir = '/deposit/processed'):
    n = datetime.datetime.now()
    print('usg.py runnning at %s' % n )
    if not lock_init():
        print('usg.py already running; bailing out')
        sys.exit()
    else:
        print('usg.py - aquiring lock')

    print('processing requests in %s' % req_dir )
    reqs = glob.glob( '%s/*.json' % req_dir )
    print(reqs)
    for req in reqs:
        try:
            print('processing request file %s ' % req )
            ulid = proc( req )
            fn = '%s.json' % ulid
            os.rename( req, os.path.join( done_dir, fn ) )
        except Exception, e : #probably bad practice; should catche more specific exceptions
            print('error processing request file %s' % req )
            print(e)
            raise 
    print('usg.py - releasing lock')
    lock_final()
    print('usg.py - done')

def lock_init():
    '''
    primitive, not-fully-atomic lockfile initialization to prevent multiple instances running
    simultaneously
    '''
    if os.path.exists(LOCKFILE):
        return False
    opf = open( LOCKFILE, 'w' )
    opf.write('%d' % os.getpid() )
    opf.close()
    return True

def lock_final():
    '''
    release the primitive, not-fully-atomic lockfile (if present)
    '''
    if os.path.exists( LOCKFILE ):
        os.unlink( LOCKFILE )


if __name__ == '__main__':
    #test1()
    #test2()
    proc_requests()

