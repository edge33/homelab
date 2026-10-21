# Nginx Proxy Manager

Uses `jc21/nginx-proxy-manager:2.16.0` with the built-in SQLite database,
following the [official setup](https://nginxproxymanager.com/setup/).

## Local configuration

From the repository root:

```sh
cd nginx-proxy-manager
cp .env.example .env
chmod 600 .env
```

If `.env` already exists, edit it instead of copying. Set absolute host paths
for `NPM_DATA_PATH` and `NPM_LETSENCRYPT_PATH`. Create both directories on the
host before starting; use `sudo` if needed. For the example paths:

```sh
sudo mkdir -p /srv/homelab/nginx-proxy-manager/data
sudo mkdir -p /srv/homelab/nginx-proxy-manager/letsencrypt
```

When adopting an existing installation, point the variables to its existing
`data` and `letsencrypt` directories, including the old directories beside
the Compose file if used. Stop the old container and back up both directories
before upgrading. Do not run two instances against the same data. The database,
proxy settings, and certificates must be preserved together; empty directories
start a fresh installation.

The real `.env` is ignored by Git. Keep runtime data outside the checkout and
back it up separately; certificates and application state can contain secrets.

## Start and update

From the `nginx-proxy-manager` directory, run each command only if the previous
one succeeds:

```sh
docker compose config --quiet
docker compose pull
docker compose up -d
docker compose ps
```

Allow a couple of minutes for initialization, then open
`http://<homelab-ip>:81` to configure the administrator account and proxy hosts.
Check startup with `docker compose logs npm` if needed; keep logs private.

The host must have TCP ports `80`, `443`, and `81` available. HTTP and HTTPS
proxy traffic uses `80` and `443`; keep admin port `81` restricted to your
trusted network. For public access, point your domain's DNS at your public IP
and forward only the required HTTP/HTTPS ports from the router to this host.
Other Compose stacks are on separate networks, so use the homelab's reachable
LAN address and a service's published port as the upstream, rather than
`localhost` or a container name from another stack.

If the host has no IPv6 support and Nginx reports an IPv6 startup error, add
`DISABLE_IPV6: "true"` to the service environment as described in the setup docs.

For later updates, run `git pull --ff-only` on the deployment branch before
the commands above. Use `main` for normal deployments. Check the
[upstream upgrade notes](https://nginxproxymanager.com/upgrading/) and back up
both state directories first because upgrades can migrate the database.
Reverting the image alone does not restore the database.

Renovate discovers this Compose file automatically and proposes image updates
through pull requests. Merging a PR does not deploy the stack.
