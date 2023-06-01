#!/bin/bash
DISPLAYNAME="pluto"
DESCRIPTION="allow SSH and Port"
VPC="vpc-048defb2ebe5cd35e"
AMI="ami-053b0d53c279acc90"
COUNT="1"
INSTANCETYPE="t2.micro"
SUBNET="subnet-0503d32d339bd0716"
MYIP="`curl https://checkip.amazonaws.com`"
PORT1="22"
PORT2="80"
echo 
echo "Creating keypair and storing private key to $DISPLAYNAME.pem file"
aws ec2 create-key-pair --key-name "$DISPLAYNAME" --query "KeyMaterial" --output text > $DISPLAYNAME.pem
tail -2 $DISPLAYNAME.pem
sleep 2
echo
echo "Creating security group and storing in a variable"
export SG=`aws ec2 create-security-group --group-name "$DISPLAYNAME" --description "$DESCRIPTION" --vpc-id $VPC --query "GroupId" --output text`
echo "The Security Group ID is : $SG"
sleep 3
echo
echo "Assigning permisions for Inbound/Outbound Rules"
aws ec2 authorize-security-group-ingress --group-id $SG --protocol tcp --port $PORT1 --cidr "$MYIP/32"
aws ec2 authorize-security-group-ingress --group-id $SG --protocol tcp --port $PORT2 --cidr "$MYIP/32"
echo
echo "Launching instance and assigning a name $DISPLAYNAME to instance"
sleep 2
aws ec2 run-instances --image-id "$AMI" --count "$COUNT" --instance-type $INSTANCETYPE --key-name "$DISPLAYNAME" --security-group-ids $SG --subnet-id $SUBNET > $DISPLAYNAME.txt
echo "launched instance and assigned to $DISPLAY.txt file"
sleep 2
cat $DISPLAYNAME.txt | jq -r '.Instances[0].InstanceId'
echo "extracted the instanceid from the ouptput of $DISPLAYNAME.txt"
sleep 2
export INSTANCEID=`cat $DISPLAYNAME.txt | jq -r '.Instances[0].InstanceId'`
echo "The Instance Id is : $INSTANCEID"
sleep 2
aws ec2 create-tags --resource $INSTANCEID --tags Key=Name,Value="$DISPLAYNAME"

