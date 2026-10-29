# Department Network

Shared Azure networking, three Windows VMs and department file shares.

**Region:** UK South · **Departments:** Estates, Finance, Operations

> **Status:** Latest changes planned, not applied.

[Architecture diagram](architecture.html) · [Design decisions](DESIGN.md)

<details open>
<summary><strong>Network</strong></summary>

- **Subscription:** One shared subscription.
- **VNet:** `10.0.0.0/16`.
- **VM subnet:** `10.0.1.0/24`. NSG + NAT gateway attached.
- **Internet access:** NAT gateway + static public IP.
- **Printer subnet:** `10.0.2.0/28`. No NSG or NAT. Automatic outbound access disabled.
- **Resource groups:** Five defined. See the output issue below.

</details>

<details>
<summary><strong>Virtual machines</strong></summary>

- **VMs:** Estates, Finance and Operations.
- **System:** Windows Server 2022.
- **Size:** `Standard_D2s_v4`.
- **System disk:** Standard LRS.
- **Addresses:** Dynamic private IPs. No VM public IPs.
- **Administrator:** `vmadmin`.

</details>

<details>
<summary><strong>File storage</strong></summary>

- **Accounts:** One per department. Standard GRS.
- **Cost tracking:** Used `department` tags.

| Department | File share | Quota | Tier |
| --- | --- | --- | --- |
| Estates | `estates-fileshare` | 500 GiB | Hot |
| Finance | `finance` | 500 GiB | Hot |
| Operations | `operations` | 500 GiB | Hot |

</details>

<details>
<summary><strong>Password protection</strong></summary>

- **Source:** `vm_admin_password` supplied at deployment. Terraform does not generate it.
- **Key Vault:** Not configured.
- **Output:** `sensitive = true` hides the password in normal output.
- **State + saved plans:** Contain the password. These files are excluded from GitHub.

</details>

<details>
<summary><strong>Not configured / known issues</strong></summary>

- **VM access:** No VPN or Bastion.
- **Files:** No mounts, Entra ID authentication or share permissions.
- **Storage:** Public endpoints. No private endpoints or network restrictions.
- **Printing:** No printer devices or print service. The subnet only reserves addresses.
- **Connectivity:** File access, printing and network connections untested.
- **DNS zone:** Still in Terraform. Removal planned; omitted from the diagram.
- **Outputs:** `rg1`, `rg2` and `rg3` all return `rg1`.
- **Effect:** Network, VMs and Estates storage use `networking_Rg`.

</details>

<details>
<summary><strong>Deployment inputs</strong></summary>

- **Required:** Finance and Operations account names; `vm_admin_password`.
- **Subscription:** Azure CLI selection, unless `ARM_SUBSCRIPTION_ID` is set.
- **Plan password:** Temporary. Supply a password before deployment.
- **Account names checked:** Recorded in [design decisions](DESIGN.md#checks).

</details>
