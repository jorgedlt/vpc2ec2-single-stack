#!/usr/bin/env bash

#
# Create VPC, InternetGatewayId, Public & Private subnets with EC2
#

# Load ENV parameters
# source ./createCFG.env     # each createFILE in turn calls this

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

# add more as ready
# ...

exit 0;

# consider DNS and Elastic IP concerns as well
