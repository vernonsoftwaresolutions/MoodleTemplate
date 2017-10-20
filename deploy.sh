#!/bin/bash

aws s3 cp config.php s3://moodle-deployables 
aws cloudformation package --template-file moodletemplate.yml --output-template-file moodletemplate-output.yml --s3-bucket moodle-deployables
aws cloudformation deploy --template-file moodletemplate-output.yml --capabilities CAPABILITY_IAM --stack-name "${STACK_NAME}" --parameter-overrides Tenant=CompanyA InstanceType=t2.micro DBInstance="${STACK_NAME}" DBName="${STACK_NAME}" DBIsMultiZone=false KeyName=SANDBOX CertBucket=moodle-deployables HostedZoneName=vssdevelopment.com. MoodleDNSName="${PROD_HOST}"
#curl http://"${PROD_HOST}"
#aws cloudformation delete-stack --STACK_NAME "${STACK_NAME}"
