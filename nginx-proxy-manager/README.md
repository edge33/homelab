# Nginx Proxy Manager

Requires host TCP ports `80`, `443`, and `81` available.

```sh
cd nginx-proxy-manager
mkdir -p data letsencrypt
```

Reuse existing `data` and `letsencrypt` together, with permissions preserved,
while the old instance is stopped. No `.env` file is needed.

[Start the stack](../README.md). Open `http://<homelab-ip>:81` to configure the
administrator and proxy hosts. Keep admin port `81` private. For public HTTPS,
point DNS at the public IP and forward ports `80`/`443` to this host.

For services in other stacks, use the host's reachable LAN IP and published
port as the upstream; `localhost` refers to the proxy container.

See [updates](../README.md#updates) and
[upstream upgrade notes](https://nginxproxymanager.com/upgrading/).
