# data-capture-module

Data Capture Module to recieve uploaded datasets, and validate checksums.

In more general terms, this is an external module designed to allow users to upload large datasets to a repository without going through http.
The design is intented to be agnostic to transfer protocol, and currently implements `rsync over ssh`.


Significant code cleanup (removal of hard-coded information) remains to be done.

## system configuration
System configuration and software setup is handled through ansible.
There are several roles currently in use, and in some cases configuration settings need to be setup prior to running ansible (or `vagrant up` / `docker create`).
These should be in the `vars/` directory for the respective roles (although the process of making sure this is set up is ongoing).
These roles assume CentOS 6, and may work on other rpm based systems - extending to other distributions should not be problematic if it becomes necessary.

These ansible scripts explicity *DO NOT* handle integration with file servers or other storage layers.

### stubs to be made configurable
- username for upload script generation
- filesystem paths

### TODO
- clean up sshd config
- improve docs 
- lighttpd paths 
- revisit the TODO list

## code

### general organization
- `api/` : external interface that repository software will call
- `gen/` : transfer script generation for `rsync+ssh` uploads
- `scn/` : scanning for completed uploads, and handling related tasks

## documentation
More extensive documentation is in the `doc/` directory.

