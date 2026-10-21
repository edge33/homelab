# Jellyfin

Uses `jellyfin/jellyfin:12.2` with host networking and Intel GPU passthrough,
following the [official container guide](https://jellyfin.org/docs/general/installation/container/).

## Local configuration

On the Linux homelab host, from the repository root:

```sh
cd jellyfin
cp .env.example .env
chmod 600 .env
mkdir -p config cache
```

If `.env` exists, edit it instead of copying. Set `JELLYFIN_MEDIA_PATH` to your
absolute media directory; the example preserves `/home/edge33/downloads/media`.
Create that directory if needed. The container keeps the same `/media` path
so existing library paths continue to work. Media is writable, matching the
existing setup; append `:ro` to the mount if library-side writes are unwanted.

Configuration and cache use local bind mounts `./config` and `./cache`, relative
to this Compose file. Both directories and `.env` are ignored by Git. Keep the
same deployment checkout. When adopting an existing installation, stop its
container, back up configuration, and copy existing config/cache into these
directories preserving ownership and permissions. Do not start with empty
configuration or run two servers against the same data. Preserve the current
runtime user; no new user override or bulk ownership change is needed.

## GPU and networking

The host needs `/dev/dri`. This setup preserves `LIBVA_DRIVER_NAME=i965` from
the existing configuration for legacy Intel VA-API hardware. Confirm the driver
matches your GPU using the [Intel acceleration guide](https://jellyfin.org/docs/general/post-install/transcoding/hardware-acceleration/intel/).
Newer Intel GPUs generally use `iHD`; change or remove the override for those.
For software-only playback, remove both the driver override and device mapping.

In Dashboard > Playback > Transcoding, select VA-API and the correct render
device (commonly `/dev/dri/renderD128`) for the legacy GPU. Enable only supported
codecs, then verify a transcoding playback session and its logs. To inspect the
driver after startup:

```sh
docker compose exec jellyfin /usr/lib/jellyfin-ffmpeg/vainfo --display drm --device /dev/dri/renderD128
```

Host networking preserves local discovery and uses the host's ports directly;
no Compose port mappings are needed. Port `8096` must be available. Restrict
access to the trusted LAN or tailnet and keep application authentication enabled.

## Existing installation upgrade

Read the [12.0 migration requirements](https://jellyfin.org/posts/jellyfin-release-12.0/)
and [12.2 release notes](https://github.com/jellyfin/jellyfin/releases/tag/v12.2)
before starting this image against existing data. For a pre-12 installation,
first reach 10.10.7 or a 10.11.x release, remove incompatible third-party plugins,
and resolve usernames that differ only by capitalization. Stop the old server
and take a full backup before migration. Run a full library scan afterward and
allow migration and scanning to finish. Restoring a previous image alone does
not undo database changes; rollback also requires the matching state backup.

## Start and update

From the `jellyfin` directory, run each command only if the previous succeeds:

```sh
docker compose config --quiet
docker compose pull
docker compose up -d
docker compose ps
```

Open `http://<homelab-ip>:8096`. Complete the setup wizard for a fresh install,
create an administrator, and add libraries under `/media`. For migrated data,
verify existing users, libraries, playback, and hardware transcoding. Check
`docker compose logs jellyfin` privately if startup fails.

For later updates, back up configuration, check upstream migration notes, and
run `git pull --ff-only` on the deployment branch (`main` for normal deployments)
before repeating these commands. Renovate proposes image and digest updates;
merging a PR does not deploy the container.
