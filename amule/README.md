# aMule

Uses `ngosang/amule:3.1.0-1`, following the
[upstream container setup](https://github.com/ngosang/docker-amule).

## Local configuration

From the repository root:

```sh
cd amule
cp .env.example .env
chmod 600 .env
mkdir -p amule /home/edge33/amule/downloads /home/edge33/amule/temp
```

If `.env` already exists, edit it instead of copying. Set two strong passwords:
`AMULE_GUI_PASSWORD` is for External Connections (amulegui/amulecmd and the
internal Web UI backend); `AMULE_WEB_PASSWORD` logs into the browser Web UI.
The Compose file requires both rather than using the old `amule` defaults.
Use single quotes around `.env` values containing literal `$` or `#` characters.

Set `AMULE_DOWNLOADS_PATH=/home/edge33/amule/downloads` and
`AMULE_TEMP_PATH=/home/edge33/amule/temp` in `.env`, including when updating an
existing installation. Ensure UID/GID `1000:1000` can write to the local `amule`
configuration directory and both host data directories.
If your host user has different IDs, update `PUID`/`PGID` to match `id <username>`.
The image may adjust ownership in incoming/temp directories during startup;
use paths dedicated to this service.

Configuration uses the local bind mount `./amule:/home/amule/.aMule` relative
to the Compose file, and is ignored by Git along with `.env`. Completed files
use `/downloads` inside the container; incomplete files use a separate `/temp`
bind mount, outside the configuration directory. If the two host data locations
are on different filesystems, completing downloads requires copying rather than
a rename. Back up configuration and incomplete downloads securely.

For an existing installation:

1. Stop the old container and back up configuration and download data.
2. Keep the existing configuration in `amule` beside this Compose file. If
   migrating from another installation, copy its `.aMule` directory there,
   preserving ownership and permissions.
3. Move the contents of the old completed-download directory (previously
   `/home/edge33/downloads/amule`) into `/home/edge33/amule/downloads`.
4. Move the contents of the configuration directory's `temp` subdirectory into
   `/home/edge33/amule/temp`, preserving ownership and permissions. Remove the
   empty old `temp` directory after verifying the move.
5. Update both path variables in `.env` before starting the container. Verify
   that existing incomplete downloads resume and completed files are visible.

Do not run two instances against the same data or start with empty configuration.
Keep using the same checkout so the relative configuration mount continues to
find its state.

## Upgrade to 3.1.0

Read the [release notes](https://github.com/ngosang/docker-amule/releases/tag/3.1.0-1)
and upstream README's upgrade section before adopting older configuration.
This version replaces the legacy amuleweb UI with amuleapi on port `4711`.
The old Web UI password is not migrated. Supply both passwords in `.env` and
update amulegui/amulecmd clients to use `AMULE_GUI_PASSWORD` for port `4712`.
Stop the container before manually editing `amule.conf`, since shutdown writes
its in-memory configuration back to disk. A rollback needs the matching state
backup as well as the old image.

## Start and verify

From the `amule` directory, run each command only if the previous succeeds:

```sh
docker compose config --quiet
docker compose pull
docker compose up -d
docker compose ps
```

Open `http://<homelab-ip>:4711` and log in with `AMULE_WEB_PASSWORD` (no username).
Verify existing settings, completed files, and incomplete downloads. Startup
scans shared directories and the UI may take time to become available. Check
`docker compose logs amule` privately: logs can contain passwords. Use
`docker compose config --quiet` rather than sharing rendered configuration,
which contains expanded credentials.

Keep management ports `4711` and `4712` restricted to trusted LAN/tailnet clients.
Do not forward them from the router. The Web UI is plain HTTP; use a trusted
network or a TLS reverse proxy. For inbound peer connectivity, forward only
`4662/TCP`, `4665/UDP`, and `4672/UDP` to this host as needed, and allow them in
the host firewall. Preserve matching ports in existing aMule configuration.
This stack uses bridge networking with explicit ports; automatic UPnP through
host networking is not enabled.

## Updates

Back up configuration and incomplete downloads, review upstream release notes,
and run `git pull --ff-only` on the deployment branch (`main` for normal
deployments) before repeating the commands above. Renovate proposes image and
digest updates; merging a PR does not deploy the container.
