#!/bin/bash

dir=/Users/clark.wintersibm.com/Clark-Winters/devops_testing/files
filename=sds.tar.gz
filepath=${dir}/$filename
bucket=clark-binaries
resource="/${bucket}/${filename}"
contentType="application/x-compressed-tar"
dateValue=`date -R`
stringToSign="PUT\n\n${contentType}\n${dateValue}\n${resource}"
signature=`echo -en ${stringToSign} | openssl sha1 -binary | base64`

curl -X PUT -T "${filepath}" \
  -H "Host: ${bucket}.s3.amazonaws.com" \
  -H "Date: ${dateValue}" \
  -H "Content-Type: ${contentType}" \
  https://${bucket}.s3.amazonaws.com/${filename}

ansible local -m s3 -a 'mode=list bucket=clark-binaries'
