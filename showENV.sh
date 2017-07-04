#!/usr/bin/env bash


 echo WILD
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
echo "build_CFG ${build_CFG}"
echo "AWS_DEFAULT_REGION ${AWS_DEFAULT_REGION}"

echo "  AvailabilityZone ${AvailabilityZone}"

echo "  SGssh ${SGssh}"
echo "  ec2_keyname ${ec2_keyname}"

echo "  ec2_ami ${ec2_ami}"
echo "  EC2_stack ${EC2_stack}"
echo "  EC2_type ${EC2_type}"

#
echo ${RESET} ' '

echo Post Load
# Load ENV parameters
source ./createCFG.env

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

#
echo ${RESET} ' '
