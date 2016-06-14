# API docs

**TENTATIVE** API docs

## endpoints
### generate transfer script
`http://$host/ur.py` : payload (`POST`, although request type isn't currently enforced) containing JSON encoded messages sufficient to generate a transfer account for a specified dataset. 

- `uid`: identifier for the dataset, will be used as the landing directory and home directory for transfer account
- identifier for the user (key name and which identifier TBD)

### query / recieve transfer script
Endpoint, parameters and behaviours **TDB**.


