#!/bin/sh
# Install the latest lidsleep release for the current user (no root needed).
#
#   curl -fsSL https://raw.githubusercontent.com/aapolipponen/lidsleep/main/install.sh | sh
#
# Set LIDSLEEP_VERSION (e.g. v1.0.0) to install a specific release, and
# PREFIX to install somewhere other than ~/.local.

set -eu

repo=aapolipponen/lidsleep
prefix=${PREFIX:-$HOME/.local}

say() { printf '%s\n' "$*"; }
die() { printf 'lidsleep install: %s\n' "$*" >&2; exit 1; }

command -v systemctl >/dev/null 2>&1 || die "systemd is required"
command -v systemd-inhibit >/dev/null 2>&1 || die "systemd-inhibit is required"
command -v curl >/dev/null 2>&1 || die "curl is required"
command -v tar >/dev/null 2>&1 || die "tar is required"

version=${LIDSLEEP_VERSION:-}
if [ -z "$version" ]; then
    url=$(curl -fsSLI -o /dev/null -w '%{url_effective}' "https://github.com/$repo/releases/latest") \
        || die "could not find the latest release"
    version=${url##*/}
fi
case $version in
    v[0-9]*) ;;
    *) die "could not find the latest release" ;;
esac

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

say "Downloading lidsleep $version"
curl -fsSL "https://github.com/$repo/archive/refs/tags/$version.tar.gz" | tar -xz -C "$tmp" --strip-components=1 \
    || die "download failed"

data=${XDG_DATA_HOME:-$HOME/.local/share}
install -Dm755 "$tmp/lidsleep" "$prefix/bin/lidsleep"
install -Dm644 "$tmp/lidsleep.1" "$prefix/share/man/man1/lidsleep.1"
install -Dm644 "$tmp/completions/lidsleep.bash" "$data/bash-completion/completions/lidsleep"
install -Dm644 "$tmp/completions/lidsleep.fish" "${XDG_CONFIG_HOME:-$HOME/.config}/fish/completions/lidsleep.fish"

say "Installed lidsleep to $prefix/bin/lidsleep"
case :$PATH: in
    *:"$prefix/bin":*) ;;
    *) say "Note: $prefix/bin is not in your PATH" ;;
esac
