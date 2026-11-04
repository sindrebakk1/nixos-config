# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Commands

```bash
# Build and switch a host configuration
sudo nixos-rebuild switch --flake .#wsl
sudo nixos-rebuild switch --flake .#home-server

# Build without switching (test)
nixos-rebuild build --flake .#home-server

# Update flake inputs
nix flake update

# Edit and re-encrypt secrets
sops secrets/common.yaml

# Format Nix files
nix fmt
```

## Architecture

This is a NixOS flake-based multi-host configuration. All hosts share the same module layers, applied in this order:

1. Infrastructure module (nixos-wsl or sops-nix)
2. `home-manager.nixosModules.default` — user dotfile management
3. `./modules/core` — system-level NixOS modules
4. `./hosts/{hostname}` — host-specific config
5. `./modules/hm` — Home Manager modules (run in user context)

### Profile Options (`modules/core/profile.nix`)

All customization flows through the `profile.*` options namespace. This is the central interface — hosts set `profile` options, and the core/HM modules consume them. Key options:

- `profile.username` / `profile.uid` / `profile.extraGroups`
- `profile.userAuth.*` — password from SOPS or disabled (WSL uses disabled)
- `profile.homeManager.git.*` — git config, GitHub PAT from SOPS
- `profile.homeManager.ssh.*` — key generation, authorized_keys from SOPS
- `profile.homeManager.shell.*` — Bash + Starship
- `profile.homeManager.ffmpeg.*` — ffmpeg-full package

Adding a new host: create `hosts/hostname/default.nix`, set `profile` options, add entry to `flake.nix` outputs.

### Secrets Management (sops-nix)

Secrets are split between two layers with different lifecycles:

- **System secrets** (`modules/core/sops.nix`): Decrypted at boot by root using age key at `/var/lib/sops-nix/keys.txt`. Used for things that must exist before login (password hashes, SSH `authorized_keys`).
- **User secrets** (`modules/hm/bind.nix`): Decrypted by a systemd user service using `~/.config/sops/age/keys.txt` (auto-generated on first HM activation). Used for session-scoped things (GitHub PAT).

SSH `authorized_keys` is a *system* secret (not HM) because it must be available before the user logs in.

`.sops.yaml` controls which age keys can decrypt `secrets/common.yaml`.

### Hosts

- **wsl** — WSL2 instance; password auth disabled, Docker Desktop bridge enabled
- **home-server** — Bare metal server at 192.168.1.10; runs Caddy, Samba, Dnsmasq, WireGuard VPN (wg0), Docker Compose (Plex, QBittorrent), Cloudflare DynDNS
