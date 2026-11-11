# Hermes Agent

```sh
cd hermes
cp .env.example .env
chmod 600 .env
mkdir -p data
chmod 700 data
id -u
id -g
```

If `.env` exists, edit it instead of copying. Set `HERMES_UID`/`HERMES_GID` to
your host IDs. Set the dashboard username and generate separate password and
session-secret values with `openssl rand -hex 32`.

```sh
docker compose up -d
```

Open `http://<homelab-ip>:9119` and sign in with the dashboard credentials from
`.env`. Configure your provider credentials and model in the dashboard. For
Telegram, configure the bot token and restrict allowed users to your own numeric
ID under **Channels**. Start or restart the gateway from the dashboard after
saving the configuration.

Browser chat uses `http://<homelab-ip>:9120` and the same credentials. Enable it
in persistent Hermes configuration using the
[upstream Webapp instructions](https://hermes-agent.nousresearch.com/docs/user-guide/docker#running-the-webapp),
with the container listener on `0.0.0.0:9120`; publishing the port alone does not
enable it. `HERMES_BIND_IP` controls host access to both ports; use `127.0.0.1`
for local-only access.

Keep `.env` and `data` together when backing up or moving hosts. Use local disk
for `data`, and stop the old instance before starting a transferred copy.
See [shared update instructions](../README.md#updates).
