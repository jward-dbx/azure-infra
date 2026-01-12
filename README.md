# Azure Infrastructure with Terraform

Enterprise-grade Terraform configuration for deploying Azure infrastructure including Databricks, SQL Server, networking, and storage resources.

## 📁 Project Structure

```
azureinfra/
├── modules/                    # Reusable Terraform modules
│   ├── networking/            # VNet, subnets, NSG, NAT Gateway
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── README.md
│   ├── databricks/            # Databricks workspace and access connector
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── README.md
│   ├── sql/                   # SQL Server, databases, private endpoints
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── README.md
│   └── storage/               # Storage account with Data Lake Gen2
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── README.md
├── environments/              # Environment-specific configurations
│   ├── dev.tfvars            # Development environment values
│   └── prod.tfvars           # Production environment values
├── main.tf                   # Main Terraform configuration
├── variables.tf              # Variable definitions
├── outputs.tf                # Output definitions
├── provider.tf               # Provider configuration
├── .gitignore               # Git ignore rules for Terraform
└── README.md                # This file
```

## 🏗️ Architecture

### Modular Design

This project uses a **modular architecture** where infrastructure is defined once in `main.tf` and customized per environment using `.tfvars` files.

#### Modules

**1. Networking Module** (`modules/networking/`)
- Virtual Network with custom address space
- Four subnets (default, SQL PE, Databricks private/public)
- Network Security Group with Databricks-specific rules
- NAT Gateway for outbound connectivity
- Subnet delegations for Databricks

**2. Databricks Module** (`modules/databricks/`)
- Azure Databricks Workspace (Premium SKU)
- Databricks Access Connector with managed identity
- VNet injection with no public IP option
- Unity Catalog support

**3. SQL Module** (`modules/sql/`)
- Azure SQL Server with Azure AD authentication
- Multiple SQL databases (configurable)
- Private endpoint for secure connectivity
- Private DNS zone for name resolution

**4. Storage Module** (`modules/storage/`)
- Storage Account (StorageV2)
- Hierarchical namespace (Data Lake Gen2)
- Blob soft delete and retention policies
- Large file share support

## 🚀 Quick Start

### Prerequisites

