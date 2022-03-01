# output "ansible_master_public_ip" {
#     value = "${aws_instance.ansible-master.*.public_ip}"
# }

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

# output "ansible_master_public_dns" {
#     value = "${aws_instance.ansible-master.*.public_dns}"
# }