# Agent guidance

- Keep changes focused and follow the existing Docker Compose conventions.
- Read the affected Compose file, `.env.example`, and README before editing.
- Keep service READMEs to the minimum instructions needed to configure, start,
  access, and update the service. Put shared instructions in the root README.
- Omit change history, implementation rationale, and explanations of why changes
  were made unless the behavior is counterintuitive and affects operation.
- Keep required prerequisites, credentials, persistent paths, and essential
  service-specific steps. Link upstream documentation for optional setup.
- Keep image tags and digests pinned; avoid duplicating versions in READMEs.
- Never commit or expose real `.env` files, credentials, runtime state, or
  migration archives, including `hermes/data.zip`.
- Do not start, stop, or migrate live services unless the user requests it.
- Validate affected stacks with `docker compose config --quiet` using dummy
  environment values; do not print resolved credentials. Run `git diff --check`
  and review the final diff before committing.
- Report the branch, worktree, checks run, and any remaining blockers.
