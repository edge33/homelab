# qBittorrent

```sh
cd qbittorrent
cp .env.example .env
chmod 600 .env
```

If `.env` exists, edit it instead of copying. Set `QBITTORRENT_CONFIG_PATH` and
`QBITTORRENT_DOWNLOADS_PATH` to absolute host directories and create them.
Ensure UID/GID `1000:1000` can write to both paths; adjust `PUID`/`PGID` in
Compose if needed.

[Start the stack](../README.md). Web UI: `http://<homelab-ip>:8080`.
Peer traffic uses `6881/TCP` and `6881/UDP`.

See [updates](../README.md#updates) and the
[upstream container guide](https://docs.linuxserver.io/images/docker-qbittorrent/).
