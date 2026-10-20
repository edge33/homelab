# Samba

## Local configuration

For initial setup, copy the tracked example to a local environment file. If
`.env` already exists, edit it instead of copying. From the repository root:

```sh
cd samba
cp .env.example .env
chmod 600 .env
```

Edit `.env` with your host share path and credentials:

```dotenv
SAMBA_SHARE_PATH=/srv/shares/downloads
SAMBA_USER=your-username
SAMBA_PASSWORD='replace-with-a-new-strong-password'
```

Create the host share directory before starting Samba. Use an absolute path
outside the Git checkout. File ownership uses user/group ID `1000`, configured
in `docker-compose.yml`. The SMB share is named `drive-name`. Images, ports,
and other service settings are defined directly in the Compose file.

The real `.env` is ignored by Git. The tracked `.env.example` contains only
placeholder values and serves as the configuration reference for fresh clones.
Single quotes preserve literal `$` and `#` characters in `.env`. Avoid semicolons
and double quotes in Samba credentials because they act as command delimiters.
Never use the placeholder password as a real password or share the output of
`docker compose config`, which contains resolved credentials.

## Start and update manually

From the `samba` directory, validate the configuration and start the service:

```sh
docker compose config --quiet
docker compose pull
docker compose up -d
docker compose ps
```

After pushing repository changes, run the following on the homelab from the
`samba` directory. Run each command only if the preceding command succeeds:

```sh
git pull --ff-only
docker compose config --quiet
docker compose pull
docker compose up -d
docker compose ps
```

Keep the checkout on `main` for normal deployments. To test a PR, check out its
branch and configure its upstream first. Pulls follow the current branch's
upstream. The `latest` image tag can change independently of Git; edit the
Compose image tag if you want to pin a particular release.

Samba's internal configuration and state live in Docker named volumes. Keep
their names unchanged across updates, and do not use `docker compose down -v`
unless you intend to delete that state. Ordinary updates use `up -d` without
stopping the stack first.

With the share outside the checkout and internal state in named volumes,
runtime data stays separate from Git. Ignored files do not normally interfere
with pulls, but future commits must not track their paths. `.gitignore` does
not protect files already tracked by Git. Back up the share, named volumes,
and local credentials separately; reverting Git does not restore data.

The repository history was replaced to remove an old sample credential. Use a
fresh clone if your existing clone has the old history, and replace any password
reused from that history.
