# Home Assistant

Requires Linux Docker Engine 23 or newer and port `8123` available on the host.

```sh
cd homeassistant
mkdir -p config
```

State is mounted from `./config`. No `.env` file is needed. The host must provide
`/run/dbus` for the configured mount; remove that mount if unused.

[Start the stack](../README.md). Web UI: `http://<homelab-ip>:8123`.

For application and integration configuration, use the
[official documentation](https://www.home-assistant.io/docs/).
See [updates](../README.md#updates) and the
[official container guide](https://www.home-assistant.io/installation/linux/).
