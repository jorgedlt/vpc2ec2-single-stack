#!/usr/bin/env bash

#
# Create VPC, InternetGatewayId, Public & Private subnets with EC2
#

# jorgedlt@gmail.com - 03 MAR 2017

#
#export AWS_ACCESS_KEY_ID=
#export AWS_SECRET_ACCESS_KEY=

# export AWS_DEFAULT_REGION=us-east-1 ; export ec2_ami="ami-2ef48339" # us-east-1
# export AWS_DEFAULT_REGION=us-east-2 ; export ec2_ami="ami-70edb615" # us-east-2
 export AWS_DEFAULT_REGION=us-west-1  ; export ec2_ami="ami-a9a8e4c9" # us-west-1
# export AWS_DEFAULT_REGION=us-west-2 ; export ec2_ami="ami-746aba14" # us-west-2

# ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20160907 ( ebs | hvm )

export vpc_stack="USW1B"

# Network Settings - network are valid /16 - /28
export vpc_cidr="10.17.0.0/16"
export pub_cidr="10.17.0.0/24"
export prv_cidr="10.17.1.0/24"

export ec2_stack="NEWREG"
# export ec2_keyname="cf-test-jdlt" # us-east-2
export ec2_keyname="cf-testw1-jdlt" # us-west-1

# t2.micro | t2.small | t2.medium | t2.large #
export ec2_type="t2.micro"

echo -n "create AWS-VPC "
# aws ec2 create-vpc --cidr-block 10.17.0.0/16
VpcId=$(aws ec2 create-vpc --cidr-block "${vpc_cidr}" | grep VpcId | cut -d':' -f2 | tr -d '"| |,')
 aws ec2 create-tags --resources "${VpcId}" --tags Key=Name,Value="${vpc_stack}"

echo "${VpcId}"

# this needs a stop if failed scheme !!

aws ec2 describe-vpcs > "${VpcId}-build.log"

echo modify-vpc-attribute dns attributes
 aws ec2 modify-vpc-attribute --vpc-id "${VpcId}" --enable-dns-support "{\"Value\":true}"
 aws ec2 modify-vpc-attribute --vpc-id "${VpcId}" --enable-dns-hostnames "{\"Value\":true}"

echo -n "Create PUBLIC subnet "
 publicSubnet=$(aws ec2 create-subnet --vpc-id "${VpcId}" --cidr-block "${pub_cidr}" | grep 'SubnetId' | cut -d':' -f2 | tr -d '"| |,')
 aws ec2 create-tags --resources "${publicSubnet}" --tags Key=Name,Value=publicSubnet-${vpc_stack}

echo publicSubnet "${publicSubnet}"

echo Select Availability Zone
 AvailabilityZone=$(aws ec2 describe-subnets --subnet-ids "${publicSubnet}" | grep AvailabilityZone | cut -d':' -f2 | tr -d '"| |,')

echo -n "Create PRIVATE subnet "
 privateSubnet=$(aws ec2 create-subnet --vpc-id "${VpcId}" --cidr-block" ${prv_cidr}" | grep SubnetId | cut -d':' -f2 | tr -d '"| |,')
 aws ec2 create-tags --resources ${privateSubnet} --tags Key=Name,Value=privateSubnet-${vpc_stack}

echo privateSubnet "${privateSubnet}"

 aws ec2 describe-subnets >> "${VpcId}-build.log"

echo Create Internet Gateway
 InternetGatewayId=$(aws ec2 create-internet-gateway | grep 'InternetGatewayId' | cut -d':' -f2 | tr -d '"| |,')
 aws ec2 create-tags --resources "${InternetGatewayId}" --tags Key=Name,Value=InternetGateway-${vpc_stack}

 aws ec2 describe-internet-gateways >> "${VpcId}-build.log"

echo Attach Gateway
 aws ec2 attach-internet-gateway --vpc-id "${VpcId}" --internet-gateway-id ${InternetGatewayId}

echo Create Route Table
 RouteTableId=$(aws ec2 create-route-table --vpc-id "${VpcId}" | grep 'RouteTableId' | cut -d':' -f2 | tr -d '"| |,')
 aws ec2 create-tags --resources "${RouteTableId}" --tags Key=Name,Value=RouteTable-${vpc_stack}

echo Create Routes
 aws ec2 create-route --route-table-id "${RouteTableId}" --destination-cidr-block 0.0.0.0/0 --gateway-id "${InternetGatewayId}"
 aws ec2 create-tags --resources "${RouteTableId}" --tags Key=Name,Value=Route-${vpc_stack}

 aws ec2 describe-route-tables >> "${VpcId}-build.log"

echo Route Associations
 aws ec2 associate-route-table --subnet-id "${publicSubnet}" --route-table-id "${RouteTableId}"

# optionally - an instance launched into the subnet automatically receives a public IP address
# aws ec2 modify-subnet-attribute --subnet-id ${publicSubnet} --map-public-ip-on-launch

# research how to bind ElasticIP at launch

echo Create Securitygroup
 securitygroup=$(aws ec2 create-security-group --group-name "SSHAccess_${vpc_stack}" --description "Security group for SSH access" --vpc-id ${VpcId} | grep 'GroupId' | cut -d':' -f2 | tr -d '"| |,' )

 # aws ec2 describe-security-groups --group-id ${securitygroup} | jq

echo Securitygroup Values
 aws ec2 authorize-security-group-ingress --group-id "${securitygroup}" --protocol 'tcp' --port '22' --cidr '98.251.81.179/32'

#
 aws ec2 create-tags --resources "${publicSubnet}" --tags Key=Name,Value="${vpc_stack}-Public"
 aws ec2 create-tags --resources "${publicSubnet}" --tags Key=Stack,Value="${vpc_stack}"
 #
 aws ec2 create-tags --resources "${privateSubnet}" --tags Key=Name,Value="${vpc_stack}-Private"
 aws ec2 create-tags --resources "${privateSubnet}" --tags Key=Stack,Value="${vpc_stack}"

 aws ec2 describe-security-groups --group-ids "${securitygroup}" >> "${VpcId}-build.log"

sleep 10
#
InstanceId=$( aws ec2 run-instances \
  --count 1 \
  --image-id ${ec2_ami} \
  --instance-type ${ec2_type} \
  --key-name ${ec2_keyname} \
  --security-group-ids ${securitygroup} \
  --subnet-id ${publicSubnet} \
  --associate-public-ip-address \
  --block-device-mappings "[{\"DeviceName\": \"/dev/sda1\",\"Ebs\":{\"VolumeSize\":16}}]" \
  --placement AvailabilityZone=${AvailabilityZone} \
  | grep InstanceId | cut -d':' -f2 | tr -d '"|,| ')

# work out how the sg has AvailabilityZone

aws ec2 create-tags --resources "${InstanceId}" --tags Key=Name,Value=${vpc_stack}${ec2_series}-01

aws ec2 describe-instances --instance-ids >> "${VpcId}-build.log"

# also list ssh commmand here
# ssh -i ~/.aws/cf-test-jdlt.pem ubuntu@52.14.137.223

exit

# add Additinal EC2 Resources here
