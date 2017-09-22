#!/usr/bin/env bash

#
# Create VPC, InternetGatewayId, Public & Private subnets with EC2
# As New Install and Disaster Recovery for Process Miner

# add something here to halt script if in wrong Account and/or Region
export myACCOUNT=$(aws iam list-account-aliases | tr -d '{|}|[|]|"| |-' | egrep -v ':|^$');
export myREGION=$(aws configure list | grep region | awk '{print $2}' | tr -d '{|}|[|]|"| |-' );

source ./createCFG.env

echo $myACCOUNT $AWSaccount
[[ "$myACCOUNT" -eq "$AWSaccount" ]] && { : ; } || { echo ERROR Account MisMatch ; exit ; }

cleanCFG=$(tail -n +27 createCFG.env | egrep -ic "VpcId|Pubnet|AvailabilityZone|PRVnet|iNETGW|RouterID")
[ $cleanCFG -gt 0 ] && { echo ERROR Config file is already populated ; exit ; }

# VPC
source ./createVPC

# PUBLIC Subnet
source ./createPUBnet

# PRIVATE Subnet
source ./createPRVnet

# Internet Gateway
source ./createIGW

# Security Groups
source ./createSecGrp

# PEM pair
source ./createPEMKEY

# PUB EC2
source ./createPUBEC2

env > $$.env-file
exit 0;

# PUB EC2 with JAVA
# source ./createPUBJAVA

# PUB EC2 with MYSQL DB this will be PRIVATE once testing is complete
# source ./createPUBSQLDB

exit 0;
