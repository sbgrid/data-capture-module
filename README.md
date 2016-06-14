# data-capture-module

Data Capture Module to recieve uploaded datasets, and validate checksums.

System configuration from `databank-upload` and (relevant portions of) `databank-backend roles`.
Code adapted from `sbgrid-databank`.

Significant code cleanup (removal of hard-coded information) remains to be done.

## system configuration
ansible roles are ported and (somewhat) consolidated.
Assumed to be CentOS 6 (which isn't checked)

- `FRONTEND_IP` is the address of the server making requests (aka - the server requesting upload information, not the end-user's IP).
- `DCM_PATH` root directory for code

### stubs to be made configurable
- postfix hostname (probably depreciate this)
- username for upload script generation
- filesystem paths

### TODO
- clean up sshd config
- depreciate postfix/email configs
- reorganize tasks (NFS-related, etc)
- vagrant file and retest
- improve docs 
- lighttpd paths 
- code deployment path (and remove duplicate pulls from same repo)


## code
cleanup still in progress.

### TODO
- move hard-coded config to more configurable approach
- test things after incorporation into this repository (and dis-entangling)

`api` directory for things related to listening for messages from frontend systems.
Possibly sending messages back as well.

### TODO
- filesystem paths should be configurable (at least, base directory)
- converge on API endpoint spec (`dcm.py`, `ur.py`,`doc/api.md`)

For now:

    python dcm.py

