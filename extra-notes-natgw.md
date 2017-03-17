
# Adding A NAT GW to the private subnet for access to internet for updates, etc.

AWS REF - http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/vpc-nat-gateway.html # good Drawing

  aws ec2 create-nat-gateway --subnet-id <Public-SubNet> --allocation-id <New Elastic IP>

  aws ec2 create-nat-gateway --subnet-id subnet-da3dbeb3 --allocation-id eipalloc-beff5fd7

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
  aws ec2 create-route --route-table-id <Priv-SubNet route-table> --destination-cidr-block 0.0.0.0/0 --nat-gateway-id <NATid from previous command>

  aws ec2 create-route --route-table-id rtb-60da5f09 --destination-cidr-block 0.0.0.0/0 --nat-gateway-id nat-029fcc02b40defb76
