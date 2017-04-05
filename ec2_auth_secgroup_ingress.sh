#!/bin/bash
# Purpose: Add inbound rules to a security group. 
# Currently limited to editing a single security group at a time
# Author: Clark Winters
# Date: 04/05/2017

# dynamic variables
# TO-DO: parameterize these
targroup=launch-wizard-1
ports=(7916 20080 20081)
# set openall to True if the port should be open to the world. NOTE: This will ignore any security groups set as source.
openall=False
srcgroups=(launch-wizard-1 private-nodes)
vpc=custom-vpc

# for logging output
curdate=$(date +%Y%m%d%H%M%S)
logdir=$HOME/log
logfile=$logdir/${0}.${curdate}.log

mkdir -p $logdir
touch $logfile
# break if logfile fails to create
if [[ $? != 0 ]]
then
	echo "Failed to create logfile! Check to see if your user has write access to $HOME"
	exit 1
fi 

# static variables
protocol=tcp
output=json

# format some vars to use within CLI commands
srcgroupscsv="$(echo ${srcgroups[@]} | sed 's/ /,/g')"

# get VPC ID
vpcid=$(aws ec2 describe-vpcs --filters Name='tag-value',Values="$vpc" --output $output | grep VpcId | cut -d '"' -f4)

# get source group IDs and put them into an array
srcgroupids=($(aws ec2 describe-security-groups --filters Name=group-name,Values=$srcgroupscsv --output $output | grep -A3 GroupName | grep GroupId | cut -d '"' -f4 | tr '\n' ' '))

# get target group ID
targroupid=$(aws ec2 describe-security-groups --filters Name=group-name,Values=$targroup --output $output | grep -A3 GroupName | grep GroupId | cut -d '"' -f4)

# authorize ingress to target security group
for port in ${ports[@]}
do
	# if openall is set to True, set the port to be open to the world
	if $openall
	then
		echo "Adding world inbound rules..." | tee -a $logfile
		srcip='0.0.0.0/0'
		aws ec2 authorize-security-group-ingress --group-id $targroupid --protocol $protocol --port $port --cidr $srcip | tee -a $logfile
	# otherwise, use security groups as the source
	else
		echo "Adding inbound rules for specific security groups..." | tee -a $logfile
		for sg in ${srcgroupids[@]}
		do
			aws ec2 authorize-security-group-ingress --group-id $targroupid --protocol $protocol --port $port --source-group $sg | tee -a $logfile
		done
	fi
done


exit