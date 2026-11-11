# Tailscale gateway

Requires Linux, `/dev/net/tun`, nftables, and no other Tailscale daemon on the host.
Enable forwarding in `/etc/sysctl.d/99-tailscale.conf`:

```ini
net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding = 1
```

Apply with `sudo sysctl -p /etc/sysctl.d/99-tailscale.conf`.

```sh
cd tailscale
cp .env.example .env
chmod 600 .env
mkdir -p tailscale-state
chmod 700 tailscale-state
```

If `.env` exists, edit it instead of copying. Set `TS_ROUTES` to the actual
LAN CIDRs reachable from this host. For first enrollment, set `TS_AUTHKEY` to a
non-ephemeral, single-use key from the
[admin console](https://login.tailscale.com/admin/settings/keys).
Reuse existing node state in `./tailscale-state` while the old instance is stopped.

[Start the stack](../README.md), then verify:

```sh
docker compose exec tailscale tailscale status
docker compose exec tailscale tailscale ip -4
```

After enrollment, clear `TS_AUTHKEY` and run `docker compose up -d` again.
Approve the device, subnet routes, and exit-node use in the admin console;
allow intended traffic in tailnet policy and the host firewall.

On remote clients, enable subnet-route acceptance and select this gateway as
an exit node when needed. No router port forwarding is required.
See [updates](../README.md#updates) and the
[upstream Docker parameters](https://tailscale.com/docs/features/containers/docker/docker-params).
