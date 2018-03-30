# data-capture-module

Data Capture Module to recieve uploaded datasets, and validate client-side checksums.

In more general terms, this is an external module designed to allow users to upload large datasets to a repository (designed for [https://github.com/IQSS/dataverse](Dataverse)) without going through http.

The [https://osf.io/wf24a](presentation slides) from the 2017 Dataverse Community Meeting may provide some additional information.
The design is intented to be agnostic to transfer protocol, and currently implements `rsync over ssh`.

## DCM installation
See [doc/installation.md](installation instructions) for DCM installation instructions, and the [http://guides.dataverse.org](Dataverse Guides) for configuring the two systems together.

### general organization
- `api/` : external interface that repository software will call
- `gen/` : transfer script generation for `rsync+ssh` uploads
- `scn/` : scanning for completed uploads, and handling related tasks


