# Garage Bot

Make the image referenced in `docker-compose.yml` available on the Docker host.

```sh
cd garage-bot
cp .env.example .env
chmod 600 .env
```

If `.env` exists, edit it instead of copying. Add the environment values required
by your Garage Bot application. See the
[Garage Bot project](https://github.com/edge33/garage-bot) for application
configuration.

[Start the stack](../README.md). This stack publishes no host ports.

To update, make the new image available on the host, update the pinned image in
`docker-compose.yml`, then run `docker compose up -d` from this directory.
