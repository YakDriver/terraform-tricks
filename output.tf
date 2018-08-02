output "amis" {
  value = "${data.aws_ami.find_amis.*.id}"
}

output "requested_amis" {
  value = "${local.requested_amis}"
}

output "all_requests" {
  value = "${local.all_requests}"
}

output "requested_filters" {
  value = "${local.requested_filters}"
}

output "win_requests" {
  value = "${local.win_requests}"
}

output "lx_requests" {
  value = "${local.lx_requests}"
}