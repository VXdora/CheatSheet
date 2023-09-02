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
```HCL2
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
```

## 参考
[Resource: aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)

[Resource: aws_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)