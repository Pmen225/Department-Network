# Terraform Challenge

- Azure networking. UK South.
- Separate resource group and networking modules.
- VNet: `10.0.0.0/16`.
- VM subnet: `10.0.1.0/24`. NAT gateway and static public IP for outbound traffic.
- Printer subnet: `10.0.2.0/28`. NSG attached. No NAT gateway. Automatic outbound access disabled.
- Three resource groups. No VMs or printers defined.
- Local state. State files excluded from Git.

## Known issue

- `rg1`, `rg2` and `rg3` outputs all return `rg1`. Networking uses `networking_Rg`.
