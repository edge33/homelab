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

Reuse existing configuration in `./amule` and move any old incomplete downloads
to `AMULE_TEMP_PATH` while the old instance is stopped.

[Start the stack](../README.md). Open `http://<homelab-ip>:4711` and sign in with
`AMULE_WEB_PASSWORD` (no username). Keep ports `4711`/`4712` private. For inbound
peers, allow/forward `4662/TCP`, `4665/UDP`, and `4672/UDP` as needed.

See [updates](../README.md#updates) and the
[upstream setup and upgrade instructions](https://github.com/ngosang/docker-amule).
