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

S3HOLD=test-dcm

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
	ulidFolder=`basename $ddir` #this does not have the pid / in it. We alredy did special char filtering before

	# the real ulid (pid) from dataverse with the shoulder (usually FK2/...)
	ulidFromJson="$(cat $DEPOSIT/processed/${ulidFolder}.json | jq -r .datasetIdentifier)"

	echo $indicator_file " : " $ddir " : " $ulidFolder " : " $ulidFromJson

	# verify checksums prior to moving dataset
	cd ${DEPOSIT}/${ulidFolder}/${ulidFolder} 
	nl=`wc -l files.sha | awk '{print $1}'`
	shasum -s -c files.sha 
	err=$?

	if (( ( $err != 0 ) || ( $nl == 0 ) )); then
		# handle checksum failure
		mv files.sha files-`date '+%Y%m%d-%H:%M'`.sha # rename previous indicator file
		echo "checksum failure"
		tmpfile=/tmp/dcm_fail-$$.json
		echo "{\"status\":\"validation failed\",\"uploadFolder\":\"${ulidFromJson}\",\"totalSize\":0}" > $tmpfile 
		curl --insecure -H "X-Dataverse-key: ${DVAPIKEY}" -H "Content-type: application/json" -X POST --upload-file $tmpfile "${DVHOST}/api/datasets/:persistentId/dataCaptureModule/checksumValidation?persistentId=doi:${DOI_SHOULDER}/${ulidFromJson}"
	else
		# handle checksum success
		echo "checksums verified"

		#move to HOLD location
		
		if [ ! `aws s3 ls s3://${S3HOLD}/${ulidFromJson}/`]; then    #this check is different than normal post_upload, we don't use the extra folder level
			#MAD: Here we'll need to make the package a zip and upload it
			#This probably will need a new checksum, I forget how we're doing that...
			#will need to install zip
			#yum install zip #not here

			#MAD: Should we be zipping to a different temp location?
			packageName="package_$ulidFolder"
			packageExt="zip"
			#Am i correctly cleaning up my new files?
			echo "beginning zip of ${DEPOSIT}/${ulidFolder}/${ulidFolder}/"
			cd ${DEPOSIT}/${ulidFolder}/

			#It would be awesome to someday zip everything while it is being streamed.
			zip -r $packageName ${ulidFolder}/ #There are two layers of ${ulidFolder}



			#shasum $(find . -type f) > $checksumfile 
			shasum ${packageName}.${packageExt} > ${packageName}.sha

			echo "test: ${DEPOSIT}/${ulidFolder}/$packageName"
			aws s3 cp ${packageName}.${packageExt} s3://${S3HOLD}/${ulidFromJson}/ #this does not copy empty folders from DEPOSIT as folders do not actually exist in s3
			aws s3 cp ${packageName}.sha s3://${S3HOLD}/${ulidFromJson}/ #this does not copy empty folders from DEPOSIT as folders do not actually exist in s3

			err=$?
			if (( $err != 0 )) ; then
				echo "dcm: file move $ulid" 
				break
			fi
			rm -rf ${ulidFolder}
			rm -rf $packageName
			echo "data moved"
			tmpfile=/tmp/dcm_fail-$$.json # not caring that the success tmp file has "fail" in the name

			sz=`aws s3 ls --summarize --human-readable s3://${S3HOLD}/${ulidFromJson}/$packageName | grep "Total Size: " | cut -d' ' -f 6`

			echo "{\"status\":\"validation passed\",\"uploadFolder\":\"${ulidFromJson}\",\"totalSize\":$sz}" > $tmpfile 


			dvr=`curl -s --insecure -H "X-Dataverse-key: ${DVAPIKEY}" -H "Content-type: application/json" -X POST --upload-file $tmpfile "${DVHOST}/api/datasets/:persistentId/dataCaptureModule/checksumValidation?persistentId=doi:${DOI_SHOULDER}/${ulidFromJson}"`
			dvst=`echo $dvr | jq -r .status` #jq errors when dataverse returns a 500 because it returns it as html

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
			echo "handle error - duplicate upload id $ulidFolder"
			echo "problem moving data; bailing out"
			#TODO - dv isn't listening for this error condition
			break #FIXME - this breaks out of the loop; aborting the scan (instead of skipping this dataset)
		fi

		#Dataverse does not actually need this file so we aren't going to store it to s3
		#aws s3 cp $DEPOSIT/processed/${ulidFolder}.json s3://${S3HOLD}/stage/
		cd ../..
		rm $DEPOSIT/processed/${ulidFolder}.json
		#de-activate key (still in id_dsa.pub if we need it)
		rm ${DEPOSIT}/${ulidFolder}/.ssh/authorized_keys
	fi
done

echo "post_upload completed at " `date`
