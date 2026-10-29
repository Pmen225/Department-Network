# Design decisions

Network, storage and VM choices for Estates, Finance and Operations.

## Subscription

- **Choice:** One subscription for the shared network and all three departments.
- **Reason:** Avoid extra subscription management for this design.
- **Cost tracking:** Used `department` tags on storage accounts.

## Network

- **VNet:** `10.0.0.0/16`.
- **VM subnet:** `10.0.1.0/24`.
- **Printer subnet:** `10.0.2.0/28`.
- **Reason:** Separate address ranges for VMs and printers.

<details>
<summary><strong>Security and internet access</strong></summary>

- **NSG:** Attached to the VM subnet.
- **Rules:** Defaults only. Internal VNet traffic allowed; no custom restrictions.
- **Outbound path:** NAT gateway + static public IP on the VM subnet.
- **Printer subnet:** No NSG or NAT. Automatic outbound access disabled.
- **DNS zone:** Removal listed under To do.

[Azure NSG rules](https://learn.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview)

</details>

## Virtual machines

- **Choice:** One Windows Server 2022 VM per department.
- **Size:** `Standard_D2s_v4`. Standard LRS system disk.
- **Network:** Dynamic private IP per VM. No public VM addresses.

<details>
<summary><strong>Password protection</strong></summary>

- **Administrator:** `vmadmin` on all three VMs.
- **Input:** `vm_admin_password`. Supplied at deployment; Terraform does not generate it.
- **sensitive = true:** Hides the password in normal Terraform output.
- **Limit:** Does not encrypt it or remove it from state and saved plans.
- **GitHub:** State, saved plans and local variable files excluded.

[Terraform sensitive values](https://developer.hashicorp.com/terraform/language/manage-sensitive-data)

</details>

## File storage

- **Choice:** Azure Files. One storage account and share per department.
- **Reason:** Managed storage; no dedicated file-server VM.
- **Tier:** Hot, for frequent access.
- **Quota:** 500 GiB per share.
- **Replication:** Standard GRS.

<details>
<summary><strong>File and printer access</strong></summary>

- **Files:** VM → storage address → authentication → share permissions.
- **Connection:** SMB, TCP 445.
- **Storage:** Public endpoints enabled. No private endpoints or storage network rules.
- **Resource groups:** Organise resources; do not provide connections or permissions.
- **Entra ID + RBAC:** Authentication and role assignments listed under To do.
- **Printers:** Clients connect separately. Storage accounts do not send print jobs.
- **Private access option:** Requires private endpoints and suitable DNS. Not configured.

[Azure Files networking requirements](https://learn.microsoft.com/en-us/azure/storage/files/storage-files-networking-overview)

</details>

## Checks

- **Date:** 29 October 2026.
- **Terraform validation:** Passed.
- **Live plan:** **20 add · 0 change · 1 destroy**.
- **Removal:** Old printer-subnet NSG attachment.
- **Apply:** Not run for these changes.

<details>
<summary><strong>Account names and VM capacity</strong></summary>

- **Estates:** `tfchestates20261029`.
- **Finance:** `tfchfinance20261029`.
- **Operations:** `tfchoperations20261029`.
- **Names:** Available when checked. The plan does not reserve them.
- **VM size:** Listed without subscription restrictions in UK South when checked.
- **Cores:** Six required. Ten available in both regional and VM-family quotas when checked.
- **Capacity:** Not reserved by the plan.

</details>

## To do

See the [To do list](README.md) for the remaining setup and tests.
