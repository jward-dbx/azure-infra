# Quick Start Guide

Get up and running with this Terraform project in 5 minutes!

## Prerequisites

Before you begin, ensure you have:

- ✅ [Terraform](https://www.terraform.io/downloads.html) >= 1.0 installed
- ✅ [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed
- ✅ Azure subscription with appropriate permissions

## 5-Minute Setup

### Step 1: Authenticate with Azure

```bash
az login
az account set --subscription "YOUR_SUBSCRIPTION_ID"
az account show  # Verify correct subscription
```

### Step 2: Configure Variables

Choose your environment and edit the corresponding `.tfvars` file:

```bash
# For development
vim environments/dev.tfvars

# OR for production
vim environments/prod.tfvars
```

**Critical values to update:**
- `resource_group_name` - Your Azure resource group
- `nat_gateway_public_ip_id` - Your NAT Gateway public IP resource ID
- `sql_admin_password` - A secure password (or use environment variable)
- `sql_azuread_admin_login` - Your Azure AD admin email
- `sql_azuread_admin_object_id` - Your Azure AD object ID
- `sql_azuread_admin_tenant_id` - Your Azure AD tenant ID

**Better: Use environment variables for secrets:**

```bash
export TF_VAR_sql_admin_password="YourSecurePassword123!"
```

### Step 3: Initialize Terraform

```bash
terraform init
```

This will download the Azure provider and initialize modules.

### Step 4: Preview Changes

```bash
# For development
terraform plan -var-file="environments/dev.tfvars"

# For production
terraform plan -var-file="environments/prod.tfvars"
```

Review the output to see what will be created.

### Step 5: Deploy Infrastructure

```bash
# For development
terraform apply -var-file="environments/dev.tfvars"

# For production
terraform apply -var-file="environments/prod.tfvars"
```

Type `yes` when prompted to confirm.

⏱️ **Deployment time**: Approximately 10-15 minutes

### Step 6: View Outputs

After successful deployment:

```bash
terraform output
```

This shows important information like:
- Databricks workspace URL
- SQL Server FQDN
- Storage account endpoints
- Network IDs

## Common Commands

### View Current State
```bash
terraform show
```

### List Resources
```bash
terraform state list
```

### View Outputs
```bash
terraform output
```

### Refresh State
```bash
terraform refresh -var-file="environments/dev.tfvars"
```

### Destroy Infrastructure
```bash
terraform destroy -var-file="environments/dev.tfvars"
```

⚠️ **Warning**: This permanently deletes all resources!

## Working with Multiple Environments

### Development Deployment

```bash
terraform init
terraform plan -var-file="environments/dev.tfvars"
terraform apply -var-file="environments/dev.tfvars"
```

### Production Deployment

```bash
terraform init
terraform plan -var-file="environments/prod.tfvars"
terraform apply -var-file="environments/prod.tfvars"
```

### Create Staging Environment

```bash
# Copy dev config as template
cp environments/dev.tfvars environments/staging.tfvars

# Edit with staging-specific values
vim environments/staging.tfvars

# Deploy
terraform apply -var-file="environments/staging.tfvars"
```

## File Structure Quick Reference

```
azureinfra/
├── modules/              # Reusable infrastructure modules
│   ├── networking/      # VNet, subnets, NSG
│   ├── databricks/      # Databricks workspace
│   ├── sql/            # SQL Server and databases
│   └── storage/        # Storage account
│
├── environments/        # Environment-specific values
│   ├── dev.tfvars      # Development
│   └── prod.tfvars     # Production
│
├── main.tf             # Main configuration
├── variables.tf        # Variable definitions
├── outputs.tf          # Output definitions
└── provider.tf         # Provider configuration
```

## Troubleshooting

### Issue: Authentication Error

**Solution:**
```bash
az login
az account show
```

### Issue: Resource Already Exists

**Solution:**
```bash
# Import existing resource
terraform import azurerm_resource_group.example /subscriptions/.../resourceGroups/...

# Or change the name in your .tfvars file
```

### Issue: Module Not Found

**Solution:**
```bash
terraform init -upgrade
```

### Issue: State Lock Error

**Solution:**
```bash
# If lock is stuck (use with caution!)
terraform force-unlock LOCK_ID
```

## Next Steps

After successful deployment:

1. **Verify Resources**: Check Azure Portal to confirm resources
2. **Test Connectivity**: Try connecting to Databricks workspace
3. **Configure Access**: Set up RBAC and permissions
4. **Enable Monitoring**: Configure Azure Monitor and alerts
5. **Document**: Update any custom configurations

## Tips for Success

### 1. Start with Development
Test everything in dev before deploying to production.

### 2. Use Version Control
```bash
git add .
git commit -m "Updated configuration"
git push
```

### 3. Keep Secrets Safe
Never commit sensitive values - use environment variables or Azure Key Vault.

### 4. Review Plans
Always review `terraform plan` output before applying.

### 5. Document Changes
Keep track of what you change and why.

## Getting Help

### Documentation
- [Main README](README.md) - Comprehensive documentation
- [Architecture Guide](ARCHITECTURE.md) - Design and structure details

### Module Documentation
- [Networking Module](modules/networking/README.md)
- [Databricks Module](modules/databricks/README.md)
- [SQL Module](modules/sql/README.md)
- [Storage Module](modules/storage/README.md)

### External Resources
- [Terraform Documentation](https://www.terraform.io/docs)
- [Azure Provider Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Documentation](https://docs.microsoft.com/en-us/azure/)

## Success! 🎉

You've successfully deployed your Azure infrastructure with Terraform!

---

**Need Help?** Check the [README](README.md) for more detailed information.
