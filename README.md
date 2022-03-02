# Home Assignment

## Prerequisites

- Terraform
- Ansible

If using mac, these can be installed with:
`brew install terraform` and `brew install ansible`

Or if using a different OS, these can installed by following these links:

- [Terraform installation guide](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [Ansible installation guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

## How to install and run

1. Run `git clone` to clone the repository to your local machine.
2. You need to export your aws credentials in your terminal with these commands `export AWS_ACCESS_KEY=<YOUR ACCESS KEY>` and `export AWS_SECRET_ACCESS_KEY=<YOUR SECRET KEY>`.
3. Make sure that you are inside of the Terraform directory and run `openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 365 -nodes` to generate your self-signed certificate.
4. While still inside of the Terraform directory, run `terraform init`.
5. Run `terraform apply`.
6. From the output of `terraform apply`, copy and paste `ansible_worker_1_public_ip` and `ansible_worker_2_public_ip` into inventory.cfg.
7. Go back to to the root directory and run `ansible ansible_worker_1 -m ping -i inventory.cfg` and `ansible ansible_worker_2 -m ping -i inventory.cfg` to make sure the ip addresses of the worker nodes can be reached.
8. Run `ansible-playbook playbook.yml -i inventory.cfg`.
9. Go back to the output of `terraform apply`, copy and paste `load_balancer_dns` into your browser url.
