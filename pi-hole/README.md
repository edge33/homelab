# Pi-hole

```sh
cd pi-hole
cp .env.example .env
chmod 600 .env
```

If `.env` exists, edit it instead of copying. Set `PIHOLE_CONFIG_PATH` to an
absolute host directory (reuse existing state) and `PIHOLE_WEB_PASSWORD` to a
strong password. Create the configured directory before starting.

[Start the stack](../README.md). Host TCP/UDP port `53` must be available.
Admin UI: `http://<homelab-ip>:8081/admin/` or
`https://<homelab-ip>:8443/admin/`.

See [updates](../README.md#updates) and
[upstream configuration](https://docs.pi-hole.net/docker/).
