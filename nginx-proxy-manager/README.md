# Nginx Proxy Manager

Requires host TCP ports `80`, `443`, and `81` available.

```sh
cd nginx-proxy-manager
mkdir -p data letsencrypt
```

State mounts use `./data` and `./letsencrypt`. No `.env` file is needed.

[Start the stack](../README.md). Admin UI: `http://<homelab-ip>:81`.

For application and proxy configuration, see the
[upstream setup guide](https://nginxproxymanager.com/setup/).

See [updates](../README.md#updates) and
[upstream upgrade notes](https://nginxproxymanager.com/upgrading/).
