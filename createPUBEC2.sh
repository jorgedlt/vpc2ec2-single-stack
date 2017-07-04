#!/usr/bin/env bash

#
# Create VPC, InternetGatewayId, Public & Private subnets with EC2
#

# jorgedlt@gmail.com - 03 MAR 2017 / 02 JUL 2017
# additional private documentation
# see - https://docs.google.com/document/d/1RdN2hbPeSvrCDTa76iZyExmVhF-Ct9iv-TcFNMRZwSU/edit


# Load ENV parameters
source ./createCFG.env

echo "Create EC2-Public"

# debug block
echo ${CYAN} ' '
echo "  VPCid ${VpcId}"
echo "  VPCstack ${VPC_stack}"
#
echo "  PUBcidr ${PUB_cidr}"
echo "  PRVcidr ${PRV_cidr}"
#
echo "  PUBnet ${PUBnet}"
echo "  PRVnet ${PRVnet}"
#
echo "  AWS_DEFAULT_REGION ${AWS_DEFAULT_REGION}"

echo "  AvailabilityZone ${AvailabilityZone}"

echo "  SGssh ${SGssh}"
echo "  ec2_keyname ${ec2_keyname}"

echo "  ec2_ami ${ec2_ami}"
echo "  EC2_stack ${EC2_stack}"
echo "  EC2_type ${EC2_type}"

echo ${RESET} ' '

#

aws ec2 run-instances --count 1 --image-id "${ec2_ami}" --instance-type "${ec2_type}" --key-name "${ec2_keyname}" --security-group-ids "${SGssh}" --subnet-id "${PUBnet}" --associate-public-ip-address --block-device-mappings "[{\"DeviceName\": \"/dev/sda1\",\"Ebs\":{\"VolumeSize\":16}}]" --user-data file://ec2configs/public-ec2-build.sh --placement AvailabilityZone="${AvailabilityZone}"

#  | grep InstanceId | cut -d':' -f2 | tr -d '"|,| '

#   --user-data file://ec2configs/public-ec2-build.sh \
# work out how the sg has AvailabilityZone

# aws ec2 create-tags --resources ${InstancePu} --tags Key=Name,Value=${vpc_stack}-${ec2_series}Public
