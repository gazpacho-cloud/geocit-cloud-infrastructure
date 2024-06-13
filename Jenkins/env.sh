#! /bin/bash

# sudo apt-get install jq -y
#DB="$(jq -r '.database_pass' /var/lib/jenkins/workspace/terraform_start/ansible/vars_output.json)"
#IP="$(jq -r '.database_private_ip' /var/lib/jenkins/workspace/terraform_start/ansible/vars_output.json )"
DB="postgres"
IP="10.10.20.2"
sed -i -e "s|192.168.101.30|$IP|g" application.properties
sed -i -e "s|test_password|$DB|g" application.properties
