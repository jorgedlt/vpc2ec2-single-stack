
# Adding A NAT Gateway to the private subnet for access to internet for system updates, etc.

A decent AWS Ref and a good drawing

[http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/vpc-nat-gateway.html 
](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/vpc-nat-gateway.html)

### Step 1

format like this ...

	aws ec2 create-nat-gateway --subnet-id <Public-SubNet> --allocation-id <New Elastic IP>

My actual command ...

	aws ec2 create-nat-gateway --subnet-id subnet-da3dbeb3 --allocation-id eipalloc-beff5fd7
	
Which returns ...

	{
	    "NatGateway": {
	        "NatGatewayAddresses": [
	            {
	                "AllocationId": "eipalloc-beff5fd7"
	            }
	        ],
	        "VpcId": "vpc-8248faeb",
	        "State": "pending",
	        "NatGatewayId": "nat-029fcc02b40defb76",
	        "SubnetId": "subnet-da3dbeb3",
	        "CreateTime": "2017-03-17T22:27:24.445Z"
	    }
	}

#

### Step 2

How many routers do I have ?

	aws ec2 describe-route-tables | grep RouteTableId | tr -d ' |,' | sort | uniq
	
	"RouteTableId":"rtb-44d33a2d"
	"RouteTableId":"rtb-60da5f09"
	"RouteTableId":"rtb-78da5f11"
	
so I have 3 - One is the default for the VPC (rtb-44d33a2d), one for the Public Subnet (rtb-78da5f11), and the last one for the Private SubNet (rtb-60da5f09)

	$ aws ec2 describe-route-tables --route-table-ids rtb-60da5f09

json out

	{
	    "RouteTables": [
	        {
	            "Associations": [
	                {
	                    "RouteTableAssociationId": "rtbassoc-5b60f832",
	                    "Main": true,
	                    "RouteTableId": "rtb-60da5f09"
	                }
	            ],
	            "RouteTableId": "rtb-60da5f09",
	            "VpcId": "vpc-8248faeb",
	            "PropagatingVgws": [],
	            "Tags": [],
	            "Routes": [
	                {
	                    "GatewayId": "local",
	                    "DestinationCidrBlock": "10.17.0.0/16",  << Private
	                    "State": "active",
	                    "Origin": "CreateRouteTable"
	                },
	                {
	                    "Origin": "CreateRoute",
	                    "DestinationCidrBlock": "0.0.0.0/0",
	                    "NatGatewayId": "nat-029fcc02b40defb76",
	                    "State": "active"
	                }
	            ]
	        }
	    ]
	}

### Step 3

format like this ...

	aws ec2 create-route --route-table-id <Priv-SubNet route-table> --destination-cidr-block 0.0.0.0/0 --nat-gateway-id <NATid from previous command>

My actual command ...

	aws ec2 create-route --route-table-id rtb-60da5f09 --destination-cidr-block 0.0.0.0/0 --nat-gateway-id nat-029fcc02b40defb76
	
and tag it - Private Router

	aws ec2 create-tags --resources rtb-60da5f09 --tags Key=Name,Value="PrivateRouteTable"
	
tag it - Public Router

	aws ec2 create-tags --resources rtb-78da5f11 --tags Key=Name,Value="PublicRouteTable"
	
