#!/bin/bash
set +ex

## Hacky way to build inventory file
cd ..
echo "all:" > inventory.yml
instance_ip=$(cd ../infra ; terraform output instance_ip)
echo "  hosts:" >> inventory.yml
echo "    $instance_ip" >> inventory.yml
echo "  vars:" >> inventory.yml
db_user=$(cd ../infra; terraform output db_user)
echo "    db_user: $db_user" >> inventory.yml
db_pass=$(cd ../infra; terraform output db_pass)
echo "    db_pass: $db_pass" >> inventory.yml
db_url=$(cd ../infra; terraform output db_url)
echo "    db_url: $db_url" >> inventory.yml
db_port=$(cd ../infra; terraform output db_port)
echo "    db_port: $db_port" >> inventory.yml




