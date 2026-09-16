#!/usr/bin/env bash
# Tests for lidsleep. systemctl and systemd-inhibit are replaced with fakes
# that keep their state in a temp dir, so the real system is never touched.

set -uo pipefail

root=$(cd "${0%/*}/.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

mkdir -p "$tmp/bin" "$tmp/state"
cat > "$tmp/bin/systemctl" <<'FAKE'
#!/usr/bin/env bash
state=$FAKE_STATE
args=()
for a in "$@"; do [[ $a == --user || $a == --quiet ]] || args+=("$a"); done
set -- "${args[@]}"
case $1 in
    start)       touch "$state/active" ;;
    stop)        rm -f "$state/active" ;;
    enable)      touch "$state/enabled" ;;
    disable)     rm -f "$state/enabled" ;;
    is-active)   [[ -e $state/active ]] ;;
    is-enabled)  [[ -e $state/enabled ]] ;;
    daemon-reload) echo reload >> "$state/log" ;;
    show)        cat "$state/fragment" 2>/dev/null; true ;;
    *)           exit 1 ;;
esac
FAKE
printf '#!/bin/sh\n' > "$tmp/bin/systemd-inhibit"
chmod +x "$tmp/bin/"*

export PATH="$tmp/bin:$PATH" FAKE_STATE="$tmp/state" XDG_CONFIG_HOME="$tmp/config" NO_COLOR=1
unit="$tmp/config/systemd/user/lidsleep.service"

pass=0 fail=0
check() { # check NAME EXPECTED ACTUAL
    if [[ $2 == "$3" ]]; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
        printf 'FAIL: %s\n  expected: %s\n  actual:   %s\n' "$1" "$2" "$3"
    fi
}
run() { "$root/lidsleep" "$@" 2>&1; }
code() { "$root/lidsleep" "$@" >/dev/null 2>&1; echo $?; }
clean() { rm -rf "${tmp:?}/state/"* "$tmp/config"; }

check "status by default" "Lid sleep: on (permanent)" "$(run)"
check "off" "Lid sleep: off (until logout, then on)" "$(run off)"
check "unit written" "yes" "$([[ -f $unit ]] && echo yes)"
check "unit uses resolved inhibit path" "yes" "$(grep -q "ExecStart=$tmp/bin/systemd-inhibit " "$unit" && echo yes)"
check "on" "Lid sleep: on (permanent)" "$(run on)"
check "off -p" "Lid sleep: off (permanent)" "$(run off -p)"
check "on (not permanent)" "Lid sleep: on (until logout, then off)" "$(run on)"
check "toggle" "Lid sleep: off (permanent)" "$(run toggle)"
check "toggle --permanent" "Lid sleep: on (permanent)" "$(run toggle --permanent)"

clean
run off >/dev/null
run off >/dev/null
check "unit not rewritten when current" "1" "$(wc -l < "$tmp/state/log")"

clean
echo /usr/lib/systemd/user/lidsleep.service > "$tmp/state/fragment"
run off >/dev/null
check "packaged unit is used" "no" "$([[ -e $unit ]] && echo yes || echo no)"

clean
run off -p >/dev/null
check "reset" "Lid sleep: on (lidsleep settings removed)" "$(run reset)"
check "reset removes unit" "no" "$([[ -e $unit ]] && echo yes || echo no)"
check "reset disables" "Lid sleep: on (permanent)" "$(run status)"

check "version" "lidsleep $(sed -n 's/^VERSION=//p' "$root/lidsleep")" "$(run version)"
check "help exits 0" 0 "$(code help)"
check "unknown command" 2 "$(code nope)"
check "unknown option" 2 "$(code off -x)"
check "-p with status" 2 "$(code status -p)"
check "too many arguments" 2 "$(code off -p extra)"

echo "$pass passed, $fail failed"
[[ $fail -eq 0 ]]
