# data-capture-module

Data Capture Module to recieve uploaded datasets, and validate checksums.

System configuration from `databank-upload` and (relevant portions of) `databank-backend roles`.
Code adapted from `sbgrid-databank`.

Significant code cleanup (removal of hard-coded information) remains to be done.

## system configuration
ansible roles are ported and (somewhat) consolidated.
Assumed to be CentOS 6 (which isn't checked)

- `FRONTEND_IP` is the address of the server making requests (aka - the server requesting upload information, not the end-user's IP).

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


For now:

    python dcm.py

