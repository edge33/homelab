# Hermes Agent

Runs the official stable image with a password-protected dashboard and persistent
state in `./data`, following the [upstream Docker guidance](https://hermes-agent.nousresearch.com/docs/user-guide/docker).
Telegram uses outbound long polling. No public hostname, inbound Telegram port,
OpenAI API key, Docker socket, or host networking is required for this setup.

## Local configuration

From the repository root:

```sh
cd hermes
cp .env.example .env
chmod 600 .env
mkdir -p data
chmod 700 data
id -u
id -g
```

If `.env` already exists, edit it instead of overwriting it. Set `HERMES_UID`
and `HERMES_GID` to the IDs printed above. Generate two separate values using
`openssl rand -hex 32` and put them in the password and session-secret fields.
Keep these values private. `.env` and the entire data directory are ignored by Git.

`HERMES_BIND_IP=0.0.0.0` listens on all host IPv4 interfaces, allowing LAN
clients to use `http://<homelab-lan-ip>:9119` without embedding a machine-specific
address in the configuration. Restrict port 9119 to trusted LAN clients using
host/network firewall rules; this bind address itself does not enforce LAN-only
access. Do not forward this port from the router. Sign in with the dashboard
credentials from `.env`. Use `127.0.0.1` instead for local-only testing, or a
specific host LAN address to bind only that interface.

Before the first gateway start, run each command only if the previous succeeds:

```sh
docker compose config --quiet
docker compose pull
docker compose run --rm -e HERMES_DASHBOARD=0 hermes setup
```

Choose **ChatGPT or Codex Subscription** for inference and complete the displayed
device-code login in your browser. You may need to enable device-code login in
ChatGPT security settings. No OpenAI API key is needed. Hermes does not document
exact subscription-tier eligibility or quota accounting; verify your account
with a real response. See [provider guidance](https://hermes-agent.nousresearch.com/docs/integrations/providers).

For Telegram, create a bot through [@BotFather](https://t.me/BotFather) and configure
its token plus your numeric user ID in the setup wizard. Restrict allowed users
to your own ID. Alternatively, after starting the dashboard, use its
**Messaging → Telegram → Create with QR** flow to create and pair the bot.
Keep Telegram tokens in Hermes' `data/.env`, not in Git. See the
[Telegram guide](https://hermes-agent.nousresearch.com/docs/user-guide/messaging/telegram).

## Start and test

```sh
docker compose up -d
docker compose ps
docker compose exec hermes hermes status --full
```

Confirm that the dashboard redirects unsigned visitors to login, then sign in.
Send a private Telegram message and confirm an actual model response. Restart
with `docker compose restart` and repeat to verify state and login persistence.
Check `docker compose logs --tail 100 hermes` privately if startup fails.

If the gateway was started before provider setup, configure its model with
`docker compose exec hermes hermes model`, then restart the service. The stack
limits usage to 4 GB RAM and two CPUs, including 1 GB shared memory for browser
tools. The image manages its own supervisor; keep its entrypoint unchanged.

## Move to the homelab

All application state, including subscription login, Telegram credentials,
sessions, skills, and memory, lives in `data`. Dashboard credentials live in
the adjacent `.env`. Transfer both, along with this stack's tracked files.

1. Stop this instance with `docker compose down`. Keep it stopped after moving;
   only one instance should use this Telegram bot or copied auth state.
2. Pull the stack's Git changes on the homelab, then copy the private `.env` and
   `data` directory over SSH. From this repository root, replace the destination
   and run `rsync -a hermes/.env hermes/data user@homelab:/path/to/homelab/hermes/`.
   Ensure the destination has no running Hermes instance or existing state
   before copying. Preserve private permissions; the archive contains credentials.
3. On the homelab, keep `HERMES_BIND_IP=0.0.0.0` for LAN access and set UID/GID
   in `.env` to its deployment user. If IDs differ, have the host administrator
   adjust ownership of `data` to that user before starting.
4. Run `docker compose config --quiet`, `docker compose pull`, and
   `docker compose up -d` in the destination directory. Do not rerun initial
   setup over the transferred configuration.
5. Repeat dashboard, Telegram, and restart checks. If subscription sign-in no
   longer works, run `docker compose exec hermes hermes model` to reauthenticate.

Pull the image on the destination rather than copying a running container. The
pinned multi-platform image supports amd64 and arm64. Any optional native tools
installed into persistent state may need reinstalling when changing architecture.
Use the same image digest for the move, and upgrade separately afterward.

## Backups and updates

Back up `data` and `.env` together while the stack is stopped, using a protected
destination. Keep `data` on native local disk because its SQLite database uses
WAL; do not place it on Samba/NFS storage. Never run two gateways against the same
data directory. Keep using the same deployment checkout to retain relative mounts.

For updates, back up first, run `git pull --ff-only` on the deployment branch
(`main` normally), then `docker compose pull` and `docker compose up -d`.
Renovate proposes image updates; merging does not deploy them. Image upgrades
can migrate configuration and state, so rollback may require restoring the backup.
