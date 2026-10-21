# Home Assistant

Uses `ghcr.io/home-assistant/home-assistant:2026.10.2`, following the official
[Linux container installation](https://www.home-assistant.io/installation/linux/).
This is Home Assistant Container, without Supervisor or managed add-ons.

## Local configuration

Use a Linux host with Docker Engine 23 or newer. From the repository root:

```sh
cd homeassistant
mkdir -p config
```

Configuration uses the local bind mount `./config:/config`, relative to the
Compose file. No `.env` file is needed. The directory is ignored by Git and
contains credentials, integration settings, and the database. Back it up
securely and keep using the same deployment checkout.

For an existing installation, stop the old container and back up the complete
configuration directory, including hidden files such as `.storage`. Copy it
into `config` beside this Compose file, preserving ownership and permissions.
Do not run two instances against the same configuration. An empty directory
starts onboarding instead of restoring your home.

## Host access

Host networking preserves LAN device discovery; port `8123` must be available
and no Compose port mapping is needed. This stack retains the existing
privileged mode, which grants broad host-device access and matches the official
container example. Separate `NET_ADMIN` and `NET_RAW` additions are redundant
in privileged mode and have been omitted.

The read-only `/run/dbus` mount supports Bluetooth integrations. Verify that
host D-Bus is available; remove the mount if Bluetooth is not used and the host
has no D-Bus socket. `/etc/localtime` is also mounted read-only, with `TZ` set to
`Europe/Rome`. For USB integrations, use stable `/dev/serial/by-id` paths when
configuring devices and follow the installation guide's device mapping advice.

## Start and update

Before adopting this version with existing data, read the
[2026.10 release notes](https://www.home-assistant.io/blog/2026/10/07/release-202610/)
and [2026.10.2 changes](https://github.com/home-assistant/core/releases/tag/2026.10.2),
including breaking changes affecting your integrations. For older installations,
review intervening release notes and use intermediate versions when required.
Stop the old instance and take a complete configuration backup first. Reverting
the image alone does not reverse configuration or database migrations; restore
the matching backup if rolling back.

From the `homeassistant` directory, run each command only if the previous succeeds:

```sh
docker compose config --quiet
docker compose pull
docker compose up -d
docker compose ps
```

Open `http://<homelab-ip>:8123`. Complete onboarding for a fresh installation;
for an existing one, verify dashboards, integrations, automations, and device
discovery. Check `docker compose logs homeassistant` privately if needed.
Keep access restricted to trusted LAN/tailnet clients and enable account
security. If proxying through Nginx Proxy Manager, configure Home Assistant's
[reverse proxy settings](https://www.home-assistant.io/integrations/http/#reverse-proxies)
with only the actual proxy source address as trusted; never trust every address.

For later updates, back up configuration, review release notes, and run
`git pull --ff-only` on the deployment branch (`main` for normal deployments)
before repeating the commands above. Renovate proposes image and digest updates;
merging a PR does not deploy the container.
