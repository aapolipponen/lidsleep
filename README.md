# lidsleep

Control whether closing the laptop lid suspends the machine, on systemd/logind
systems. Lid sleep is "off" while a user service holds a logind
`handle-lid-switch` inhibitor; whether that service is *enabled* is the saved
default applied at each login.

## Install

```sh
git clone <this repo> ~/lidsleep
ln -s ~/lidsleep/lidsleep ~/.local/bin/lidsleep
```

The systemd user unit (`~/.config/systemd/user/lidsleep.service`) is written
automatically the first time it's needed.

## Usage

```
lidsleep on|off|toggle [-p]
lidsleep status|help
```

| command  | effect |
| -------- | ------ |
| `on`     | closing the lid suspends |
| `off`    | closing the lid does nothing |
| `toggle` | switch between on and off |
| `status` | show the current setting (the default with no arguments) |
| `help`   | show the help text |

`-p` / `--permanent` keeps the change after logout and reboot. Without it, the
change lasts until logout.
