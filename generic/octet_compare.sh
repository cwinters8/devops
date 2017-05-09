#!/bin/bash

# Compare octet strings numerically
# Primarily for the purpose of checking version strings

# verify input
if (( $# != 2 ))
then
	echo "Please provide two octet strings to compare"
	echo "Example: $0 1.0.1 1.0.2"
	exit 1
fi

str1=$1
str2=$2

# convert each string to array
arr1=($(echo $str1 | sed 's/\./ /g'))
arr2=($(echo $str2 | sed 's/\./ /g'))

# convert null octets to zeros if one array is longer than the other
if (( ${#arr1[@]} > ${#arr2[@]} ))
then
	for i in $(eval echo "{0..$((${#arr1[@]}-1))}")
	do
		if [[ -z ${arr2[$i]} ]]
		then
			arr2[$i]=0
		fi
	done
elif (( ${#arr1[@]} < ${#arr2[@]} ))
then
	for i in $(eval echo "{0..$((${#arr2[@]}-1))}")
	do
		if [[ -z ${arr1[$i]} ]]
		then
			arr1[$i]=0
		fi
	done
fi

# temp for testing
echo "Array 1: ${arr1[@]}"
echo "Array 2: ${arr2[@]}"
#exit

# some vars useful for calculating
length=${#arr2[@]}

# comparison loop
for i in $(eval echo "{0..$((${length}-1))}")
do
	# if arr1[$i] is greater than arr2[$i], quit and return 1
	if [ ${arr1[$i]} -gt ${arr2[$i]} ]
	then
		retval=1
		echo "quitting: ${arr1[$i]} > ${arr2[$i]}"
		echo $retval
		exit
	# if arr1[$i] is less than arr2[$i], quit and return -1
	elif [ ${arr1[$i]} -lt ${arr2[$i]} ]
	then
		retval=-1
		echo "quitting: ${arr1[$i]} < ${arr2[$i]}"
		echo $retval
		exit
	# if arr1[$i] and arr2[$i] are the same, return 0 and continue checking
	else
		retval=0
		echo "passed: ${arr1[$i]} = ${arr2[$i]}"
	fi
done

# once out of octets to check, return 0
echo $retval
exit
