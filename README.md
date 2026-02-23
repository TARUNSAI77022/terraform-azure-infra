# Azure Terraform Infrastructure

This repository contains Terraform code to deploy an Azure Virtual Machine configured with Docker and Jenkins, all managed via a GitHub Actions CI/CD pipeline.

## Prerequisites
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed
- [Terraform](https://developer.hashicorp.com/terraform/downloads) installed
- An active Azure subscription

## Getting Started

### 1. Setup the Azure Remote Backend
Terraform state must be securely stored in an Azure Storage Account so that GitHub Actions can access it across workflow runs.

1. Ensure you are logged into Azure:
   ```bash
   az login
   ```
2. Run the provided setup script:
   ```bash
   bash scripts/setup-remote-backend.sh
   ```
3. The script will output an Azure Storage Account Name. Open `environments/dev/backend.tf` and replace `REPLACE_WITH_YOUR_STORAGE_ACCOUNT_NAME` with this name.

### 2. Create a Service Principal
GitHub needs permission to deploy infrastructure in your Azure subscription. Create a Service Principal by running the following command in your terminal:

```bash
az ad sp create-for-rbac --name "GitHubActions-Terraform" --role Contributor --scopes /subscriptions/<YOUR_SUBSCRIPTION_ID>
```
*(Make sure to replace `<YOUR_SUBSCRIPTION_ID>` with your actual Azure Subscription ID)*

This command will output JSON credentials similar to this:
```json
{
  "appId": "YOUR_CLIENT_ID",
  "password": "YOUR_CLIENT_SECRET",
  "tenant": "YOUR_TENANT_ID"
}
```

### 3. Setup GitHub Secrets
Configure credentials so GitHub Actions can authenticate with Azure securely.

Navigate to your GitHub Repository -> **Settings** -> **Secrets and variables** -> **Actions** -> **New repository secret**.

Add the following four secrets using the values from the previous step:
- `AZURE_CLIENT_ID`: Paste the `appId` value.
- `AZURE_CLIENT_SECRET`: Paste the `password` value.
- `AZURE_SUBSCRIPTION_ID`: Paste your Subscription ID.
- `AZURE_TENANT_ID`: Paste the `tenant` value.

### 4. Deploy Infrastructure
Once the remote backend and secrets are configured, commit and push your code to the `main` branch:

```bash
git add .
git commit -m "Initialize infrastructure setup"
git push origin main
```
The GitHub Actions workflow will trigger automatically and deploy the VNet, Subnet, NSG, and Virtual Machine running Docker and Jenkins!
