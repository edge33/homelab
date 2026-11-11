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

Dashboard: `http://<homelab-ip>:9119`. Browser chat (when enabled):
`http://<homelab-ip>:9120`. `HERMES_BIND_IP` controls the host bind address.
Store `./data` on local disk.

For app configuration, see the
[upstream dashboard guide](https://hermes-agent.nousresearch.com/docs/user-guide/features/web-dashboard)
and [Webapp setup](https://hermes-agent.nousresearch.com/docs/user-guide/docker#running-the-webapp).
See [shared update instructions](../README.md#updates).
