# Samba

From this directory:

```sh
cp .env.example .env
# Edit .env with your share path, username, and a new strong password.
docker compose config --quiet
docker compose up -d
```

Create the host share directory first. File ownership uses user/group ID `1000`,
configured in `docker-compose.yml`. The SMB share is named `drive-name`.
Images, ports, and other service settings are defined in the Compose file.

Keep `.env` local. Never use a sample password as a real password. Single quotes
preserve literal `$` and `#` characters in `.env`; avoid semicolons and double
quotes in Samba credentials because they act as command delimiters.
Do not share the output of `docker compose config`, which contains credentials.

Samba stores its internal configuration and state in Docker named volumes.
Keep those volume names unchanged to retain state across container updates.

## Pull and apply on the homelab

Keep credentials and shared files outside the checkout. From the repository
root, create a local environment file once:

```sh
mkdir -p "$HOME/.config/homelab"
chmod 700 "$HOME/.config/homelab"
cp samba/.env.example "$HOME/.config/homelab/samba.env"
chmod 600 "$HOME/.config/homelab/samba.env"
# Edit samba.env with your username, password, and an existing absolute share path.
# For example: SAMBA_SHARE_PATH=/srv/shares/downloads
```

After pushing changes to GitHub, apply them on the homelab:

```sh
./samba/deploy.sh "$HOME/.config/homelab/samba.env"
```

The script pulls the checked-out branch with `git pull --ff-only`, validates
Compose without printing resolved credentials, pulls the image, and runs
`up -d`. It stops on failure and uses the fixed Compose project name `samba`.
It needs Git remote access and permission to use Docker. Without an argument,
it uses `samba/.env` for compatibility with the setup above.

Keep the homelab checkout on `main` for normal deployments. To test a PR,
check out its branch and set its upstream before running the script. The script
follows that branch's upstream; it does not switch branches or merge divergent
history. It does not stop the stack first or delete persistent volumes.
The `latest` image tag can change independently of Git; edit the Compose image
tag if you want to pin a particular release.

With an external share path and Docker named volumes, Samba's runtime data
stays outside the checkout. Ignored local files do not normally interfere with
pulls, but future commits must not track their paths. `.gitignore` does not
protect files already tracked by Git. Back up the share, named volumes, and
local credentials separately; reverting Git does not restore application data.

The repository history was replaced to remove an old sample credential. Use a
fresh clone if your existing clone has the old history. Replace any password
reused from that history; rewriting Git history does not retract existing copies.
