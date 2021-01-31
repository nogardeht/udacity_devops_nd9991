#!/bin/bash
if [[ $# -eq 4 ]]
then
    existingStack=$(aws cloudformation describe-stacks --stack-name ${1} --output text --query "Stacks[*].{Name:StackName}")
    if [[ $? -eq 0 ]]
    then
        aws cloudformation update-stack --stack-name ${1} --template-body file://${2} --parameters file://${3} --region=${4}
    else
        aws cloudformation create-stack --stack-name ${1} --template-body file://${2} --parameters file://${3} --region=${4}
    fi
else
    echo "usage: ./upload-stack.sh <stack_name> <filename> <parameters> <region>"
fi
#aws cloudformation create-stack --stack-name ${1} --template-body file://${2} --parameters ${3} --region=${4}