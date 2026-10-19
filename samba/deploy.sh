#!/usr/bin/env bash
set -euo pipefail

if (( $# > 1 )); then
  echo "Usage: $0 [env-file]" >&2
  exit 1
fi

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(git -C "$script_dir" rev-parse --show-toplevel)"
env_file="${1:-$script_dir/.env}"

if [[ ! -r "$env_file" ]]; then
  echo "Environment file is not readable: $env_file" >&2
  exit 1
fi

git -C "$repo_root" pull --ff-only

compose=(
  docker compose
  --project-name samba
  --env-file "$env_file"
  --file "$repo_root/samba/docker-compose.yml"
)

"${compose[@]}" config --quiet
"${compose[@]}" pull
"${compose[@]}" up -d
"${compose[@]}" ps
