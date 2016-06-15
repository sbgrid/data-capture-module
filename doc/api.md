# API docs

**TENTATIVE** API docs

## endpoints
### generate transfer script
`http://$host/ur.py` : payload (`POST`, although request type isn't currently enforced) containing JSON encoded messages sufficient to generate a transfer account for a specified dataset. 

- `datasetId`: identifier for the dataset, will be used as the landing directory and home directory for transfer account
- `userId` : identifier for the user (key name and which identifier TBD)

*TODO* this should be not fail if this endpoint is called multiple times for the same script


### query / recieve transfer script
Endpoint, parameters and behaviours.

`http://$host/sr.py`

parameter: dataset identifier
response: 404 code and empty repsonse means the script isn't ready yet; 200 and json dictionary w\ single key `script`


### post-upload
checksum validation success or failure.
` { "userId":"$bar", "datasetId" : "$foo" , "status" : "$status"}`
status either "validation passed" or "validation failed"

