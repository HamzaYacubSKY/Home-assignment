output "ansible_worker_1_public_ip" {
    value = "${aws_instance.node01.*.public_ip}"
}

output "ansible_worker_2_public_ip" {
    value = "${aws_instance.node02.*.public_ip}"
}

output "ansible_worker_1_public_dns" {
    value = "${aws_instance.node01.*.public_dns}"
}

output "ansible_worker_2_public_dns" {
    value = "${aws_instance.node02.*.public_dns}"
}

output "load_balancer_public_dns" {
    value = "${aws_lb.lb01.*.dns_name}"
}