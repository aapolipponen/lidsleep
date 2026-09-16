# Changelog

## 1.0.0 - 2026-09-16

- `on`, `off`, `toggle` and `status` commands, with `--permanent` to keep the
  setting across logins.
- `reset` command to undo everything lidsleep changed.
- `version` command.
- Install script, Makefile, man page and bash/zsh/fish completions.
- Uses the packaged `lidsleep.service` when one is installed; otherwise writes
  its own, using wherever `systemd-inhibit` and `sleep` are on the system.
