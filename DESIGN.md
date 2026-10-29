# Design decisions

## Network

- **One virtual network:** groups the network resources in `10.0.0.0/16`.
- **Separate subnets:** `10.0.1.0/24` holds the three virtual machines; `10.0.2.0/28` is intended for printers. This separates their network addresses.
- **VM subnet security:** a network security group is attached to the VM subnet. Only Azure default rules apply, including permission for traffic within the VNet. No custom restrictions are defined. The printer subnet has no NSG; automatic outbound access is disabled there.
- **Outbound access:** a NAT gateway and static public IP are attached to the VM subnet to provide an outbound path. The printer subnet has no NAT gateway.
- **Private DNS:** removal is planned. The private DNS zone is still present in the current Terraform configuration.

## Virtual machines

- **One per department:** Estates, Finance and Operations each have a Windows Server 2022 VM in the shared VM subnet. Separate resource blocks keep the configuration straightforward.
- **Size and disk:** each uses `Standard_D2s_v4` with a Standard LRS system disk. Azure listed this size without subscription restrictions in UK South when checked. The three VMs require six processor cores; the regional and VM-family quotas each had ten available. A plan does not reserve capacity.
- **Private addresses:** each VM has its own network interface and a dynamic private IP. The existing NAT gateway provides the subnet's outbound path. No VM public IP, VPN or Bastion is configured.
- **Administrator:** all three VMs use `vmadmin` and a required sensitive password input. `sensitive = true` hides the password in normal Terraform output and carries that protection through the module input. It does not encrypt the password or remove it from state and saved plans. Those files must remain private; state, local variable files and saved plans are excluded from GitHub. No domain join, Microsoft Entra sign-in, file-share mounting or printer software is configured.

[Terraform sensitive values](https://developer.hashicorp.com/terraform/language/manage-sensitive-data) · [Azure NSG rules](https://learn.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview)

## Files and access

- **Departments:** one subscription holds the shared network and all three departments' storage accounts and file shares. Separate subscriptions are not required for this design. Printer access is not configured.
- **Cost tracking:** each storage account has a `department` tag set to `Estates`, `Finance` or `Operations`. Separate accounts allow storage costs to be grouped by department without separate subscriptions.
- **Azure Files:** managed file shares avoid the need for a dedicated file-server VM. Clients resolve the storage account address, connect using SMB on TCP 445, then authenticate with permission to the share.
- **Storage network access:** public network access is enabled; no private endpoints or storage network rules are defined. Resource group membership does not provide connectivity or file permissions. Private endpoints with suitable DNS would provide a private access path, but are not configured.
- **Printer access:** clients connect to printers separately. Storage accounts do not connect to printers.
- [Azure Files networking requirements](https://learn.microsoft.com/en-us/azure/storage/files/storage-files-networking-overview).
- **Capacity and access tier:** each share has a 500 GiB quota and uses the Hot tier, chosen for frequent access.
- **Replication:** each Standard storage account uses geo-redundant storage (GRS).
- **Identity:** Microsoft Entra ID and role-based access are intended for all three shares. Identity-based authentication and role assignments are not yet configured.

## Scope and limitations

- Three Windows VMs are defined in Terraform. Printer devices and a print service remain outside the configuration.
- No printer service, private endpoint, or file-share access permissions are configured.
- A live Terraform plan passed on 29 October 2026: 20 resources to add, none to change and one to destroy. The removal is the old printer-subnet NSG attachment. These changes have not been applied; file access, printing and network connectivity have not been tested.
- The resource group outputs currently all point to the first resource group; see the root README.
