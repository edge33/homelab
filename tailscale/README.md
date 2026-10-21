# Tailscale gateway

Uses `tailscale/tailscale:v1.104.1`, based on the gateway configuration recovered
from the repository stash. It preserves host networking, nftables mode, the
`tailscale-gateway` container name, subnet routes, and exit-node advertisement.
See the official [Docker parameters](https://tailscale.com/docs/features/containers/docker/docker-params),
[subnet router guide](https://tailscale.com/docs/features/subnet-routers), and
[exit-node guide](https://tailscale.com/docs/features/exit-nodes).

## Host requirements

Use Linux Docker Engine with `/dev/net/tun` available and nftables support.
Do not run another Tailscale daemon on the same host. `NET_ADMIN` lets this
container manage the host's interface, routes, and firewall. The old
`SYS_MODULE` capability is omitted: load TUN on the host if needed with
`sudo modprobe tun`, rather than allowing the container to load kernel modules.

Enable host IP forwarding. Add these entries to
`/etc/sysctl.d/99-tailscale.conf`, preserving any existing settings:

```ini
net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding = 1
```

Apply with `sudo sysctl -p /etc/sysctl.d/99-tailscale.conf` and verify with
`sysctl net.ipv4.ip_forward net.ipv6.conf.all.forwarding`. Both must return `1`.
Configure this on the host, not Compose `sysctls`, with host networking.
Keep firewall forwarding restricted to intended traffic. If Docker blocks
routing, follow its [firewall guidance](https://docs.docker.com/engine/network/packet-filtering-firewalls/)
for your firewall backend rather than disabling the firewall.

## Local configuration

From the repository root:

```sh
cd tailscale
cp .env.example .env
chmod 600 .env
mkdir -p tailscale-state
chmod 700 tailscale-state
```

If `.env` already exists, edit it instead of copying. Replace `TS_ROUTES` with
the actual LAN CIDR reachable from this host, or multiple comma-separated
CIDRs. `192.168.1.0/24` is only an example. Do not put default routes here;
exit-node advertisement is configured separately by `TS_EXTRA_ARGS`.

For first enrollment, generate a non-ephemeral, single-use auth key in the
[admin console](https://login.tailscale.com/admin/settings/keys) and set
`TS_AUTHKEY` in `.env`. Keep the key private. Existing authenticated state
does not need a new auth key.

The `./tailscale-state` bind mount preserves the node identity and credentials.
It and `.env` are ignored by Git. Back up state securely and keep using the
same deployment checkout. When adopting an existing installation, stop its
container and back up its state, then copy that state into `tailscale-state`
beside this Compose file, preserving ownership and permissions. Do not run two
instances against the same state or delete state for an update.

## Start and verify

From the `tailscale` directory, run each command only if the previous succeeds:

```sh
docker compose config --quiet
docker compose pull
docker compose up -d
docker compose ps
docker compose exec tailscale tailscale status
docker compose exec tailscale tailscale ip -4
```

After enrollment, clear `TS_AUTHKEY` in `.env` and run `docker compose up -d`
again to recreate the container without the key in its environment. Persistent
state and `TS_AUTH_ONCE=true` retain authentication across restarts. An empty
key is intentional after enrollment; fresh state needs a valid key.

In the admin console, approve the device if required, approve its subnet routes,
and allow it as an exit node. Tailnet policy must permit the intended LAN
traffic and exit-node use. Review device-key expiry separately from auth-key
expiry so the gateway's routes do not unexpectedly become unreachable.

From a remote client connected to the tailnet:

- Enable subnet-route acceptance if required by your client (on Linux,
  `sudo tailscale set --accept-routes`), then test a known LAN service by LAN IP.
- Select this gateway as the client's exit node and confirm the client's public
  IP matches the homelab's outbound public IP. Deselect it afterward if you do
  not want all internet traffic routed through the homelab.
- Test host services via the gateway's Tailscale IP, such as
  `http://<tailscale-ip>:81` for Nginx Proxy Manager. Host firewall rules,
  service bindings, and tailnet policy must allow access.

No Docker port mappings or router port forwards are required for this stack.
Existing LAN exposure remains in effect. Nginx Proxy Manager domain names still
need DNS that resolves correctly from remote clients; joining the tailnet does
not create application DNS records.

If startup or routing fails, check `docker compose logs tailscale` privately,
the TUN device, forwarding, route approvals, client settings, and firewall
rules. Remove credentials and private network details before sharing logs.

## Updates

Back up `tailscale-state`, run `git pull --ff-only` on the deployment branch
(`main` for normal deployments), then repeat the start and verification
commands. Check the [upstream changelog](https://tailscale.com/changelog) before
upgrading. Renovate discovers this image and proposes version and digest
updates; merging a PR does not deploy the stack.
