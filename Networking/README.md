# Networking

- VNet: `10.0.0.0/16`.
- VM subnet: `10.0.1.0/24`. NAT gateway attached.
- Printer subnet: `10.0.2.0/28`. NSG attached. No NAT gateway. Automatic outbound access disabled.
- NAT gateway: Standard. Zone 1. Idle timeout: 10 minutes.
- Public IP: Standard. Static. Zone 1. Attached to the NAT gateway.
- Estates, Finance and Operations each have a storage account and 500 GiB Hot file share in one shared subscription. Accounts use Standard and GRS.
- Estates share: `estates-fileshare`.
- Storage accounts have `department` tags: `Estates`, `Finance` and `Operations`, for grouping storage costs.
