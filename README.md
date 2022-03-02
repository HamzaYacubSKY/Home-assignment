# Home Assignment

## How to install and run

- Run `git clone` to clone the repository to your local machine.
- You need to export your aws credentials in your terminal with these commands `export AWS_ACCESS_KEY=<YOUR ACCESS KEY>` and `export AWS_SECRET_ACCESS_KEY=<YOUR SECRET KEY>`.
- Make sure that you are inside of the Terraform directory and run `openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 365 -nodes` to generate your self-signed certificate.
- While still inside of the Terraform directory, run `terraform init`.
- Run `terraform apply`.
- From the output of `terraform apply`, copy and paste `ansible_worker_1_public_ip` and `ansible_worker_2_public_ip` into inventory.cfg.
- Run `ansible ansible_worker_1 -m ping -i inventory.cfg` and `ansible ansible_worker_2 -m ping -i inventory.cfg` to make sure the ip addresses of the worker nodes can be reached.
- Run `ansible-playbook playbook.yml -i inventory.cfg`.
- Go back to the output of `terraform apply`, copy and paste `load_balancer_dns` into your browser url.
