#!/usr/bin/env bash

#
# Create VPC, InternetGatewayId, Public & Private subnets with EC2
#

# Load ENV parameters
# source ./createCFG.env     # each createFILE in turn calls this

# VPC
source ./createVPC.sh

# PUBLIC Subnet
source ./createPUBnet.sh

# PRIVATE Subnet
source ./createPRVnet.sh

# Internet Gateway
source ./createIGW.sh

# Security Groups
source ./createSecGrp.sh

# PEM pair
source ./createPEMKEY.sh

# PUB EC2
source ./createPUBEC2.sh

# add more as ready
# ...

exit 0;

# consider DNS and Elastic IP concerns as well
