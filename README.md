# geocit-cloud
geocit cloud deployment 

#

### Prerequisites
- Ansible installed on your VM

#

### Inventory Variables

First, update the inventory.ini file with your specific details:
```
[gcp_instances]
# VM
app ansible_host=[IP_OF_YOUR_VM] ansible_user=[YOUR_USERNAME]
# Postgres SQL
db_server ansible_host=[IP_DATABASE] ansible_user=[YOUR_USERNAME] db_username=[DB_USERNAME] db_password=[DB_PASSWORD] db_name=[DB_NAME]
# Google Maps
map_key key=[YOUR_GOOGLE_MAPS_API_KEY]
```

### Startup Ansible

To startup build with ansible, use the following command: 
`ansible-playbook -i inventory.ini playbook.yml`

#### Simulation Modes

- Check Mode - Run Ansible in a simulation mode to see what changes would be made, without actually applying them:
`ansible-playbook -i inventory.ini playbook.yml --check`

- Diff Mode - Run Ansible and report the changes made to your files:
`ansible-playbook -i inventory.ini playbook.yml --diff`

- Check Mode with Diff Mode - Combine check mode and diff mode to show changes that would have been made:
`ansible-playbook -i inventory.ini playbook.yml --check --diff`
