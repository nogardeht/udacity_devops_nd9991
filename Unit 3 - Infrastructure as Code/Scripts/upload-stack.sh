#!/bin/bash
if [[ $# -ge 4 ]]
then
    stackStatus=$(aws cloudformation describe-stacks --stack-name ${1} --output text --query "Stacks[*].{Status:StackStatus}")
    if [[ $? -eq 0 ]]
    then
        aws cloudformation update-stack --stack-name ${1} --template-body file://${2} --parameters file://${3} --region=${4}
        if [[ $? -eq 0 ]]
        then
            exit 0
        elif [[ ${5} == "-f" ]]
        then
            aws cloudformation delete-stack --stack-name ${1} --region=${4}
            sleep 10
            stackStatus=$(aws cloudformation describe-stacks --stack-name ${1} --output text --query "Stacks[*].{Status:StackStatus}")
            while [[ $stackStatus == "DELETE_IN_PROGRESS" ]]
            do
                sleep 5
                stackStatus=$(aws cloudformation describe-stacks --stack-name ${1} --output text --query "Stacks[*].{Status:StackStatus}")
            done
        fi
    fi
    aws cloudformation create-stack --stack-name ${1} --template-body file://${2} --parameters file://${3} --region=${4}
else
    echo "usage: ./upload-stack.sh <stack_name> <filename> <parameters> <region> [-f]"
fi
exit $?