#!/usr/bin/env bash

# post upload scanning (checksums and data movement)

echo "post_upload starting at " `date`

LOCKFILE=/var/run/post_upload.pid
source /root/.bashrc # for DVAPIKEY

if [ -z "$DVAPIKEY" ]; then
	echo "error - need a dataverse API key configured (DCM -> DV communications) "
	exit 1
fi
if [ -z "$DVHOST" ]; then # includes protocol,host,port in this as well
	echo "error - need a dataverse host configured"
	exit 1
fi

if [ -z "${DOI_SHOULDER}" ]; then
	echo "warning - using test DOI shoulder because one isn't configured"
	DOI_SHOULDER="10.5072"
fi

#TODO - make configurable
DEPOSIT=/deposit
HOLD=/hold
retry_delay=60
SRC=/opt/dcm/

if [ -e $LOCKFILE ]; then
	echo "post_upload scan still in progress at " `date` " , aborting"
	exit
fi
echo $$ > $LOCKFILE
trap "rm -f '$LOCKFILE'" EXIT




# scan for indicators
for indicator_file in `find $DEPOSIT -name files.sha`
do



	ddir=`dirname $indicator_file`
	ulid=`basename $ddir`

	#MAD CODE BEGIN
	ulidFromJson="$(grep -Po '"'"datasetIdentifier"'"\s*:\s*"\K([^"]*)' $DEPOSIT/processed/${ulid}.json)"
	echo "$ulidFromJson"
	#exit
	#MAD CODE END

	echo $indicator_file " : " $ddir " : " $ulid

	# verify checksums prior to moving dataset
	cd ${DEPOSIT}/${ulid}/${ulid} 
	nl=`wc -l files.sha | awk '{print $1}'`
	shasum -s -c files.sha 
	err=$?

	if (( ( $err != 0 ) || ( $nl == 0 ) )); then
		# handle checksum failure
		mv files.sha files-`date '+%Y%m%d-%H:%M'`.sha # rename previous indicator file
		echo "checksum failure"
		tmpfile=/tmp/dcm_fail-$$.json
		echo "{\"status\":\"validation failed\",\"uploadFolder\":\"$ulidFromJson\",\"totalSize\":0}" > $tmpfile 
		curl --insecure -H "X-Dataverse-key: ${DVAPIKEY}" -H "Content-type: application/json" -X POST --upload-file $tmpfile "${DVHOST}/api/datasets/:persistentId/dataCaptureModule/checksumValidation?persistentId=doi:${DOI_SHOULDER}/${ulidFromJson}"
	else
		# handle checksum success
		echo "checksums verified"

		#move to HOLD location
		datasetIdentifier=${ulid} 
		if [ ! -d ${HOLD}/${ulidFromJson}/${ulidFromJson} ]; then
		#if true; then
			#change to subdirectory to match batch-import code changes
			mkdir -p ${HOLD}/${ulidFromJson}

#MAD: I was letting dcm keep the weird-truncated naming structure from pids, but its then copying that over now
#... no it actually looks ok
			cp -a ${DEPOSIT}/${ulid}/${ulid}/ ${HOLD}/${ulidFromJson}/
			# TODO - config for gf user
			chown -R glassfish:glassfish ${HOLD}/${ulidFromJson}/
			err=$?
			if (( $err != 0 )) ; then
				echo "dcm: file move $ulid" 
				break
			fi
			rm -rf ${DEPOSIT}/${ulid}/${ulid}
			
			echo "data moved"
			tmpfile=/tmp/dcm_fail-$$.json # not caring that the success tmp file has "fail" in the name
			sz=`du -sb ${HOLD}/${ulidFromJson} | awk '{print $1} '`
			echo "{\"status\":\"validation passed\",\"uploadFolder\":\"$datasetIdentifier\",\"totalSize\":$sz}" > $tmpfile 

			#MAD: Here we need to pull the uid from the json $DEPOSIT/processed/${ulid}.json






			dvr=`curl -s --insecure -H "X-Dataverse-key: ${DVAPIKEY}" -H "Content-type: application/json" -X POST --upload-file $tmpfile "${DVHOST}/api/datasets/:persistentId/dataCaptureModule/checksumValidation?persistentId=doi:${DOI_SHOULDER}/${ulidFromJson}"`
			dvst=`echo $dvr | jq -r .status`
			if [ "OK" != "$dvst" ]; then
				#TODO - this block should email alerts queue
				echo "ERROR: dataverse at ${DVHOST} had a problem handling the DCM success API call"
				if [ "DVHOST" == "${DVHOST}" ]; then
					echo "DVHOST == DVHOST; assuming internal test without Dataverse and not retrying"
				else
					echo "$dvr"
					echo "will retry in $retry_delay seconds"
					sleep $retry_delay
					dvr_rt=`curl -s --insecure -H "X-Dataverse-key: ${DVAPIKEY}" -H "Content-type: application/json" -X POST --upload-file $tmpfile "${DVHOST}/api/datasets/:persistentId/dataCaptureModule/checksumValidation?persistentId=doi:${DOI_SHOULDER}/${ulidFromJson}"`
					dvst_rt=`echo $dvr | jq -r .status`
					if [ "OK" != "$dvst_rt" ]; then
						echo "ERROR: retry failed, will need to handle manually"
					else
						echo "ERROR: retry succeeded"
					fi
				fi
			fi
		else
			echo "handle error - duplicate upload id $ulid"
			echo "problem moving data; bailing out"
			#TODO - dv isn't listening for this error condition
			break #FIXME - this breaks out of the loop; aborting the scan (instead of skipping this dataset)
		fi
		
		mv $DEPOSIT/processed/${ulid}.json $HOLD/stage/
		#de-activate key (still in id_dsa.pub if we need it)
		rm ${DEPOSIT}/${ulid}/.ssh/authorized_keys
	fi
done

echo "post_upload completed at " `date`
