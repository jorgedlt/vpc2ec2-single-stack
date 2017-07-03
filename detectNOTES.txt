# vpcls
3     VPClist=$(aws ec2 describe-vpcs | grep 'VpcId' | cut -d':' -f2 | tr -d ' |"|:|,');


# vpcstat
IGWlist=$( aws ec2 describe-internet-gateways --output text | grep -B1 -A1 $vpcID );

IGWid=$(echo "$IGWlist" | grep INTERNETGATEWAYS | awk '{print $2}');
IGWnm=$(echo "$IGWlist" | grep TAGS | awk '{print $3}');
descDUMP 'iGW ID' $IGWid 'iGW Name' $IGWnm;
echo;
RTRlist=$( aws ec2 describe-internet-gateways --output text | grep -B1 -A1 $vpcID );
NETlist=$( aws ec2 describe-subnets --filters Name=vpc-id,Values="${vpcID}" |  grep 'SubnetId' | cut -d':' -f2 | tr -d ' |"|:|,' );


# specific vpc-id

aws ec2 describe-security-groups --filters Name=vpc-id,Values=vpc-369eef5f --query SecurityGroups[].{Name:GroupName}


# Stale SG ??

VPCid: [ vpc-369eef5f ] VPCname: [ vpc-breakup ]
CidrBlock: [ 10.27.0.0/16 ] State: [ available ]

jdlt@[ELBA]:~/code/vpc2ec2$ aws ec2 describe-stale-security-groups --vpc-id vpc-369eef5f



# from AWS -- To describe security groups that have specific rules

(EC2-VPC only) This example uses filters to describe security groups that have a rule that allows SSH traffic (port 22) and a rule that allows traffic from all addresses (0.0.0.0/0). The output is filtered to display only the names of the security groups. Security groups must match all filters to be returned in the results; however, a single rule does not have to match all filters. For example, the output returns a security group with a rule that allows SSH traffic from a specific IP address and another rule that allows HTTP traffic from all addresses.

Command:

aws ec2 describe-security-groups --filters Name=ip-permission.from-port,Values=22


ip-permission.from-port,Values=22 Name=ip-permission.to-port,Values=22 Name=ip-permission.cidr,Values='0.0.0.0/0' --query 'SecurityGroups[*].{Name:GroupName}'


##

vpcls

export VpcId=vpc-369eef5f

# vpc
aws ec2 describe-vpcs --vpc-ids=${VpcId}

# subnets
aws ec2 describe-subnets --filters Name=vpc-id,Values=${VpcId}

# internet-gateways
aws ec2 describe-internet-gateways --filters Name=attachment.vpc-id,Values=${VpcId}

# network-acls
aws ec2  describe-network-acls --filters Name=vpc-id,Values=${VpcId}

  export NetworkAclId=$(aws ec2  describe-network-acls --filters Name=vpc-id,Values=${VpcId})

# Egress-only Internet Gateways

# NAT gw

# security-groups
aws ec2 describe-security-groups --filters Name=vpc-id,Values=${VpcId}

  export GroupID=$(aws ec2 describe-security-groups --filters Name=vpc-id,Values=${VpcId})

# route-tables
aws ec2 describe-route-tables --filters Name=vpc-id,Values=${VpcId}

  export RouteTableId=$(aws ec2 describe-route-tables --filters Name=vpc-id,Values=${VpcId})

#########

# Concatinate unique key based on ENV

#
export myACCOUNT=$(aws iam list-account-aliases | tr -d '{|}|[|]|"| |-' | egrep -v ':|^$');
export myREGION=$(aws configure list | grep region | awk '{print $2}' | tr -d '{|}|[|]|"| |-' );
#
export myVPC="autocreate"                           # vpc_stack
#
export VpcId=vpc-369eef00
#
# export myHASH=$(date | md5 | cut -c1-4)           # this is ok
export myHASH=$(echo ${VpcId} | cut -d'-' -f2)      # but, this is better

#
echo ${myACCOUNT}-${myREGION}-${myVPC}-${myHASH}
#

#########

# the vpc2ec2 script needs a way to create new key pairs which are unique to the series

# describe-key-pairs
aws ec2 describe-key-pairs

# create-key-pairs
export MyKEY=$(aws ec2 create-key-pair --key-name ${myACCOUNT}-${myREGION}-${myVPC}-${myHASH} \
  | grep KeyMaterial | cut -d':' -f2 | tr -d ',|"| |')
#
echo -e ${MyKEY} > ${myACCOUNT}-${myREGION}-${myVPC}-${myHASH}.pem
export myPEM=${myACCOUNT}-${myREGION}-${myVPC}-${myHASH}.pem
# chmod 0400 ${myPEM}w
#

# delete-key-pairs
aws ec2 delete-key-pair --keewffy-name ${myACCOUNT}-${myREGION}-${myVPC}-${myHASH}
rm ${myPEM}
#
