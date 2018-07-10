#!/usr/bin/env bash

# stub for testing the DCM -> DV "checksum validation failed" API

dset=EUGEQF
sz=131111836
tmpfile=/tmp/dcm_fail-$$.json

echo "{\"status\":\"validation failed\",\"uploadFolder\":\"$dset\",\"totalSize\":$sz}" > $tmpfile

cat $tmpfile | jq .
DOI_SHOULDER="10.5072"

curl -H "X-Dataverse-key: ${DVAPIKEY}" -H "Content-type: application/json" -X POST --upload-file  $tmpfile "${DVHOST}/api/datasets/:persistentId/dataCaptureModule/checksumValidation?persistentId=doi:${DOI_SHOULDER}/${dset}"


