# Azure department network

Terraform configuration for shared networking and department file storage in Azure UK South.

- One VNet (`10.0.0.0/16`) with a VM subnet (`10.0.1.0/24`) and printer subnet (`10.0.2.0/28`).
- The VM subnet uses a NAT gateway and static public IP for outbound connections. The printer subnet has an NSG, no NAT gateway and automatic outbound access disabled.
- Estates, Finance and Operations each have a Standard GRS storage account and a 500 GiB Hot file share. Department tags identify storage costs within one subscription.
- Five resource groups. No VMs, printers or print service are defined.

[Architecture diagram](architecture.html) · [Design decisions](DESIGN.md)

## Validation

- `terraform validate` and a live `terraform plan` passed on 29 October 2026: **13 to add, 0 to change, 0 to destroy**. These changes have not been applied.
- The plan used Finance account name `tfchfinance20261029` and Operations account name `tfchoperations20261029`. The Estates account is `tfchestates20261029`. All three names were available when checked; a plan does not reserve them.
- Finance and Operations account names are required inputs. The provider uses the Azure CLI subscription unless `ARM_SUBSCRIPTION_ID` is set.

## Limitations

- Storage uses public endpoints; no private endpoints are configured. Microsoft Entra ID authentication and file-share permissions are not configured. File access and network connectivity have not been tested.
- Printer access requires a print service and permissions. The subnet only reserves network addresses.
- The private DNS zone remains in Terraform; its removal is planned. It is omitted from the diagrams.
- Resource group outputs `rg1`, `rg2` and `rg3` all return `rg1`. Networking and Estates storage therefore use `networking_Rg`.
