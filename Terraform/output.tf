output "ansible_master_public_ip" {
    value = "${aws_instance.ansible-master.*.public_ip}"
}

output "ansible_worker_1_public_ip" {
    value = "${aws_instance.ansible-worker[0].*.public_ip}"
}

output "ansible_worker_2_public_ip" {
    value = "${aws_instance.ansible-worker[1].*.public_ip}"
}

output "ansible_master_public_dns" {
    value = "${aws_instance.ansible-master.*.public_dns}"
}