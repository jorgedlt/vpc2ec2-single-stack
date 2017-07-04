#!/usr/bin/env bash

#
# Create VPC, InternetGatewayId, Public & Private subnets with EC2
#

# jorgedlt@gmail.com - 03 MAR 2017 / 02 JUL 2017
# additional private documentation
# see - https://docs.google.com/document/d/1RdN2hbPeSvrCDTa76iZyExmVhF-Ct9iv-TcFNMRZwSU/edit

# Load ENV parameters
source ./createCFG.env

echo "Create PRIVATE subnet "

echo "Create Internet Gateway"

# debug block
echo ${CYAN} ' '
echo "     VPCid ${VpcId}"
echo "  VPCstack ${VPC_stack}"
#
echo "  PUBcidr ${PUB_cidr}"
echo "  PRVcidr ${PRV_cidr}"
#
echo "  PUBnet ${PUBnet}"
echo "  PRVnet ${PRVnet}"
#
echo "build_CFG ${build_CFG}"
echo "  AWS_DEFAULT_REGION ${AWS_DEFAULT_REGION}"

echo "  AvailabilityZone ${AvailabilityZone}"

echo "  ec2_ami ${ec2_ami}"
echo "  EC2_stack ${EC2_stack}"
echo "  EC2_type ${EC2_type}"

# for Test I used SBD-DA AWS Account - us-east-2
# export ec2_keyname="sbdda-autodeploy-B1"                                 # us-east-2
#
echo ${RESET} ' '
#
 privateSubnet=$(aws ec2 create-subnet --vpc-id "${VpcId}" --cidr-block "${PRV_cidr}" | grep 'SubnetId' | cut -d':' -f2 | tr -d '"| |,')
 aws ec2 create-tags --resources "${privateSubnet}" --tags Key=Name,Value=privateSubnet-${VPC_stack}

echo ${privateSubnet} >> ${VpcId}-build.log
aws ec2 describe-subnets --subnet-ids ${privateSubnet} >> ${VpcId}-build.log

echo "export PRVnet=${privateSubnet}" >> ${build_CFG}

# no Select Availability Zone -- not sure why ??

# fin 0
