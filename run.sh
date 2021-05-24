#!/bin/bash
set +ex

make ssh-gen
cat ~/.aws/credentials
make bootstrap
make pack
cd infra
/bin/bash makeMainFile.sh
cd ..
make tf-init
make tf-validate
make tf-plan
cd infra
terraform apply -auto-approve
cd ../ansible/scripts
/bin/bash run-ansible.sh
cd ..
ansible-playbook -i inventory.yml --ssh-common-args='-o StrictHostKeyChecking=no' --private-key ~/keys/ec2-key -u ec2-user playbook.yml
cd ../infra
terraform output lb_dns
