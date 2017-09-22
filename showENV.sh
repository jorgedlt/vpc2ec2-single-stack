#!/usr/bin/env bash

# Load ENV parameters
source ./createCFG.env

export myACCOUNT=$(aws iam list-account-aliases | tr -d '{|}|[|]|"| |-' | egrep -v ':|^$');
export myREGION=$(aws configure list | grep region | awk '{print $2}' | tr -d '{|}|[|]|"| |-' );

# debug block
echo
#
 echo "${CYAN}  ACCOUNT            :${WHITE} ${myACCOUNT}"
 echo "${CYAN}  REGION             :${WHITE} ${myREGION}"
 echo
 echo "${CYAN}  build_CFG file     :${GREEN} ${build_CFG}"
 echo "${CYAN}  VPCid              :${YELLOW} ${VpcId}"
 echo "${CYAN}  VPC_stack          :${YELLOW} ${VPC_stack}"
 echo "${CYAN}  EC2_stack          :${YELLOW} ${EC2_stack}"
 echo
 echo "${CYAN}  iNETGW             :${YELLOW} ${iNETGW}"
 echo "${CYAN}  RouterID           :${YELLOW} ${RouterID}"
 echo
 echo "${CYAN}  PUB_cidr           :${GREEN} ${PUB_cidr}"
 echo "${CYAN}  PRV_cidr           :${GREEN} ${PRV_cidr}"
 echo
 echo "${CYAN}  AZone              :${YELLOW} ${AvailabilityZone}"
 echo
 echo "${CYAN}  PUB_net            :${YELLOW} ${PUBnet}"
 echo "${CYAN}  PRV_net            :${YELLOW} ${PRVnet}"
 echo
 echo "${CYAN}  AWS_DEFAULT_REGION :${GREEN} ${AWS_DEFAULT_REGION}"
 echo
 echo "${CYAN}  SGssh              :${YELLOW} ${SGssh}"
 echo "${CYAN}  EC2_ami            :${GREEN} ${EC2_ami}"
 echo "${CYAN}  EC2_type           :${GREEN} ${EC2_type}"
 echo "${CYAN}  EC2_keyname        :${YELLOW} ${EC2_keyname}"
#
echo ${RESET}
