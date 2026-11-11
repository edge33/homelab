# aMule

```sh
cd amule
cp .env.example .env
chmod 600 .env
mkdir -p amule /home/edge33/downloads/amule/downloads /home/edge33/downloads/amule/temp
```

If `.env` exists, edit it instead of copying. Set `AMULE_GUI_PASSWORD` for
External Connections and `AMULE_WEB_PASSWORD` for the browser UI. Set
`AMULE_DOWNLOADS_PATH` and `AMULE_TEMP_PATH` to dedicated absolute host paths.
Ensure UID/GID `1000:1000` can write to both paths and `./amule`; adjust
`PUID`/`PGID` in Compose if needed.

[Start the stack](../README.md). Web UI: `http://<homelab-ip>:4711`.

See [updates](../README.md#updates) and the
[upstream setup and upgrade instructions](https://github.com/ngosang/docker-amule).
