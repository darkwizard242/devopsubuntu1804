#!/bin/bash -eux

# Check if python3-pip is install. If installed, then install aws-cli
apt list --installed | grep python3-pip
if [ $? -eq 0 ];
then
	echo "python3-pip is installed. Ready to install AWS CLI!"
	python3 -m pip install awscli
else
	echo "python3-pip is not installed. It is a pre-requisite for AWS CLI."
fi