# data-capture-module

Data Capture Module to recieve uploaded datasets, and validate client-side checksums.

In more general terms, this is an external module designed to allow users to upload large datasets to a repository (designed for [https://github.com/IQSS/dataverse](Dataverse)) without going through http.

The [https://osf.io/wf24a](presentation slides) from the 2017 Dataverse Community Meeting may provide some additional information.
The design is intented to be agnostic to transfer protocol, and currently implements `rsync over ssh`.

## documentation
More extensive documentation is in the `doc/` directory.

Significant code cleanup (removal of hard-coded information) remains to be done.

## system configuration
see [doc/installation.md](installation instructions).

### stubs to be made configurable
- username for upload script generation
- filesystem paths

### TODO
- revisit the TODO list (and move into github issues)
- clean up sshd config
- improve docs 
- lighttpd paths 

### general organization
- `api/` : external interface that repository software will call
- `gen/` : transfer script generation for `rsync+ssh` uploads
- `scn/` : scanning for completed uploads, and handling related tasks


