# NetWorking

何をするにしてもとりあえず，VPCの作成から．

# 目次
- [vpc](#vpc)
- [サブネット](#サブネット)

# vpc
## 設定項目
*は必須項目．
### cidr_block * (string)
IPv4のCIDRブロック．

### assign_generated_ipv6_cidr_block (string)
IPv6 CIDRブロック

### instance_tenancy (enum)
テナンシー ("default", "dedicated")

### enable_dns_support (bool)
DNS解決

### enable_dns_hostnames (bool)
DNSホスト名

### tags (object)
タグ


# サブネット
## 設定項目
*は必須項目．
### vpc_id * (string)
所属するVPCのIDを設定．

### availability_zone (string)
アベイラビリティゾーン

### cidr_block * (string)
IPv4 CIDRブロック

### tags (object)
タグ



## 例
以下の例は，VPCを作成し，その中にプライベートサブネットとパブリックサブネットを1つずつ作成．
さらに，VPCに「Internet Gateway」と，パブリックサブネットごとに「Elastic IP」を割り当てた「NAT Gateway」を設置．
```HCL2
# VPCの作成
resource "aws_vpc" "vpc" {
    cidr_block = "192.168.0.0/20"
    assign_generated_ipv6_cidr_block = false
    instance_tenancy = "default"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        "Name" = "${var.project}-${var.env}-vpc"
    }
}

# サブネットの作成
resource "aws_subnet" "public_1a" {
    vpc_id = aws_vpc.vpc.id
    availability_zone = "ap-northeast-1a"
    cidr_block = "192.168.1.0/24"
    tags = {
        "Name" = "${var.project}-${var.env}-public-1a"
    }
}
resource "aws_subnet" "private_1a" {
    vpc_id = aws_vpc.vpc.id
    availability_zone = "ap-northeast-1a"
    cidr_block = "192.168.3.0/24"
    tags = {
        "Name" = "${var.project}-${var.env}-private-1a"
    }
}

# Internet Gatewayの作成，割り当て
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
}

# Elastic IPの作成
resource "aws_eip" "eip_nat_1a" {
    vpc = true
}

# NAT Gatewayの作成
resource "aws_nat_gateway" "nat_1a" {
    subnet_id = aws_subnet.public_1a.id
    allocation_id = aws_eip.eip_nat_1a.id
}

# Route Tableの作成
resource "aws_route_table" "rt_public_1a" {
    vpc_id = aws_vpc.vpc.id
}

# Route Tableに経路を追加
resource "aws_route" "public" {


}
```

## 参考
[Resource: aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)

[Resource: aws_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)