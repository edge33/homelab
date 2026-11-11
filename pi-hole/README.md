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
Open `http://<homelab-ip>:8081/admin/` and sign in with `PIHOLE_WEB_PASSWORD`.
HTTPS is available on `8443` with a self-signed certificate.

Test DNS from another LAN machine before setting the router's DNS server to
the homelab IP (replace the example address):

```sh
dig @192.168.1.10 example.com
dig +tcp @192.168.1.10 example.com
```

See [updates](../README.md#updates) and
[upstream configuration](https://docs.pi-hole.net/docker/).
