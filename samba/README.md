# Samba

From this directory:

```sh
cp .env.example .env
# Edit .env with your share path, username, and a new strong password.
docker compose config --quiet
docker compose up -d
```

Create the host share directory first. File ownership uses user/group ID `1000`,
configured in `docker-compose.yml`. The SMB share is named `drive-name`.
Images, ports, and other service settings are defined in the Compose file.

Keep `.env` local. Never use a sample password as a real password. Single quotes
preserve literal `$` and `#` characters in `.env`; avoid semicolons and double
quotes in Samba credentials because they act as command delimiters.
Do not share the output of `docker compose config`, which contains credentials.

Samba stores its internal configuration and state in Docker named volumes.
Keep those volume names unchanged to retain state across container updates.

For subsequent repository updates, run `git pull --ff-only` and then
`docker compose up -d` from this directory. Ignored local `.env` and service data
files do not normally interfere with pulls. Keep generated files under the
ignored data directories or outside the repository; future commits must not
track the same paths. `.gitignore` does not protect files already tracked by Git.

The repository history was replaced to remove an old sample credential. Use a
fresh clone if your existing clone has the old history. Replace any password
reused from that history; rewriting Git history does not retract existing copies.
