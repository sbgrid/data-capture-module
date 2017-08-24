# Installation Instructions

The DCM is designed to work on linux systems, and should work on most unixes.
These instructions (*currently*) assume the system is being configured with ansible, and are configuring a CentOS 6 system which isn't being used for other purposes.
The docker image is currently experimental.

## Quickstart
- using `secrets.yml.template` as a template to create `secrets.yml`
- configure the hostlist as appropriate
- run the playbook: `cd ansible; ansible-playbook -i dev.hostlist dcm.yml`

## Dependencies
Highlights from `dcm/tasks/config.yml` "package install" entry
- `lighttpd` : external interface for Dataverse to communicate with the DCM
- `sshd`, `rsync` : for keypair generation and recieving uploads
- `perl-Digest-SHA` : for checksum verification
- `rssh` : default shell for upload accounts to prevent interactive login

## Configuration options
### `dcm/vars/main.yml`
- `FRONTEND_IP` : IP address or hostname of system allowed to send requests (for upload scripts/tokens) to the DCM; this is handled by refusing `lighttpd` connections from other hosts.
- `DCM_PATH` : local filesystem path for the DCM software to be installed to.  Installation is currently handled by cloning the repository, although there isn't a strict requirement for it to be handled that way.
- `DCM_USER`, `DCM_GROUP` : local username and group for the DCM to run under
- `DCM_UID`, `DCM_GID` : for NFS compatability, UID,GID of DCM user
- `UPLOAD_DIRECTORY` : base directory for recieving datasets, and transfer account home directories
- `HOLD_DIRECTORY` : base directory for where datasets are transfered to after checksum validation

### `dcm/vars/secrets.yml`
- `UPLOADHOST` : IP address or hostname users will use for transferring datasets to
- `DVAPIKEY` : Dataverse API key with appropriate permissions the DCM.  Current assumption is that this is an admin key (aka - it's a system account, not a user account).
- `DVHOSTINT` : IP address or hostname for Dataverse instance the DCM will be sending messags to.  This will frequently be the same as `FRONTEND_IP`, but there is no requirement for the two to be the same. *obscolete - use `DVHOST`*
- `DVHOST` : protocol, host, and port (if necessary) for DCM to communicate with Datverse API endpoints.  Currently calls the batch-import APIs (`api/batch/jobs/import/datasets/files/$doi`) on validation success; will call other APIs on failure when those are implemented.

## Vagrant Notes
- CentOS 6 vagrant box used for testing has some version dependencies: 1.1.3 and 1.0.7 are known tow work, others may have issues. In principle, any CentOS 6 box should work.
- For vagrant shared filesystems (aka using shared folders to simulate NFS for local development/testing), glassfish needs to be run as root (aka - running glassfish as non-root user doesn't play nicely with shared folders mapped to vagrant user).