1. [Terraform](https://www.terraform.io/downloads.html) >= 1.0
2. [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
3. Azure subscription with appropriate permissions

### Authentication

```bash
az login
az account set --subscription "YOUR_SUBSCRIPTION_ID"
```

### Deploy to Development

```bash
# Initialize Terraform
terraform init

# Preview changes
terraform plan -var-file="environments/dev.tfvars"

# Deploy
terraform apply -var-file="environments/dev.tfvars"
```

### Deploy to Production

```bash
# Initialize Terraform (if not already done)
terraform init

# Preview changes
terraform plan -var-file="environments/prod.tfvars"

# Deploy
terraform apply -var-file="environments/prod.tfvars"
```

## 📖 Detailed Usage

### Single Source of Truth

All infrastructure is defined in the root-level Terraform files:

- **`main.tf`** - Calls modules with configuration
- **`variables.tf`** - All variable definitions
- **`outputs.tf`** - All output values
- **`provider.tf`** - Provider and backend configuration

### Environment-Specific Values

Each environment has its own `.tfvars` file in the `environments/` folder:

- **`environments/dev.tfvars`** - Development values
- **`environments/prod.tfvars`** - Production values

To add a new environment (e.g., staging):

```bash
cp environments/dev.tfvars environments/staging.tfvars
# Edit staging.tfvars with staging-specific values
terraform apply -var-file="environments/staging.tfvars"
```

### Working with Terraform

```bash
# Format code
terraform fmt -recursive

# Validate configuration
terraform validate

# Plan changes for specific environment
terraform plan -var-file="environments/dev.tfvars"

# Apply changes
terraform apply -var-file="environments/dev.tfvars"

# Show current state
terraform show

# View outputs
terraform output

# Destroy infrastructure
terraform destroy -var-file="environments/dev.tfvars"
```

## 🔐 Security Best Practices

### Secrets Management

⚠️ **NEVER commit sensitive values to version control!**

**Option 1: Environment Variables (Recommended for local development)**

```bash
export TF_VAR_sql_admin_password="YourSecurePassword"
terraform apply -var-file="environments/dev.tfvars"
```

**Option 2: Azure Key Vault (Recommended for production)**

```hcl
data "azurerm_key_vault_secret" "sql_password" {
  name         = "sql-admin-password"
  key_vault_id = var.key_vault_id
}

# In main.tf, pass to module:
admin_password = data.azurerm_key_vault_secret.sql_password.value
```

**Option 3: Terraform Cloud/Enterprise**

Use secure variable storage in Terraform Cloud for team collaboration.

### Network Security

- **Development**: Public access enabled for easier testing
- **Production**: Public access disabled, private endpoints only
- All environments use NSG rules and network isolation

## 🎯 Environment Differences

| Feature | Development | Production |
|---------|------------|------------|
| **File** | `environments/dev.tfvars` | `environments/prod.tfvars` |
| **VNet CIDR** | 10.0.0.0/16 | 10.1.0.0/16 |
| **SQL SKU** | GP_S_Gen5_1 (Serverless) | GP_Gen5_2 |
| **SQL DB Size** | 32 GB | 100 GB |
| **Storage Replication** | LRS | GRS |
| **SQL Public Access** | Enabled | Disabled |
| **Databricks Public Access** | Enabled | Disabled |
| **Cost Optimization** | High | Balanced |

## 🔧 Customization

### Modifying Infrastructure

1. **Update variables**: Edit the appropriate `.tfvars` file
2. **Modify resources**: Edit `main.tf` or module files
3. **Add new modules**: Create under `modules/` and reference in `main.tf`

### Adding Resources

To add new resources:

1. **If related to existing module**: Add to the module's `main.tf`
2. **If new service**: Create a new module under `modules/`
3. **Update main.tf**: Add module call
4. **Update variables.tf**: Add any new variables
5. **Update outputs.tf**: Add any new outputs

### Example: Adding a New Database

Edit `environments/dev.tfvars`:

```hcl
sql_databases = {
  adventure_works_a = { ... }
  adventure_works_b = { ... }
  new_database = {
    name         = "new-database"
    sku_name     = "GP_S_Gen5_1"
    max_size_gb  = 32
    min_capacity = 0.5
    collation    = "SQL_Latin1_General_CP1_CI_AS"
  }
}
```

Then apply:

```bash
terraform apply -var-file="environments/dev.tfvars"
```

## 📊 Outputs

After deployment, view outputs:

```bash
terraform output
```

Common outputs include:
- Virtual Network IDs and subnet IDs
- Databricks workspace URL
- SQL Server FQDN
- Storage account endpoints
- Private endpoint IP addresses

## 🧪 Testing

### Validate Configuration

```bash
terraform validate
```

### Format Code

```bash
terraform fmt -recursive
```

### Plan Without Apply

```bash
terraform plan -var-file="environments/dev.tfvars" -out=tfplan
# Review the plan
# If approved:
terraform apply tfplan
```

## 🗑️ Cleanup

To destroy resources:

```bash
terraform destroy -var-file="environments/dev.tfvars"
```

⚠️ **WARNING**: This permanently deletes all resources. Ensure you have backups!

## 📚 Module Documentation

Each module has its own README with detailed documentation:

- [Networking Module](modules/networking/README.md)
- [Databricks Module](modules/databricks/README.md)
- [SQL Module](modules/sql/README.md)
- [Storage Module](modules/storage/README.md)

## 🎯 Best Practices Implemented

### 1. **DRY (Don't Repeat Yourself)**
- Single source of truth for infrastructure code
- No duplication between environments
- Reusable modules

### 2. **Environment Separation**
- Clear separation via `.tfvars` files
- Different address spaces to prevent conflicts
- Environment-specific security settings

### 3. **Variable-Driven Configuration**
- All values parameterized
- No hardcoded values
- Easy to customize

### 4. **Security First**
- Private endpoints for data services
- Network Security Groups with strict rules
- Managed identities for authentication
- TLS 1.2 minimum
- Sensitive values marked as sensitive

### 5. **Comprehensive Documentation**
- README files for modules and root
- Inline comments
- Usage examples
- Input/output documentation

### 6. **Version Control**
- `.gitignore` configured for Terraform
- Secrets excluded from repository
- State files not committed

### 7. **Modular Architecture**
- Reusable components
- Clear separation of concerns
- Easy to maintain and extend

### 8. **Consistent Naming**
- Resource naming conventions
- Environment prefixes/suffixes
- Clear, descriptive names

## 🔄 Remote State (Recommended)

For team collaboration, enable remote state by uncommenting in `provider.tf`:

```hcl
backend "azurerm" {
  resource_group_name  = "rg-terraform-state"
  storage_account_name = "sttfstate"
  container_name       = "tfstate"
  key                  = "terraform.tfstate"
}
```

Then run:

```bash
terraform init -reconfigure
```

Benefits:
- Team collaboration with state locking
- Secure state storage
- State backup and versioning

## 🐛 Troubleshooting

### Common Issues

**Issue**: Module not found
```bash
terraform init -upgrade
```

**Issue**: State lock error
```bash
# If lock is stuck (use with caution!)
terraform force-unlock <LOCK_ID>
```

**Issue**: Provider version conflict
```bash
terraform init -upgrade
```

**Issue**: Authentication errors
```bash
az login
az account show
```

## 📞 Support

For issues or questions:
1. Check module README files
2. Review Terraform documentation
3. Check Azure provider documentation
4. Review error messages and logs

## 📄 License

[Add your license information here]

## 🤝 Contributing

1. Create a feature branch
2. Make changes and test in dev environment
3. Update documentation
4. Submit pull request with description

## 📈 Roadmap

Future enhancements:
- [ ] Add monitoring and alerting module
- [ ] Add Key Vault module for secrets management
- [ ] Add Azure Policy module for governance
- [ ] Add backup and disaster recovery configurations
- [ ] Add cost optimization recommendations
- [ ] Add automated testing with Terratest

## 🔗 Additional Resources

- [Terraform Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Databricks Documentation](https://docs.microsoft.com/en-us/azure/databricks/)
- [Azure SQL Database Documentation](https://docs.microsoft.com/en-us/azure/azure-sql/)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)
- [Azure Architecture Center](https://docs.microsoft.com/en-us/azure/architecture/)

## 💡 Why This Structure?

This project uses a **simplified, traditional Terraform structure** where:

✅ Infrastructure code is defined once (DRY principle)  
✅ Environment differences are in `.tfvars` files only  
✅ Changes automatically apply to all environments  
✅ Easier to maintain with less duplication  
✅ Standard Terraform pattern used by most teams

This approach is ideal for:
- Teams that want consistency across environments
- Organizations with similar infrastructure per environment
- Projects where the only differences are configuration values
- Faster development with less maintenance overhead
