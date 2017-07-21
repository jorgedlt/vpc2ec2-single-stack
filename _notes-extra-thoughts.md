# add Additinal EC2 Resources here


# Additinal EC2 Resources
export vpc_series="VQJX"
export VpcId="vpc-0f45f066"

export ec2_ami="ami-70edb615"
export ec2_series="AUTOTEST"
export ec2_keyname="cf-test-jdlt"
export ec2_type="t2.micro"

# aws ec2 describe-subnets
export publicSubnet="subnet-1e06e753"
export privateSubnet="subnet-1906e754"
#
export publicsg="sg-d8c45db1"
export privatesg="sg-fc7ee795"
#
export securitygroup="sg-fc7ee795"

#
InstanceId=$( aws ec2 run-instances \
  --count 1 \
  --image-id ${ec2_ami} \
  --instance-type ${ec2_type} \
  --key-name ${ec2_keyname} \
  --security-group-ids ${securitygroup} \
  --subnet-id ${privateSubnet} \
  --block-device-mappings "[{\"DeviceName\": \"/dev/sda1\",\"Ebs\":{\"VolumeSize\":8}}]" \
  --placement AvailabilityZone=${AvailabilityZone} \
  | grep InstanceId | cut -d':' -f2 | tr -d '"|,| ')
#

#   --associate-public-ip-address \ has been removed

#
aws ec2 create-tags --resources ${InstanceId} --tags Key=Name,Value=${vpc_stack}-${ec2_series}-02
#
aws ec2 create-tags --resources ${publicSubnet} --tags Key=Name,Value="${vpc_stack}-Public"
aws ec2 create-tags --resources ${publicSubnet} --tags Key=Stack,Value="${vpc_stack}"
#
aws ec2 create-tags --resources ${privateSubnet} --tags Key=Name,Value="${vpc_stack}-Private"
aws ec2 create-tags --resources ${privateSubnet} --tags Key=Stack,Value="${vpc_stack}"
#

i-04e32cf69fcfa71b8  running  t2.micro  10.17.0.12   52.14.137.223  MyEC2-001
i-06b09f9925822146d  running  t2.micro  10.17.1.215  None           None

# also list ssh commmand here
# ssh -i ~/.aws/cf-test-jdlt.pem ubuntu@10.17.1.215

Looking for a CLI solution to ensure the ec2 (i-06b09f9925822146d) in the internal
non public subnet can be accessed by my public facing ec2 (i-04e32cf69fcfa71b8)

I can access the my public facing ec2 (i-04e32cf69fcfa71b8) from my home net without issue.
But I believe I have not setup the Securitygroup correctly for the intenal on be accessed
from the outside ec2. -- Please Help

# Query all based on TAG
aws ec2 describe-tags --filters Name=key,Values=Name Name=value,Values=VQ*

# research later
http://docs.aws.amazon.com/cli/latest/reference/ec2/create-image.html
- a way to create pre-baked pizza ec2
- prebaking via web/c did work and transfer htop
- also look into   create-egress-only-internet-gateway

# Working with an Amazon RDS DB Instance in a VPC
http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_VPC.WorkingWithRDSInstanceinaVPC.html

Step 1: Create a VPC
Step 2: Add Subnets to the VPC
Step 3: Create a DB Subnet Group
Step 4: Create a VPC Security Group
Step 5: Create a DB Instance in the VPC

Step 1: Create a VPC

Step 2: Add Subnets to the VPC

Step 3: Create a DB Subnet Group

  aws rds create-db-subnet-group \
   --db-subnet-group-name <value> \
   --db-subnet-group-description <value> \
   --subnet-ids <value>

Step 4: Create a VPC Security Group

Step 5: Create a DB Instance in the VPC

# RDS

rds_stack='XCVB'

# create-db-instance
aws rds create-db-instance \
 --db-instance-identifier MyRDS-${rds_stack} \
 --allocated-storage 5   \
 --db-instance-class db.t2.micro \
 --engine MySQL \
 --master-username ${rds_stack}user \
 --master-user-password "TPT4bYULVXi3Wzp" \
 --tags Key=Type,Value=${rds_stack} \
 --no-multi-az \
 --no-publicly-accessible
 --backup-retention-period 3


# describe-db-instances
aws rds describe-db-instances

aws rds describe-db-instances |\
    jq -r '.DBInstances[]|select(.DBInstanceIdentifier="mysqlforlambdatest").Endpoint|.Address'

# delete-db-instance
aws rds delete-db-instance \
 --db-instance-identifier MyRDS-XCVB \
 --skip-final-snapshot

aws rds describe-db-instances

# accessing-mysql-databases-aws-python-lambda-function
# https://www.isc.upenn.edu/accessing-mysql-databases-aws-python-lambda-function

# Moving a DB Instance Not in a VPC into a VPC
http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_VPC.WorkingWithRDSInstanceinaVPC.html

### Get all SG not in use

First, get a list of all security groups

 aws ec2 describe-security-groups --query 'SecurityGroups[*].GroupId'  --output text | tr '\t' '\n'

Then get all security groups tied to an instance, then piped to sort then uniq:

 aws ec2 describe-instances --query 'Reservations[*].Instances[*].SecurityGroups[*].GroupId' --output text | tr '\t' '\n' | sort | uniq

Then put it together and compare the 2 lists and see what's not being used from the master list:

 comm -23  <(aws ec2 describe-security-groups --query 'SecurityGroups[*].GroupId'  --output text | tr '\t' '\n'| sort) <(aws ec2 describe-instances --query 'Reservations[*].Instances[*].SecurityGroups[*].GroupId' --output text | tr '\t' '\n' | sort | uniq)
shareedit

###

I have setup qa portal and identity servers.

https://qa-portal.processminer.com
https://qa-identity.processminer.com

Everything on this server has been setup using scripts (code + tools + configuration): https://bitbucket.org/processminer1/code-deployment-scripts

e.g.
- for setting up qa identity server run: sh ./master.sh identity qa
- for setting up qa portal server run: sh ./master.sh portal qa

Database server is also setup using scripts (34.213.10.221), but it still needs some manual steps (i.e. taking latest database backup and import it. we'll automate them later)

I have created some changes to security groups. These 2 servers are open to all right now on port 80 and 443, but I believe its fine since they are QA servers.

All these servers are using temporary public IP addresses. I think we should move to elastic IP addresses and update A records for above sub-domains. Let me know when this is done.

