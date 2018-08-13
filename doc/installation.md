# Installation Instructions

The DCM is designed to work on linux systems, and should work on most unixes.
For non-development work, CentOS 6 is *strongly recommended*. Other versions and distributions should work, but you should know what you're doing.

*This DCM creates OS accounts - install it on a stand-alone, disposable system*

- configure NFS mounts for `/deposit` (only needs to be accessable from the DCM) and `/hold` (needs to be shared by DCM and Dataverse). Note that it's possible to use AWS S3 instead of NFS if you follow the instrutions at [aws-s3.md](aws-s3.md).
- download RPM from the github [release page](https://github.com/sbgrid/data-capture-module/releases/latest "release page")
- install RPM (and necessary dependencies). The EPEL repo is assumed to be available for these dependencies, but is not strictly required if you get the dependencies from elsewhere.
- install pip dependencies (`pip install -r /opt/dcm/requirements.txt`)
- copy `/etc/dcm/rq-init-d` to `/etc/init.d/rq`, and edit if necessary (which should only be necessary if you have installed in an unexpected manner).
- copy `/etc/dcm/lighttpd-conf-dcm` to `/etc/lighttpd/lighttpd.conf`, and edit if necessary (in particulary, to *restrict access to the Dataverse application server*).
- copy `/etc/dcm/lighttpd-modules-dcm` to `/etc/lighttpd/modules.conf`, and edit if necessary (which should only be necessary if you have installed in an unexpected manner).
- copy `/etc/dcm/dcm-rssh.conf` to `/etc/rssh.conf`, and edit if necessary (which should only be necessary if you have installed in an unexpected manner).
- configure sudo for lighttpd (see `doc/config/sudoers-chage` for an example that can be placed in `/etc/sudoers.d`) and edit if necessary (which should only be necessary if you have installed in an unexpected manner).
- configure by (sigh) editing `/root/.bashrc` to set `UPLOADHOST`,`DVAPIKEY`,`DVHOSTINT`,`DVHOST` as described in `dev-installation.md`.
- Start `sshd`, `redis`, `rq`, and `lighttpd` services; create cron job to run `post_upload.bash`.


These installation instructions are relatively recent, so please feel to open an issue in the [github repo](https://github.com/sbgrid/data-capture-module/issues "DCM github issues") if you find any problems.
