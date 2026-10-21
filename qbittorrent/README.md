# qBittorrent

This stack uses `lscr.io/linuxserver/qbittorrent:5.2.0`, based on the
[LinuxServer Compose example](https://docs.linuxserver.io/images/docker-qbittorrent/#docker-compose-recommended-click-here-for-more-info).

## Local configuration

From the repository root:

```sh
cd qbittorrent
cp .env.example .env
chmod 600 .env
```

If `.env` already exists, edit it instead of copying. Set absolute host paths
for configuration and downloads. The example keeps the stashed download path
`/home/edge33/downloads`; change it to match your host. To share downloads over
Samba, point `QBITTORRENT_DOWNLOADS_PATH` at the same directory as Samba's
`SAMBA_SHARE_PATH`.

For an existing installation, point `QBITTORRENT_CONFIG_PATH` at its existing
configuration directory, including the old `qbittorrent/config` directory if
that is where the state lives. Keep the container download path `/downloads`
unchanged so saved torrents still find their files. Stop the old container and
back up its configuration before upgrading; do not run two instances against
the same configuration directory.

For a fresh installation, create the configured directories on the host first.
Ensure UID/GID `1000:1000` can write to both paths. If your host user has different
IDs, update `PUID` and `PGID` in the Compose file to match `id <username>`.
The real `.env` is ignored by Git; runtime state should stay outside the checkout.

## Start and update

From the `qbittorrent` directory, run each command only if the previous one
succeeds:

```sh
docker compose config --quiet
docker compose pull
docker compose up -d
docker compose ps
```

Open `http://<homelab-ip>:8080`. For a fresh configuration, log in as `admin`
using the temporary password from `docker compose logs qbittorrent`, then set
your own credentials in the Web UI. Logs can contain the temporary password;
keep them private.

Port `8080` serves the Web UI; `6881` is published for both TCP and UDP torrent
traffic. If changing a port, update the matching environment value and both
sides of its port mapping together. Keep the Web UI on your trusted network.

For later updates, pull the deployment branch with `git pull --ff-only` before
running the commands above. Use `main` for normal deployments. Renovate detects
this Compose file automatically and proposes image and digest updates through
pull requests; merging them does not deploy the stack.

## Troubleshooting a 5.2.0 upgrade

LinuxServer tracks a [5.2.0 startup issue involving a stale lockfile](https://github.com/linuxserver/docker-qbittorrent/issues/432).
If startup stalls after an upgrade, stop the container and confirm no other
qBittorrent process uses that configuration. Back up the configuration, then
remove only the stale `.config/qBittorrent/lockfile` under your configured host
configuration directory and start the service again. Do not delete the rest of
the configuration or torrent state.
