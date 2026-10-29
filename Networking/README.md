# Networking

- VNet: `10.0.0.0/16`.
- VM subnet: `10.0.1.0/24`. NAT gateway attached.
- Three Windows Server 2022 VMs: `estates-vm`, `finance-vm` and `operations-vm`. Each has a network interface in the VM subnet, a dynamic private IP, size `Standard_D2s_v4` and a Standard LRS system disk.
- Local administrator: `vmadmin`. The sensitive `vm_admin_password` input is required. No VM public IPs, remote access service, file mounts or printer software are configured.
- Printer subnet: `10.0.2.0/28`. NSG attached. No NAT gateway. Automatic outbound access disabled.
- NAT gateway: Standard. Zone 1. Idle timeout: 10 minutes.
- Public IP: Standard. Static. Zone 1. Attached to the NAT gateway.
- Estates, Finance and Operations each have a storage account and 500 GiB Hot file share in one shared subscription. Accounts use Standard and GRS.
- Estates share: `estates-fileshare`.
- Storage accounts have `department` tags: `Estates`, `Finance` and `Operations`, for grouping storage costs.
