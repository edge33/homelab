# Radarr

```sh
cd radarr
cp .env.example .env
chmod 600 .env
mkdir -p config
```

If `.env` exists, edit it instead of copying. Set `RADARR_DATA_PATH` to an
absolute host directory containing downloads and the movie library. When using
qBittorrent, match its `QBITTORRENT_DOWNLOADS_PATH`; both containers see this
directory at `/downloads`. With the example paths, a movie library at
`/downloads/media/movies` is visible to Jellyfin at `/media/movies`.
Create the host library directory and ensure UID/GID `1000:1000` can write to
it, the downloads directory, and `./config`; adjust `PUID`/`PGID` in Compose if
needed. The host needs port `7878` available.

[Start the stack](../README.md). Web UI: `http://<homelab-ip>:7878`.

See the [upstream container guide](https://docs.linuxserver.io/images/docker-radarr/)
and [Radarr documentation](https://wiki.servarr.com/radarr) for application setup.
See [shared update instructions](../README.md#updates).
