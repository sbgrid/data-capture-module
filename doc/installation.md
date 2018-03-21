# Installation Instructions

There may still be bugs in this documentation, but there should be fewer.

The DCM is designed to work on linux systems, and should work on most unixes.
For non-development work, CentOS 6 is *strongly recommended*. Other versions and distributions should work, but you should know what you're doing.

*This DCM creates OS accounts - install it on a stand-alone, disposable system*

- configure NFS mounts for `/deposit` (only needs to be accessable from the DCM) and `/hold` (needs to be shared by DCM and Dataverse).
- download RPM (*TODO* link once it's available on github)
- install RPM (and necessary dependencies). The EPEL repo is assumed to be available for these dependencies, but is not strictly required if you get the dependencies from elsewhere.
- install pip dependencies (`pip install -r /opt/dcm/requirements.txt`)
- copy `/etc/dcm/rq-init-d` to `/etc/init.d/rq`, and edit if necessary
- copy `/etc/dcm/lighttpd-conf-dcm` to `/etc/lighttpd/lighttpd.conf`, and edit if necessary.
- copy `/etc/dcm/lighttpd-modules-dcm` to `/etc/lighttpd/modules.conf`, and edit if necessary.
- copy `/etc/dcm/dcm-rssh.conf` to `/etc/rssh.conf`, and edit if necessary.
- configure sudo for lighttpd (see `doc/config/sudoers-chage` for an example that can be placed in `/etc/sudoers.d`).
- configure by (sigh) editing `/root/.bashrc` to set `UPLOADHOST`,`DVAPIKEY`,`DVHOSTINT`,`DVHOST` as described in `dev-installation.md`.
- Start `sshd`, `redis`, `rq`, and `lighttpd` services; create cron job to run `post_upload.bash`.


