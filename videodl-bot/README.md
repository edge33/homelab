# VideoDL Bot

Requires an amd64 or arm64 Linux Docker host, access to GitHub Container Registry,
and outbound HTTPS/DNS. Download storage must support hard links.

```sh
cd videodl-bot
cp .env.example .env
chmod 600 .env
sudo install -d -o 1000 -g 1000 -m 0750 downloads state
```

If `.env` exists, edit it instead of copying. Set `TELEGRAM_BOT_API_KEY` and
`TELEGRAM_ALLOWED_USER_ID`. For different storage or ownership, set
`VIDEODL_DOWNLOADS_PATH`, `VIDEODL_STATE_PATH`, `PUID`, and `PGID`, and create both
directories with that non-root UID/GID before starting.

[Start the stack](../README.md). Access the bot through its Telegram direct chat;
this stack publishes no host ports. Run only one instance per bot token and state
directory. See the [upstream documentation](https://github.com/edge33/videodl-bot#local-configuration)
for bot setup, commands, and resource limits.

Downloads persist in `VIDEODL_DOWNLOADS_PATH`, mounted at `/downloads`; SQLite
queue state persists in `VIDEODL_STATE_PATH`, mounted at `/state`. Keep both
directories across updates. For a consistent backup, stop this stack and copy
both directories, keeping the SQLite database and WAL files together.

See [shared update instructions](../README.md#updates).
