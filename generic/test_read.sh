#!/bin/bash

read -p "Are you sure you want to drop ${SID}? (y/n)" -n 1 
echo
echo $REPLY

if [[ $REPLY == 'n' ]]
then
    echo "User cancelled operation." 
    exit 1
else
    echo "Invalid response"
fi
