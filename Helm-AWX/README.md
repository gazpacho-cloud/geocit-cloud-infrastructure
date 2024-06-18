# AWX Deployment

This repository contains the necessary files to deploy AWX using Terraform, Helm, and Kubernetes on Google Cloud.

## Prerequisites

- Google Cloud SDK (`gcloud`)
- Terraform
- Helm
- kubectl

## Deployment Steps

### 1. Download Your Service Key

Download your service key with the correct permissions:

```bash
gcloud auth login
gcloud auth activate-service-account --key-file=path/to/your-service-account-key.json



Update your Kubernetes context to point to your GKE cluster:

gcloud container clusters get-credentials <name of the cluster> --region <e.g europe-west3> --project <proj name>

Navigate to the Terraform deployment directory:

terraform init

terraform apply

Get credentials for AWX 

$base64Password = kubectl get secret awx-admin-password -n <your namespace> -o jsonpath="{.data.password}"
$decodedPassword = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($base64Password))
Write-Output "AWX Admin Username: <admin or whicher user you are using>"
Write-Output "AWX Admin Password: $decodedPassword"
