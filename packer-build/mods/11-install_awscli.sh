#!/bin/bash -e

# Shellcheck fixes for: SC2181

# Check if python3-pip is install. If installed, then install aws-cli

if which pip3;
then
	echo -e "\npip3 is installed. Ready to install: AWS CLI!\n"
	python3 -m pip install awscli
else
	echo -e "\npython3-pip is not installed. It is a pre-requisite for AWS CLI.\n"
fi