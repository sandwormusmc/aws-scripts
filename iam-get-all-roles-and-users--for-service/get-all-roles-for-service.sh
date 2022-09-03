#!/bin/bash

function usage(){
	echo 'Usage: '
	echo '  -x - Debug mode, prints users and roles being checked'
	echo '  -h - Print this help'
}

if [ "${1}x" == "-hx" ]; then
	usage
	exit
fi

echo "Enter service namespace, e.g. 'ses', 'ec2', etc.  Full list available by running 'aws list-namespaces'."
read SERVICE

echo -e "Checking roles that have access to $SERVICE.\n\n"
for ROLE in $(aws iam list-roles --query 'Roles[].Arn' | jq '.[]' -r); do
	if [ "${1}x" == "-xx" ]; then
		echo -n "Checking role $ROLE : ";
	fi
	RESULT=$(aws iam list-policies-granting-service-access --arn "${ROLE}" --service-namespaces "${SERVICE}" --query 'PoliciesGrantingServiceAccess[].Policies' | jq '.[]' -r;)
	if [ "${RESULT}x" == '[]x' -a "${1}x" == "-xx" ]; then
		echo "no access."
	elif [ "${RESULT}x" != '[]x' ]; then
		echo "${RESULT}"
	fi
done 

echo -e "\n\nChecking users that have access to $SERVICE.\n\n"
for USER in $(aws iam list-users --query 'Users[].Arn' | jq '.[]' -r); do
	echo -n "Checking user $USER : ";
	RESULT=$(aws iam list-policies-granting-service-access --arn "${USER}" --service-namespaces "${SERVICE}" --query 'PoliciesGrantingServiceAccess[].Policies' | jq '.[]' -r;)
	if [ "${RESULT}x" == '[]x' -a "${1}x" == "-xx" ]; then
		echo "no access."
	elif [ "${RESULT}x" != '[]x' ]; then
		echo "${RESULT}"
	fi
done
