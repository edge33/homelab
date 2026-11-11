# Home Assistant

Requires Linux Docker Engine 23 or newer and port `8123` available on the host.

```sh
cd homeassistant
mkdir -p config
```

For an existing installation, stop its container and copy the complete
configuration, including `.storage`, into `./config` with permissions preserved.
No `.env` file is needed. Remove the `/run/dbus` mount if the host has no D-Bus
socket and Bluetooth is unused.

[Start the stack](../README.md). Open `http://<homelab-ip>:8123` and complete
onboarding or verify your existing integrations. This is the Container edition;
managed add-ons are unavailable.

For a reverse proxy, configure only its actual source address in
[trusted proxies](https://www.home-assistant.io/integrations/http/#reverse-proxies).
See [updates](../README.md#updates) and the
[official container guide](https://www.home-assistant.io/installation/linux/).
