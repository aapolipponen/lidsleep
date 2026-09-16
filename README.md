# lidsleep

Control whether closing the laptop lid suspends the machine, on Linux systems
using systemd-logind. No root access and no edits to `logind.conf`.

```console
$ lidsleep off
Lid sleep: off (until logout, then on)
$ lidsleep on --permanent
Lid sleep: on (permanent)
```

Useful when you want to close the lid while something keeps running (a
download, an external monitor, music) and have normal behavior back later.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/aapolipponen/lidsleep/main/install.sh | sh
```

This installs the latest release to `~/.local/bin`, along with the man page
and shell completions. Nothing is installed system-wide.

From a clone:

```sh
git clone https://github.com/aapolipponen/lidsleep
cd lidsleep
sudo make install                     # /usr/local
make install PREFIX=~/.local          # or just for you
```

Requirements: bash and systemd (`systemctl`, `systemd-inhibit`).

## Usage

```
lidsleep on|off|toggle [-p]
lidsleep status|reset|help|version
```

| command   | effect |
| --------- | ------ |
| `on`      | closing the lid suspends |
| `off`     | closing the lid does nothing |
| `toggle`  | switch between on and off |
| `status`  | show the current setting (the default with no arguments) |
| `reset`   | turn lid sleep back on and remove the saved setting |
| `help`    | show the help text |
| `version` | show the version |

`-p` / `--permanent` keeps the change after logout and reboot. Without it, the
change lasts until logout.

Set `NO_COLOR` to turn off colored output.

## How it works

logind lets programs block the lid switch action by holding a
`handle-lid-switch` inhibitor lock. lidsleep runs a systemd user service,
`lidsleep.service`, that holds that lock:

- `off` starts the service, `on` stops it.
- `--permanent` also enables or disables it, which decides the state at login.

If the unit isn't installed by a package, lidsleep writes it to
`~/.config/systemd/user/lidsleep.service` the first time it's needed. You can
check the lock with `systemd-inhibit --list`.

Some desktop environments hold their own lid switch inhibitor and handle the
lid themselves, in which case their power settings apply instead.

## Uninstall

```sh
lidsleep reset
rm ~/.local/bin/lidsleep    # or: sudo make uninstall
```

`reset` stops and disables the service and removes the unit file lidsleep
wrote, so lid close suspends again.

## License

MIT
