#!/bin/bash
# Startup script for s3fs
# Update PASSWD_FILE variable as needed

PASSWD_FILE="/Users/clarkwinters/.passwd-s3fs"

mkdir -p /root/startup

echo "$(date +"%D %T") Starting s3fs..." > /root/startup/s3fs_boot.log
/usr/local/bin/s3fs vbs-justice /s3-vbs-justice -o allow_other -o umask=0000 -o passwd_file=$PASSWD_FILE >> /root/startup/s3fs_boot.log
/usr/local/bin/s3fs mti-fileshare /s3-mti-fileshare -o allow_other -o umask=0000 -o passwd_file=$PASSWD_FILE >> /root/startup/s3fs_boot.log

if [ $? == 0 ]; then
    echo "$(date +"%D %T") s3fs started" >> /root/startup/s3fs_boot.log
else
    echo "$(date +"%D %T") An error occurred. s3fs failed to start." >> /root/startup/s3fs_boot.log
fi

exit
