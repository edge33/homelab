# AI Run Coach

Requires an x86-64 Linux Docker host and access to GitHub Container Registry.

```sh
cd ai-run-coach
cp .env.example .env
chmod 600 .env
mkdir -p data
sudo chown -R 1000:1000 data
```

If `.env` exists, edit it instead of copying. Set `GARMIN_API_KEY` for Garmin
imports and `ATHLETE_TIMEZONE` for your timezone. For LAN access, set `BIND_IP`
to the host's LAN address and `APP_ORIGINS` to the exact browser-facing origin
(for example, `http://192.168.1.10:8082`). For a reverse proxy, use its public
origin in `APP_ORIGINS`.

```sh
docker compose pull
docker compose up -d --no-build --wait
```

Web UI: `http://<bind-address>:8082`. MCP endpoint: the same origin at `/mcp`.
SQLite and athlete-wiki data persist in `./data`, owned by UID/GID 1000:1000.
The image initializes the database and includes a web/API/MCP health check.

See the [upstream deployment guide](https://github.com/edge33/ai-run-coach/blob/main/docs/storage.md)
for application configuration and reverse-proxy settings.
See [shared update instructions](../README.md#updates); back up `./data` before
upgrading.
