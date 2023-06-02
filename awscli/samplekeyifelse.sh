#!/bin/bash
KEY=tecton
aws ec2 describe-key-pairs --key-name $KEY &>> /dev/null

if [ $? -eq 0 ]

then 

echo "keypair exists"

else

echo " Creating New Keypair with name : $KEY"
aws ec2 create-key-pair --key-name "$KEY" --query "KeyMaterial" --output text > $KEY.pem
fi

