# API docs

**TENTATIVE** API docs

## endpoints
### generate transfer script
`http://$host/ur.py` : payload (`POST`, although request type isn't currently enforced) containing JSON encoded messages sufficient to generate a transfer account for a specified dataset. 

- `datasetIdentifier`: identifier for the dataset, will be used as the landing directory and home directory for transfer account
- `userId` : identifier for the user (key name and which identifier TBD)
- `datasetId` : primary key identifier for the dataset, not used internally but should be passed back to dataverse

*TODO* this should be not fail if this endpoint is called multiple times for the same script


### query / recieve transfer script
Endpoint, parameters and behaviours.

`http://$host/sr.py`

parameters: 

- `datasetIdentifier`: same `datasetIdentifier` as for `ur.py`
- other parameters may be present, but are ignored for this call


response: 404 code and empty response means the script isn't ready yet; 200 and json dictionary with additional key `script` containing the generated upload script, and other keys sent to `ur.py`


### post-upload
checksum validation success or failure.
` { "userId":"$bar", "datasetId" : "$foo" , "status" : "$status","datasetIdentifier":"$baz"}`
status either "validation passed" or "validation failed"

example: `$DATAVERSE_URL/api/datasets:persistentId/dataCaptureModule/checksumValidation?persistentId=$DATASETID`

