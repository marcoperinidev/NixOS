# NixOS Configuration

Personal NixOS configuration for my machines.

## Installation

After installing NixOS with the graphical installer:

1. Clone this repo:
   ```bash
   git clone https://github.com/YOUR-USERNAME/nixos-config.git /tmp/nixos-config
	```
## Backup the auto-generated hardware config:
	```bash
	sudo cp /etc/nixos/hardware-configuration.nix /tmp/hardware-backup.nix
	```
2. Copy configuration:
	```bash
	sudo cp /tmp/nixos-config/configuration.nix /etc/nixos/
	```
3. Restore hardware config (machine-specific):
	```bash
	sudo cp /tmp/hardware-backup.nix /etc/nixos/hardware-configuration.nix
	```
# Rebuild:
	```bash
	sudo nixos-rebuild switch
	```

# Maintenance

To update the configuration in the repo:

```bash
	cd /etc/nixos
	git add configuration.nix
	git commit -m "Update config"
	git push
```