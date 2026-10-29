# Networking

Defines the shared network, three Windows VMs and department storage.

## Network

- **VNet:** `10.0.0.0/16`.
- **VM subnet:** `10.0.1.0/24`. NSG + NAT gateway attached.
- **Printer subnet:** `10.0.2.0/28`. No NSG or NAT; automatic outbound access disabled.
- **NAT gateway:** Standard · Zone 1 · 10-minute idle timeout.
- **Public IP:** Standard · Static · Zone 1 · Attached to NAT.

<details>
<summary><strong>Virtual machines</strong></summary>

- **Names:** `estates-vm`, `finance-vm`, `operations-vm`.
- **System:** Windows Server 2022.
- **Size:** `Standard_D2s_v4`.
- **System disk:** Standard LRS.
- **Network:** Own interface + dynamic private IP in the VM subnet.
- **Administrator:** `vmadmin`.
- **Password input:** `vm_admin_password`. Required; marked sensitive.
- **Password protection:** Hidden in normal output. Still present in state and saved plans.
- **Not configured:** VM public IPs, remote access, file mounts or printer software.

</details>

<details>
<summary><strong>File storage</strong></summary>

- **Departments:** Estates, Finance and Operations.
- **Subscription:** Shared.
- **Accounts:** One per department. Standard GRS.
- **Shares:** `estates-fileshare`, `finance`, `operations`.
- **Quota:** 500 GiB each.
- **Tier:** Hot.
- **Cost tracking:** Used `department` tags.

</details>
