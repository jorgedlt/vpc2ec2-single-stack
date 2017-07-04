#!/usr/bin/env bash

#
# Create VPC, InternetGatewayId, Public & Private subnets with EC2
#

# jorgedlt@gmail.com - 03 MAR 2017 / 02 JUL 2017
# additional private documentation
# see - https://docs.google.com/document/d/1RdN2hbPeSvrCDTa76iZyExmVhF-Ct9iv-TcFNMRZwSU/edit


# Load ENV parameters
source ./createCFG.env

echo "Create Internet Gateway"

#debug block
  ./showENV.sh
#

#
echo Create Internet Gateway >> ${VpcId}-build.log
 InternetGatewayId=$(aws ec2 create-internet-gateway | grep InternetGatewayId | cut -d':' -f2 | tr -d '"| |,')
 aws ec2 create-tags --resources ${InternetGatewayId} --tags Key=Name,Value=InternetGateway-${vpc_stack}

# update CFG with InternetGatewayId

echo Attach Gateway >> ${VpcId}-build.log
 aws ec2 attach-internet-gateway --vpc-id ${VpcId} --internet-gateway-id ${InternetGatewayId}

echo Create Route Table >> ${VpcId}-build.log
 RouteTableId=$(aws ec2 create-route-table --vpc-id "${VpcId}" | grep RouteTableId | cut -d':' -f2 | tr -d '"| |,')
 aws ec2 create-tags --resources ${RouteTableId} --tags Key=Name,Value=RouteTable-${VPC_stack}

 # update CFG with RouteTableId

echo Create Routes >> ${VpcId}-build.log
 aws ec2 create-route --route-table-id "${RouteTableId}" --destination-cidr-block 0.0.0.0/0 --gateway-id "${InternetGatewayId}"
 aws ec2 create-tags --resources ${RouteTableId} --tags Key=Name,Value=Route-${VPC_stack}

 aws ec2 describe-route-tables >> ${VpcId}-build.log

echo Route Associations >> ${VpcId}-build.log
 aws ec2 associate-route-table --subnet-id ${publicSubnet} --route-table-id ${RouteTableId} >> ${VpcId}-build.log

# this is where I stopped - this works but need to describe to the log, and update the CFG file with new ENV

# optionally - an instance launched into the subnet automatically receives a public IP address
# aws ec2 modify-subnet-attribute --subnet-id ${publicSubnet} --map-public-ip-on-launch
# research how to bind ElasticIP at launch
