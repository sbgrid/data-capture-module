# DCM Documentation

contents:

- [components.md](DCM components)
- [installation.md](installation instructions)
- [api.md](API documentation)
- [gen.md](generator documentation)
- [scn.md](scanner documentation)
- [mock.md](mock API endpoint documentation)

## the story of a depositor, a dataset, a repository, and a DCM
- depositor creates dataset (in repository frontend)
- repository frontend notifies DCM; DCM takes necessary steps to recieve dataset deposition 
- repository frontend requests transfer script from DCM, and provides transfer script to depositor
- depositor runs transfer script (which asks the user for the dataset directory, calculates checksums for data files, and transfers the data files)
- a periodic process on the DCM checks for the presence of a manifest file containing data file checksums
- the DCM attempts to verify the integrity of the data files using the checksums in the manifest file
- if file integrity can not be verified, the repository frontend is notified of the failure (with the intent that the depositor, curator(s), and/or system administrator(s) can be notified). In usual practice, most problems can be resolved by the depositor re-running the transfer script.
- if file integrity is verified, the DCM moves the data files to the appropriate location and notifies the repository frontend

