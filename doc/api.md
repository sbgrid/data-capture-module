# API docs

Still tentative (but less so now) API docs

## endpoints
### generate transfer script
`http://$host/ur.py` : payload (`POST`, although request type isn't currently enforced) containing JSON encoded messages sufficient to generate a transfer account for a specified dataset. 

- `datasetIdentifier`: identifier for the dataset, will be used as the landing directory and home directory for transfer account
- `userId` : identifier for the user (key name and which identifier TBD)
- `datasetId` : primary key identifier for the dataset, not used internally but should be passed back to dataverse

If this endpoints is called multiple times with the same datasetIdentifier, only the first request will be processed - others will be ignored.
This is **NOT** reflected in the return code from `ur.py`.

Return value of HTTP 200 / `{"status":"OK"}` means that the request was recieved; not that the request was successfully processed (semanticly this should be a different HTTP status code, but changing that broke other case).

### query / recieve transfer script
Endpoint, parameters and behaviours.

`http://$host/sr.py`

parameters: 

- `datasetIdentifier`: same `datasetIdentifier` as for `ur.py`
- other parameters may be present, but are ignored for this call


response: 404 code and empty response means the script isn't ready yet; 200 and json dictionary with additional key `script` containing the generated upload script, and other keys sent to `ur.py`

Also note that these paramters are not JSON encoded; straight form parameters (see `dcm-test02.sh` in the ansible role for a curl example).

With current configuration, this will also increment the expiration time on a transfer account.
Transfer accounts for which the dataset has been successfully validated will not be re-enabled by this (which is intentional).

### post-upload
checksum validation success or failure.
` { "userId":"$bar", "datasetId" : "$foo" , "status" : "$status","datasetIdentifier":"$baz"}`
status either "validation passed" or "validation failed"

example: `$DATAVERSE_URL/api/datasets:persistentId/dataCaptureModule/checksumValidation?persistentId=$DATASETID`

**FIXME** There is an additional failure mode that dataverse is not currently notified of: problems moving files out of the upload filesystem.

