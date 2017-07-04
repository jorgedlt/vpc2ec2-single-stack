#!/usr/bin/env bash

#
# Create VPC, InternetGatewayId, Public & Private subnets with EC2
#

# jorgedlt@gmail.com - 03 MAR 2017 / 02 JUL 2017
# additional private documentation
# see - https://docs.google.com/document/d/1RdN2hbPeSvrCDTa76iZyExmVhF-Ct9iv-TcFNMRZwSU/edit

# Load ENV parameters
source ./createCFG.env


echo "create AWS-VPC"

# debug block
echo ${CYAN} ' '
echo "  VPCid ${VpcId}"
echo "  VPCstack ${VPC_stack}"
#
echo "  PUBcidr ${PUB_cidr}"
echo "  PRVcidr ${PRV_cidr}"
#
echo "build_CFG ${build_CFG}"
echo ${RESET} ' '

# aws ec2 create-vpc
VpcId=$(aws ec2 create-vpc --cidr-block ${VPC_cidr} | grep VpcId | cut -d':' -f2 | tr -d '"| |,')
 aws ec2 create-tags --resources ${VpcId} --tags Key=Name,Value="${VPC_stack}"

echo "export VpcId=${VpcId}" >> ${build_CFG}

date             > ${VpcId}-build.log
echo "${VpcId}" >> ${VpcId}-build.log
aws ec2 describe-vpcs >> ${VpcId}-build.log

echo "Modify-VOC attribute DNS attributes"
 aws ec2 modify-vpc-attribute --vpc-id "${VpcId}" --enable-dns-support "{\"Value\":true}"
 aws ec2 modify-vpc-attribute --vpc-id "${VpcId}" --enable-dns-hostnames "{\"Value\":true}"

# fin 0;

# aws ec2 delete-vpc --vpc-id vpc-11265678
