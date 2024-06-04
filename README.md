## Prerequisites

- Google Cloud SDK installed and configured
- Terraform installed
- Service account with necessary permissions
- GCP project setup

## Variables

- `gcp_region`: The region where resources will be created (default: `europe-central2`).
- `gcp_project`: The GCP project ID (default: `ferrous-terrain-422816-i0`).
- `gcp_key`: The service account key file (default: `ferrous-terrain-422816-i0-93fb4bb15c74.json`).
- `gcp_zone`: The zone where resources will be created (default: `europe-central2-c`).

## Resources

### SQL Database Instance

- **Resource**: `google_sql_database_instance.postgres`
- **Description**: Creates a PostgreSQL database instance.


### SQL User

- **Resource**: `google_sql_user.db_user`
- **Description**: Creates a user for the PostgreSQL instance.

### Compute Instances

- **Resource**: `google_compute_instance.Instance_for_grafane`
- **Description**: Creates a compute instance for Grafana.

### Firewall Rules

- **Resources**: Multiple `google_compute_firewall` resources.
- **Description**: Creates firewall rules to allow specific traffic.


### Load Balancer

- **Resource**: Multiple resources for setting up a load balancer.
- **Components**:
  - `google_compute_global_address.default`
  - `google_compute_global_forwarding_rule.default`
  - `google_compute_target_http_proxy.default`
  - `google_compute_url_map.default`
  - `google_compute_backend_service.default`
  - `google_compute_health_check.default`
  - `google_compute_instance_group_manager.default`

### Autoscaler

- **Resource**: `google_compute_autoscaler.autoscaler`
- **Description**: Sets up an autoscaler for the managed instance group.
- **Settings**:
  - `max_replicas`: `3`
  - `min_replicas`: `1`
  - `cpu_utilization.target`: `0.9`

### Network Configuration

- **Resource**: `google_compute_network.static`
- **Description**: Creates a custom network.
- **Settings**:
  - `auto_create_subnetworks`: `false`

### Subnet Configuration

- **Resources**: Multiple `google_compute_subnetwork` resources.
- **Description**: Creates custom subnets.


### VPC Peering

- **Resource**: `google_service_networking_connection.private_vpc_connection`
- **Description**: Creates a VPC peering connection.

### NAT Configuration

- **Resources**: `google_compute_router.router`, `google_compute_router_nat.nat`
- **Description**: Configures NAT for the network.


## Usage

1. Clone the repository.
2. Navigate to the directory containing the Terraform configuration files.
3. Initialize Terraform:
   ```console
   terraform init
   ```
4. Review the plan:
   ```console
   terraform plan
   ```
5. Review the plan:
   ```console
   terraform apply
   ```

## Bucket module

1. Navigate to Bucket directory
2. Install gcloud cli (https://cloud.google.com/sdk/docs/install)
3. Add env variable for GOOGLE_APPLICATION_CREDENTIALS, powershell example:
    ```
    $env:GOOGLE_APPLICATION_CREDENTIALS = "path\to\your\credentials\file"
    ```
4. This step is required only once to store tfstate in GCP Bucket.