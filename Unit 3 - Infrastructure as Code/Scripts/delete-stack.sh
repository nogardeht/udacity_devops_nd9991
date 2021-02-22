#!/bin/bash
if [[ $# -ge 4 ]]
then
    stackStatus=$(aws cloudformation describe-stacks --stack-name ${1} --output text --query "Stacks[*].{Status:StackStatus}")
    if [[ $? -eq 0 ]]
    then
        aws cloudformation delete-stack --stack-name ${1} --region=${4}
        if [[ $? -eq 0 ]]
        then
            sleep 5
            stackStatus=$(aws cloudformation describe-stacks --stack-name ${1} --output text --query "Stacks[*].{Status:StackStatus}")
            while [[ $stackStatus == "DELETE_IN_PROGRESS" ]]
            do
                sleep 5
                stackStatus=$(aws cloudformation describe-stacks --stack-name ${1} --output text --query "Stacks[*].{Status:StackStatus}")
            done
        else
            echo "Delete failed: stack status is ${stackStatus}"
        fi
    else
        echo "Delete not executed: stack status is ${stackStatus}"
    fi
else
    echo "usage: ./delete-stack.sh <stack_name> <region>"
fi
exit $?