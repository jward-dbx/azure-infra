# Architecture Overview

## Project Structure

This Terraform project follows **enterprise-grade best practices** with a simplified, DRY (Don't Repeat Yourself) architecture.

```
azureinfra/
│
├── modules/                          # Reusable infrastructure modules
│   ├── networking/                   # Network infrastructure
│   │   ├── main.tf                  # VNet, subnets, NSG, NAT Gateway
│   │   ├── variables.tf             # Input variables
│   │   ├── outputs.tf               # Output values
│   │   └── README.md                # Module documentation
│   │
│   ├── databricks/                   # Databricks workspace
│   │   ├── main.tf                  # Workspace, access connector
│   │   ├── variables.tf             # Input variables
│   │   ├── outputs.tf               # Output values
│   │   └── README.md                # Module documentation
│   │
│   ├── sql/                          # SQL Server infrastructure
│   │   ├── main.tf                  # SQL Server, databases, PE
│   │   ├── variables.tf             # Input variables
│   │   ├── outputs.tf               # Output values
│   │   └── README.md                # Module documentation
│   │
│   └── storage/                      # Storage account
│       ├── main.tf                  # Storage with Data Lake Gen2
│       ├── variables.tf             # Input variables
│       ├── outputs.tf               # Output values
│       └── README.md                # Module documentation
│
├── environments/                     # Environment-specific configurations
│   ├── dev.tfvars                   # Development values
│   └── prod.tfvars                  # Production values
│
├── main.tf                          # Main configuration (calls modules)
├── variables.tf                     # Variable definitions
├── outputs.tf                       # Output definitions
├── provider.tf                      # Provider configuration
├── .gitignore                       # Git ignore rules
├── README.md                        # Main documentation
├── ARCHITECTURE.md                  # This file
└── QUICKSTART.md                   # Quick start guide
```

## Design Principles

### 1. DRY (Don't Repeat Yourself)
- Infrastructure code defined **once** in root-level Terraform files
- Modules are reusable components called from `main.tf`
- Environment differences are **only** in `.tfvars` files
- No code duplication between environments

### 2. Modularity
- Each service (networking, databricks, sql, storage) is a separate module
- Modules are reusable across environments
- Clear interfaces with inputs and outputs
- Single responsibility per module

### 3. Environment Separation via Configuration
- Same infrastructure code for all environments
- Environment-specific values in `.tfvars` files
- Easy to add new environments (just add a new `.tfvars` file)
- Consistency guaranteed across environments

### 4. Security by Design
- Private endpoints for data services
- Network Security Groups with least privilege
- Managed identities for authentication
- Secrets management via variables (not hardcoded)
- TLS 1.2 minimum for all services

### 5. Maintainability
- Single source of truth for infrastructure
- Easy to update (change once, applies everywhere)
- Comprehensive documentation
- Standard Terraform patterns

## Infrastructure Flow

```
┌──────────────────────────────────────────────────────────────┐
│                         main.tf                               │
│                  (Single Source of Truth)                     │
│                                                               │
│  ┌──────────────┐  ┌──────────────┐  ┌────────────────┐    │
│  │   Module:    │  │   Module:    │  │   Module:      │    │
│  │  Networking  │  │   Storage    │  │  Databricks    │    │
│  └──────┬───────┘  └──────────────┘  └───────┬────────┘    │
│         │                                     │              │
│         │          ┌──────────────┐          │              │
│         └─────────►│   Module:    │◄─────────┘              │
│                    │     SQL      │                          │
│                    └──────────────┘                          │
│                                                               │
└───────────────────────────┬───────────────────────────────────┘
                            │
                ┌───────────┴───────────┐
                │                       │
        ┌───────▼────────┐     ┌───────▼────────┐
        │  dev.tfvars    │     │  prod.tfvars   │
        │                │     │                 │
        │ - Dev values   │     │ - Prod values  │
        │ - Lower cost   │     │ - Higher perf  │
        │ - Public access│     │ - Private only │
        └────────────────┘     └─────────────────┘
```

## Module Dependencies

1. **Networking** is deployed first (no dependencies)
2. **Databricks** depends on networking (VNet, subnets, NSG)
3. **SQL** depends on networking (subnet for private endpoint)
4. **Storage** is independent (no dependencies)

## Deployment Model

### Traditional Approach (What We Use)

```
Terraform Code (main.tf, variables.tf, outputs.tf)
              ↓
    Apply with dev.tfvars  →  Development Environment
    Apply with prod.tfvars →  Production Environment
```

**Advantages:**
- ✅ Single source of truth
- ✅ No code duplication
- ✅ Guaranteed consistency
- ✅ Easy to maintain
- ✅ Standard Terraform pattern

**When to use:**
- Most common use case
- Similar infrastructure across environments
- Only configuration differences (sizes, SKUs, access levels)
- Want guaranteed consistency

### Alternative Approach (Not Used Here)

Some teams use separate Terraform files per environment:

```
environments/dev/       # Complete TF files
environments/prod/      # Complete TF files
```

**When this might be better:**
- Very different infrastructure per environment
- Different providers per environment
- Compliance requires complete isolation
- Large organizations with separate teams

**We chose the traditional approach because** your environments have the same infrastructure, just different configuration values.

## Network Architecture

### Development Environment (10.0.0.0/16)
```
┌─────────────────────────────────────────────────────────┐
│ VNet: wardvnet-dev (10.0.0.0/16)                        │
│                                                          │
│  ┌──────────────────────────────────────────────────┐   │
│  │ default (10.0.0.0/24)                            │   │
│  └──────────────────────────────────────────────────┘   │
│                                                          │
│  ┌──────────────────────────────────────────────────┐   │
│  │ sql-private-endpoints (10.0.1.0/24)              │   │
│  │   - SQL Server Private Endpoint                  │   │
│  └──────────────────────────────────────────────────┘   │
│                                                          │
│  ┌──────────────────────────────────────────────────┐   │
│  │ private (10.0.2.0/24) [Databricks]               │   │
│  │   - Delegated to Microsoft.Databricks/workspaces │   │
│  │   - NSG: nsg-ward-dbx-dev                        │   │
│  └──────────────────────────────────────────────────┘   │
│                                                          │
│  ┌──────────────────────────────────────────────────┐   │
│  │ public (10.0.3.0/24) [Databricks]                │   │
│  │   - Delegated to Microsoft.Databricks/workspaces │   │
│  │   - NSG: nsg-ward-dbx-dev                        │   │
│  └──────────────────────────────────────────────────┘   │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

### Production Environment (10.1.0.0/16)
```
┌─────────────────────────────────────────────────────────┐
│ VNet: wardvnet-prod (10.1.0.0/16)                       │
│                                                          │
│  [Same subnet structure, different CIDR ranges]         │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

## Environment Differences

All differences are in the `.tfvars` files:

| Feature | Development | Production |
|---------|------------|------------|
| **File** | `environments/dev.tfvars` | `environments/prod.tfvars` |
| VNet CIDR | 10.0.0.0/16 | 10.1.0.0/16 |
| SQL SKU | GP_S_Gen5_1 (Serverless) | GP_Gen5_2 |
| SQL DB Size | 32 GB | 100 GB |
| Storage Replication | LRS | GRS |
| SQL Public Access | Enabled | Disabled |
| Databricks Public Access | Enabled | Disabled |
| Cost Optimization | High | Balanced |
| Performance | Standard | High |

## Usage Patterns

### Deploying to Development

```bash
terraform init
terraform plan -var-file="environments/dev.tfvars"
terraform apply -var-file="environments/dev.tfvars"
```

### Deploying to Production

```bash
terraform plan -var-file="environments/prod.tfvars"
terraform apply -var-file="environments/prod.tfvars"
```

### Adding a New Environment

```bash
# 1. Create new tfvars file
cp environments/dev.tfvars environments/staging.tfvars

# 2. Edit with staging values
vim environments/staging.tfvars

# 3. Deploy
terraform apply -var-file="environments/staging.tfvars"
```

### Making Infrastructure Changes

```bash
# 1. Edit main.tf or module files
vim main.tf

# 2. Apply to dev first
terraform apply -var-file="environments/dev.tfvars"

# 3. Test in dev

# 4. Apply to prod
terraform apply -var-file="environments/prod.tfvars"
```

## Best Practices Checklist

- ✅ Modular architecture with reusable components
- ✅ DRY principle (single source of truth)
- ✅ Environment separation via `.tfvars` files
- ✅ Variable-driven configuration
- ✅ No hardcoded values
- ✅ Comprehensive documentation
- ✅ Security by design
- ✅ Consistent naming conventions
- ✅ Version control with .gitignore
- ✅ Remote state support
- ✅ Sensitive values marked
- ✅ README per module
- ✅ Clear outputs

## Why This Structure?

### Advantages

1. **DRY (Don't Repeat Yourself)**
   - Write code once, use everywhere
   - No duplication to maintain
   - Changes automatically apply to all environments

2. **Consistency**
   - Same infrastructure code guarantees consistency
   - No drift between environments
   - Easy to compare environments

3. **Maintainability**
   - Single place to make changes
   - Less code to review
   - Easier to understand

4. **Standard Pattern**
   - Most common Terraform pattern
   - Industry-standard approach
   - Easy for new team members

5. **Scalability**
   - Easy to add new environments
   - Just add a new `.tfvars` file
   - No code changes needed

### When This Works Best

- ✅ Similar infrastructure across environments
- ✅ Only configuration differences (SKUs, sizes, etc.)
- ✅ Want consistency and maintainability
- ✅ Standard use cases
- ✅ Small to medium teams

## Future Enhancements

### Planned Additions
1. **Monitoring Module**: Azure Monitor, Log Analytics
2. **Key Vault Module**: Centralized secrets management
3. **Backup Module**: Azure Backup configurations
4. **Policy Module**: Azure Policy for governance

### Potential Improvements
- Automated testing with Terratest
- CI/CD pipeline templates
- Cost estimation integration
- Compliance scanning
- Multi-region support

## References

- [Terraform Best Practices](https://www.terraform-best-practices.com/)
- [Azure Well-Architected Framework](https://docs.microsoft.com/en-us/azure/architecture/framework/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [HashiCorp Terraform Standards Module](https://developer.hashicorp.com/terraform/language/modules/develop/structure)
