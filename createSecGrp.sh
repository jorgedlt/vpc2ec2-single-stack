#!/usr/bin/env bash

#
# Create VPC, InternetGatewayId, Public & Private subnets with EC2
#

# jorgedlt@gmail.com - 03 MAR 2017 / 02 JUL 2017
# additional private documentation
# see - https://docs.google.com/document/d/1RdN2hbPeSvrCDTa76iZyExmVhF-Ct9iv-TcFNMRZwSU/edit

# Load ENV parameters
source ./createCFG.env

echo "Create Securitygroup"

# debug block
echo ${CYAN} ' '
echo "     VPCid ${VpcId}"
echo "  VPCstack ${VPC_stack}"
#
echo "  PUBcidr ${PUB_cidr}"
echo "  PRVcidr ${PRV_cidr}"
#
echo "  PUBnet ${PUB_cidr}"
echo "  PRVnet ${PRV_cidr}"
#
echo "build_CFG ${build_CFG}"
echo ${RESET} ' '


echo Create Securitygroup >> ${VpcId}-build.log
 securitygroup=$(aws ec2 create-security-group --group-name "SSHAccess_${VPC_stack}" --description "Security group for SSH access" --vpc-id ${VpcId} | grep GroupId | cut -d':' -f2 | tr -d '"| |,' )

aws ec2 describe-security-groups --group-id ${securitygroup} >> ${VpcId}-build.log

echo SecurityGroup Values >> ${VpcId}-build.log
 aws ec2 authorize-security-group-ingress --group-id ${securitygroup} --protocol tcp --port 22 --cidr "98.251.81.179/32" # DLT Home
 aws ec2 authorize-security-group-ingress --group-id ${securitygroup} --protocol tcp --port 22 --cidr "173.46.67.139/32" # DLT Work

 #
 aws ec2 create-tags --resources ${publicSubnet} --tags Key=Name,Value="${VPC_stack}-Public"
 aws ec2 create-tags --resources ${publicSubnet} --tags Key=Stack,Value="${VPC_stack}"
 #
 aws ec2 create-tags --resources ${privateSubnet} --tags Key=Name,Value="${VPC_stack}-Private"
 aws ec2 create-tags --resources ${privateSubnet} --tags Key=Stack,Value="${VPC_stack}"

 aws ec2 describe-security-groups --group-ids ${securitygroup} >> ${VpcId}-build.log

# this is where I stopped - this works but need to describe to the log, and update the CFG file with new ENV

# fin 0
