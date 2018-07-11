#!/bin/bash
# Startup script for s3fs

echo "$(date +"%D %T") Starting s3fs..." > /root/startup/s3fs_boot.log
/bin/s3fs mti-fileshare /s3-fileshare -o iam_role -o allow_other -o nonempty >> /root/startup/s3fs_boot.log

if [ $? == 0 ]; then
    echo "$(date +"%D %T") s3fs started" >> /root/startup/s3fs_boot.log
else
    echo "$(date +"%D %T") An error occurred. s3fs failed to start." >> /root/startup/s3fs_boot.log

exit
