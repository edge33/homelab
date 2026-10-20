# Homelab

Docker Compose stacks for [Pi-hole](pi-hole/README.md) and
[Samba](samba/README.md).

## Automated image updates

Renovate is configured in `renovate.json` to open pull requests for Docker
Compose image updates throughout this repository. It tracks version tags and
pins images to digests, allowing changes to mutable tags such as Samba's
`latest` to be reviewed in Git. Automerge is disabled.

To activate updates, install the [Renovate GitHub App](https://github.com/apps/renovate)
and grant it access to `edge33/homelab`, then merge this configuration into
`main`. If the app is already installed, ensure this repository is selected.
Renovate will propose the initial digest pins and subsequent image updates.
See the [Renovate Docker documentation](https://docs.renovatebot.com/docker/)
for details.

Review and merge update pull requests, then follow each stack's manual update
instructions on the homelab host. Merging a pull request does not deploy the
containers.
