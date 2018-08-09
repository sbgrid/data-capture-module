# AWS S3

To install the version of aws cli tested with this code: `pip install awscli==1.15.75`

After installation, create a file at `~/.aws/credentials` containing these lines:
`[default]`
`aws_access_key_id =`
`aws_secret_access_key =`
Fill in the two variables with information from your aws instance.

Finally, to enable DCM S3:
- `mv scn/post_upload.bash scn/post_upload_posix.bash`
- `mv scn/post_upload_s3.bash scn/post_upload.bash`

At the time of writing, more notes are available on the overall Dataverse DCM S3 integration at https://github.com/IQSS/dataverse/issues/4703
