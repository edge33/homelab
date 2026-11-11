# Samba

```sh
cd samba
cp .env.example .env
chmod 600 .env
```

If `.env` exists, edit it instead of copying. Set `SAMBA_SHARE_PATH` to an
absolute host directory and create it. Set `SAMBA_USER` and `SAMBA_PASSWORD`;
avoid semicolons and double quotes in credentials. Use single quotes around
`.env` values containing literal `$` or `#`.

Ensure UID/GID `1000:1000` can access the share; adjust `USERID`/`GROUPID` in
Compose if needed.

[Start the stack](../README.md). Connect to `smb://<homelab-ip>/drive-name`
using the credentials from `.env`. State uses the `samba_*` named volumes.

For application configuration, see the
[upstream container documentation](https://github.com/dperson/samba).
See [shared update instructions](../README.md#updates).
