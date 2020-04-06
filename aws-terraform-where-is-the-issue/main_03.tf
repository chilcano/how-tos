locals {
  nacl_bastion_ips = setproduct(values(aws_network_acl.private)[*].id,
  var.bastion_private_ip)
}

resource "aws_network_acl" "public" {
  for_each   = toset(var.public_subnets)
  vpc_id     = var.vpc_id
  subnet_ids = [each.value]
  tags = {
    Name        = format("%s-public", var.name)
    Environment = var.environment
  }
}

resource "aws_network_acl_rule" "public_outbound_ALL" {
  for_each       = aws_network_acl.public
  network_acl_id = each.value.id
  egress         = true
  rule_number    = 200
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public_inbound_SSH" {
  for_each       = aws_network_acl.public
  network_acl_id = each.value.id
  egress         = false
  rule_number    = 200
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.remote_ssh_cidr
  from_port      = 22
  to_port        = 22
}

resource "aws_network_acl_rule" "public_inbound_HTTPS" {
  for_each       = aws_network_acl.public
  network_acl_id = each.value.id
  egress         = false
  rule_number    = 210
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

resource "aws_network_acl_rule" "public_inbound_HTTP" {
  for_each       = var.allow_HTTP ? aws_network_acl.public : {}
  network_acl_id = each.value.id
  egress         = false
  rule_number    = 211
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl" "private" {
  for_each   = toset(var.private_subnets)
  vpc_id     = var.vpc_id
  subnet_ids = [each.value]
  tags = {
    Name        = format("%s-private", var.name)
    Environment = var.environment
  }
}

resource "aws_network_acl_rule" "private_inbound_SSH" {
  count          = length(local.nacl_bastion_ips)
  network_acl_id = local.nacl_bastion_ips[count.index][0]
  egress         = false
  rule_number    = "${count.index + 300}"
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "${local.nacl_bastion_ips[count.index][1]}/32"
  from_port      = 22
  to_port        = 22
}