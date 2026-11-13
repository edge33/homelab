# Homelab

Docker Compose stacks for:

- [Pi-hole](pi-hole/README.md)
- [Samba](samba/README.md)
- [qBittorrent](qbittorrent/README.md)
- [Nginx Proxy Manager](nginx-proxy-manager/README.md)
- [Tailscale](tailscale/README.md)
- [Home Assistant](homeassistant/README.md)
- [Jellyfin](jellyfin/README.md)
- [Radarr](radarr/README.md)
- [aMule](amule/README.md)
- [Hermes Agent](hermes/README.md)
- [Garage Bot](garage-bot/README.md)

Use a Linux host with Docker Engine and the Compose plugin. Follow the service
README for Compose setup and upstream links for application configuration.
Run from the service's directory:

```sh
docker compose up -d
```

Keep existing `.env` files and state when reusing an installation. Back them up
before upgrades; do not commit credentials or runtime data. Keep management
interfaces restricted to trusted networks.

## Updates

Back up service state, review upstream upgrade requirements, then run from the
service directory on the deployment branch (`main` normally):

```sh
git pull --ff-only &&
docker compose pull &&
docker compose up -d
```

Renovate opens image update PRs; deployment is manual. Rollbacks may require
restoring the matching state backup. Do not use `docker compose down -v` unless
you intend to delete named-volume state.
