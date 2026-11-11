# Tailscale gateway

Requires Linux, `/dev/net/tun`, nftables, and no other Tailscale daemon on the host.
Enable host IP forwarding as described in the
[upstream subnet router guide](https://tailscale.com/docs/features/subnet-routers).

```sh
cd tailscale
cp .env.example .env
chmod 600 .env
mkdir -p tailscale-state
chmod 700 tailscale-state
```

If `.env` exists, edit it instead of copying. Set `TS_ROUTES` to the actual
LAN CIDRs reachable from this host. Set `TS_AUTHKEY` for first enrollment as
described in the [upstream Docker parameters](https://tailscale.com/docs/features/containers/docker/docker-params).
Persistent node state uses `./tailscale-state`.

[Start the stack](../README.md).

For route approvals and client configuration, follow the
[subnet router](https://tailscale.com/docs/features/subnet-routers) and
[exit-node](https://tailscale.com/docs/features/exit-nodes) guides.
See [shared update instructions](../README.md#updates).
