#!/usr/bin/env bash

#
# Create VPC, InternetGatewayId, Public & Private subnets with EC2
#

# jorgedlt@gmail.com - 03 MAR 2017 / 02 JUL 2017


# Load ENV parameters
source ./createCFG.env

echo "Create PUBLIC subnet"

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

#
 publicSubnet=$(aws ec2 create-subnet --vpc-id "${VpcId}" --cidr-block ${PUB_cidr} | grep SubnetId | cut -d':' -f2 | tr -d '"| |,')
 aws ec2 create-tags --resources ${publicSubnet} --tags Key=Name,Value=publicSubnet-${VPC_stack}

echo publicSubnet ${publicSubnet} >> ${VpcId}-build.log
 aws ec2 describe-subnets --subnet-ids ${publicSubnet} >> ${VpcId}-build.log

echo "export PUBnet=${publicSubnet}" >> ${build_CFG}

echo "Select Availability Zone" >> ${VpcId}-build.log
 AvailabilityZone=$(aws ec2 describe-subnets --subnet-ids ${publicSubnet} | grep AvailabilityZone | cut -d':' -f2 | tr -d '"| |,')

# fin 0
