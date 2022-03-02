output "ansible_worker_1_public_ip" {
    value = "${aws_instance.node01.*.public_ip}"
}

output "ansible_worker_2_public_ip" {
    value = "${aws_instance.node02.*.public_ip}"
}

output "load_balancer_dns" {
    value = "${aws_lb.lb01.*.dns_name}"
}
