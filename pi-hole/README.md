# Pi-hole

## Local configuration

From the repository root:

```sh
cd pi-hole
cp .env.example .env
chmod 600 .env
```

If `.env` already exists, edit it instead of copying. Set these values locally:

```dotenv
PIHOLE_CONFIG_PATH=/srv/homelab/pihole/config
PIHOLE_WEB_PASSWORD='replace-with-a-new-strong-password'
```

Create the host configuration directory first (using `sudo` if needed). For
the example path:

```sh
sudo mkdir -p /srv/homelab/pihole/config
```

When adopting an existing installation, set `PIHOLE_CONFIG_PATH` to its current
data directory so Pi-hole retains its configuration and databases. Use an
absolute path outside the checkout. Back up that directory before upgrading.

The real `.env` is ignored by Git; `.env.example` is tracked and contains only
placeholders. Single quotes preserve literal `$` and `#` characters in passwords.
Do not share the output of `docker compose config`, which includes credentials.

## Start and test

From the `pi-hole` directory, run each command only if the previous one succeeds:

```sh
docker compose config --quiet
docker compose pull
docker compose up -d
docker compose ps
```

The host must have TCP and UDP port `53` available. The admin interface is at
`http://<homelab-ip>:8081/admin/` or `https://<homelab-ip>:8443/admin/` (the default
certificate is self-signed). Log in using `PIHOLE_WEB_PASSWORD`.

Test DNS from another LAN machine before changing the router's DNS settings:

```sh
# Replace 192.168.1.10 with the homelab machine's LAN address.
dig @192.168.1.10 example.com
dig +tcp @192.168.1.10 example.com
```

This stack uses bridge networking with DNS listening mode `ALL`, publishes DNS
and web ports, and does not configure DHCP or host time synchronization.
Keep these ports accessible only to your trusted network. See the
[Pi-hole Docker documentation](https://docs.pi-hole.net/docker/) for application
configuration details.

## Update manually

From the `pi-hole` directory:

```sh
git pull --ff-only
docker compose config --quiet
docker compose pull
docker compose up -d
docker compose ps
```

Run each command only if the previous one succeeds. Pulls follow the current
branch's upstream; use `main` for normal deployments or the PR branch for
testing. No deployment script is required.

Image, ports, timezone, and restart policy are hardcoded in the Compose file.
Renovate proposes image version and digest updates through pull requests; see
the [repository update instructions](../README.md#automated-image-updates).
The host configuration directory persists when containers are recreated. With
that directory outside the checkout, Git pulls cannot change its contents.
Do not commit runtime files or credentials; back them up separately from Git.
