#!/usr/bin/env bash

#
# Create VPC, InternetGatewayId, Public & Private subnets with EC2
# As New Install and Disaster Recovery for Process Miner

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
source ./createPUBEC2          # get JAVA specs from Manan

# PRV EC2
source ./createPRVEC2          # what makes the PRV different ?

exit 0;

#### Above are tested, Below are not

# PUB EC2 with MYSQL
source ./createPUBSQL          # get MYSQL specs from Manan

# PUB RDS with MYSQL
source ./createPUBRDS

# API GW
source ./createAPIGW

# DYNAMODB
source ./createDYNADB

exit 0;
