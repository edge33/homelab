# Jellyfin

```sh
cd jellyfin
cp .env.example .env
chmod 600 .env
mkdir -p config cache
```

If `.env` exists, edit it instead of copying. Set `JELLYFIN_MEDIA_PATH` to an
existing absolute media directory. Reuse existing state in `./config` and
`./cache` with permissions preserved while the old server is stopped.

The host needs port `8096` available and `/dev/dri`. The configured `i965` driver
is for legacy Intel GPUs; adjust it for your hardware, or remove both the driver
override and device mapping for software-only playback.

[Start the stack](../README.md). Open `http://<homelab-ip>:8096`, create an
administrator, and add libraries under `/media`. For hardware transcoding,
configure VA-API and the render device under Dashboard → Playback → Transcoding.

Before upgrading existing data, check the
[upstream migration requirements](https://jellyfin.org/docs/general/installation/container/).
See [shared update instructions](../README.md#updates).
