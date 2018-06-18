# data-capture-module

Data Capture Module to recieve uploaded datasets, and validate client-side checksums.

In more general terms, this is an external module designed to allow users to upload large datasets to a repository (designed for [Dataverse](https://github.com/IQSS/dataverse)) without going through http.

The [presentation slides](https://osf.io/wf24a) from the 2017 Dataverse Community Meeting may provide some additional information.
The design is intented to be agnostic to transfer protocol, and currently implements `rsync over ssh`.

## DCM installation
See [installation instructions](doc/installation.md) for DCM installation instructions, and the [Dataverse Guides](http://guides.dataverse.org) for configuring the two systems together.

### general organization
- `api/` : external interface that repository software will call
- `gen/` : transfer script generation for `rsync+ssh` uploads
- `scn/` : scanning for completed uploads, and handling related tasks


