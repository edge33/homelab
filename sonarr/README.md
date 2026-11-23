# Sonarr

```sh
cd sonarr
cp .env.example .env
chmod 600 .env
mkdir -p config
```

If `.env` exists, edit it instead of copying. Set `SONARR_DATA_PATH` to an
absolute host directory containing downloads and the TV library. When using
qBittorrent, match its `QBITTORRENT_DOWNLOADS_PATH`; both containers see this
directory at `/downloads`. With the example paths, a TV library at
`/downloads/media/tv` is visible to Jellyfin at `/media/tv`.
Create the host library directory and ensure UID/GID `1000:1000` can write to
it, the downloads directory, and `./config`; adjust `PUID`/`PGID` in Compose if
needed. The host needs port `8989` available.

[Start the stack](../README.md). Web UI: `http://<homelab-ip>:8989`.

See the [upstream container guide](https://docs.linuxserver.io/images/docker-sonarr/)
and [Sonarr documentation](https://wiki.servarr.com/sonarr) for application setup.
See [shared update instructions](../README.md#updates).
