output "vpc_id" {
  value = "${aws_vpc.habichef-vpc.id}"
}

output "subnet_id" {
  value = "${aws_subnet.habichef-subnet-a.id}"
}

output "chef_automate_server_public_ip" {
  value = "${aws_instance.chef_automate.public_ip}"
}

output "permanent_peer_public_ip" {
  value = "${aws_instance.permanent_peer.public_ip}"
}

output "concourse_web_ip" {
  value = "${aws_instance.concourse_web.public_ip}"
}

output "concourse_db_ip" {
  value = "${aws_instance.concourse_db.public_ip}"
}

output "concourse_worker_ips" {
  value = "${aws_instance.concourse_worker.*.public_ip}"
}

output "concourse_elb_dns" {
  value = "${aws_elb.concourse_elb.dns_name}"
}

output "a2_admin" {
  value = "${data.external.a2_secrets.result["a2_admin"]}"
}

output "a2_admin_password" {
  value = "${data.external.a2_secrets.result["a2_password"]}"
}

output "a2_token" {
  value = "${data.external.a2_secrets.result["a2_token"]}"
}

output "a2_url" {
  value = "${data.external.a2_secrets.result["a2_url"]}"
}
