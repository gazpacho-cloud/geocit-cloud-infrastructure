---

# Geocitizen Deployment and Monitoring Setup

## Overview
This guide outlines the steps to deploy the Geocitizen application along with a monitoring stack using Prometheus and Grafana. The deployment is managed through an Ansible playbook, which automates the setup and configuration of necessary components.

## Prerequisites
- Ansible installed on the control node.
- SSH access to the target machines.
- Git installed on the comtrol node.
- Database server (PostgreSQL) configured and accessible.
- Map API key obtained for map services.

## Deployment Steps

### Step 1: Clone the Repository
Ensure you have cloned the repository containing the Ansible playbook and associated roles:

```bash
git clone https://github.com/your-repo/geocit-cloud-infrastructure.git
cd geocit-cloud-infrastructure
```

### Step 2: Update Inventory and Variables
Edit your Ansible inventory file to define the hosts and variables:

**Inventory File Example:**
```ini
[db_server]
db_server ansible_host=your-db-server-ip db_name=geocitdb db_username=geocituser db_password=securepassword

[app]
app ansible_host=your-app-server-ip

[map_key]
map_key key=your-map-api-key

[monitoring_instances]
monitoring_instance ansible_host=your-monitoring-server-ip
```

### Step 3: Connect to Grafana
To access Grafana, you will need to set up SSH keys and use SSH tunneling. Follow these steps:

1. **Generate SSH Keys:**
   If you haven't already, generate SSH keys on your local machine:

   ```bash
   ssh-keygen -t rsa -b 2048
   ```

2. **Copy the SSH Key to the Monitoring Server:**
   ```bash
   echo "id.rsa_pub" >> ~/.ssh/authorized_keys
   ```

### Step 4: Run the Ansible Playbook
Execute the Ansible playbook to deploy the Geocitizen app and the monitoring stack:

```bash
`ansible-playbook -i inventory.ini playbook.yml`
```

4. **Access Grafana:**
   Open your web browser and navigate to `http://[VM_IP]:3000`. Log in using the default Grafana credentials (admin/admin) and follow the prompts to set a new password.

### Configuration Files
- **datasource.yml for Grafana:**
  ```yaml
  global:
    scrape_interval: 15s  # Default scraping interval

  scrape_configs:
    - job_name: 'prometheus'
      static_configs:
        - targets: ['localhost:9090']

    - job_name: 'node_exporter'
      static_configs:
        - targets: ['localhost:9100']
  ```

#### Simulation Modes

- Check Mode - Run Ansible in a simulation mode to see what changes would be made, without actually applying them:
`ansible-playbook -i inventory.ini playbook.yml --check`

- Diff Mode - Run Ansible and report the changes made to your files:
`ansible-playbook -i inventory.ini playbook.yml --diff`

- Check Mode with Diff Mode - Combine check mode and diff mode to show changes that would have been made:
`ansible-playbook -i inventory.ini playbook.yml --check --diff`

## Additional Information
- Ensure your PostgreSQL database is configured to accept connections from the app server.
- The Ansible roles for Maven and Tomcat should be configured to handle the build and deployment of the Geocitizen application.
- Monitoring stack setup includes Prometheus for metrics collection and Grafana for visualization.

## Troubleshooting
- Verify SSH connectivity between the control node and target machines.
- Ensure all environment variables and secrets are correctly set in the inventory file.
- Check the application logs for any errors during deployment.
