#!/usr/bin/env bash

#
# Create VPC, InternetGatewayId, Public & Private subnets with EC2
#

# jorgedlt@gmail.com - 03 MAR 2017 / 02 JUL 2017
# additional private documentation
# see - https://docs.google.com/document/d/1RdN2hbPeSvrCDTa76iZyExmVhF-Ct9iv-TcFNMRZwSU/edit


# Load ENV parameters
source ./createCFG.env

echo "Create Key Pair"

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
echo "AWS_DEFAULT_REGION ${AWS_DEFAULT_REGION}"

echo "  AvailabilityZone ${AvailabilityZone}"

echo "  SGssh ${SGssh}"
echo "  ec2_keyname ${ec2_keyname}"

echo "  ec2_ami ${ec2_ami}"
echo "  EC2_stack ${EC2_stack}"
echo "  EC2_type ${EC2_type}"

# for Test I used SBD-DA AWS Account - us-east-2
# export ec2_keyname="sbdda-autodeploy-B1"                                 # us-east-2
#
echo ${RESET} ' '

#
export myACCOUNT=$(aws iam list-account-aliases | tr -d '{|}|[|]|"| |-' | egrep -v ':|^$');
export myREGION=$(aws configure list | grep region | awk '{print $2}' | tr -d '{|}|[|]|"| |-' );

#

# the vpc2ec2 script needs a way to create new key pairs which are unique to the series

# create-key-pairs
export MyKEY=$(aws ec2 create-key-pair --key-name ${myACCOUNT}-${myREGION}-${VpcId} \
  | grep KeyMaterial | cut -d':' -f2 | tr -d ',|"| |')
#
echo -e ${MyKEY} > ${myACCOUNT}-${myREGION}-${VpcId}.pem
export ec2_keyname=${myACCOUNT}-${myREGION}-${VpcId}.pem
# chmod 0400 ${myPEM}w
#

echo "export ec2_keyname=${myACCOUNT}-${myREGION}-${VpcId}" >> ${build_CFG}

# delete-key-pairs
# aws ec2 delete-key-pair --key-name  sbdda-useast2-vpc-2d473744
# rm ${myPEM}
#
