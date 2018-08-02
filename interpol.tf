  
locals {
  user_requests = ["win12","centos6","rhel7","win08","fred"]

  win_amis_all_keys = ["win08", "win12", "win16", "win08pkg", "win12pkg", "win16pkg"]
  lx_amis_all_keys = ["centos6", "centos7", "rhel6", "rhel7", "centos6pkg", "centos7pkg", "rhel6pkg", "rhel7pkg"]

  all_keys = "${concat(local.lx_amis_all_keys, local.win_amis_all_keys)}"

  win_requests = "${matchkeys(local.win_amis_all_keys, local.win_amis_all_keys, local.user_requests)}"
  lx_requests = "${matchkeys(local.lx_amis_all_keys, local.lx_amis_all_keys, local.user_requests)}"
  all_requests = "${matchkeys(local.all_keys, local.all_keys, local.user_requests)}"

  ami_name_filters = {
    "${local.lx_amis_all_keys[0]}" = "spel-minimal-centos-6*"
    "${local.lx_amis_all_keys[1]}" = "spel-minimal-centos-7*"
    "${local.lx_amis_all_keys[2]}" = "spel-minimal-rhel-6*"
    "${local.lx_amis_all_keys[3]}" = "spel-minimal-rhel-7*"
    "${local.win_amis_all_keys[0]}" = "Windows_Server-2008-R2_SP1-English-64Bit-Base*"
    "${local.win_amis_all_keys[1]}" = "Windows_Server-2012-R2_RTM-English-64Bit-Base*"
    "${local.win_amis_all_keys[2]}" = "Windows_Server-2016-English-Full-Base*"
    ubun = "ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server*"
  }
  ami_owners = ["701759196663", "099720109477", "801119661308"]
  
  ami_virtualization_type = "hvm"

  requested_filters = "${matchkeys(
    values(local.ami_name_filters), 
    keys(local.ami_name_filters), 
    local.all_requests
  )}"

  requested_amis = "${zipmap(
    local.all_requests,
    data.aws_ami.find_amis.*.id
  )}"
}

data "aws_ami" "find_amis" {
  count = "${length(local.requested_filters)}"
  most_recent = true

  filter {
    name   = "virtualization-type"
    values = ["${local.ami_virtualization_type}"]
  }

  filter {
    name   = "name"
    values = ["${element(local.requested_filters, count.index)}"]
  }

  owners = "${local.ami_owners}"
}