# Jellyfin

```sh
cd jellyfin
cp .env.example .env
chmod 600 .env
mkdir -p config cache
```

If `.env` exists, edit it instead of copying. Set `JELLYFIN_MEDIA_PATH` to an
existing absolute media directory. State mounts use `./config` and `./cache`.

The host needs port `8096` available and `/dev/dri`. Check the configured `i965`
driver against the [upstream Intel GPU guide](https://jellyfin.org/docs/general/post-install/transcoding/hardware-acceleration/intel/).
For software-only operation, remove the driver override and device mapping.

[Start the stack](../README.md). Web UI: `http://<homelab-ip>:8096`.

For application setup, see the
[upstream container guide](https://jellyfin.org/docs/general/installation/container/).
See [shared update instructions](../README.md#updates).
