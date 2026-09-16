Name:           lidsleep
Version:        1.0.0
Release:        1%{?dist}
Summary:        Control whether closing the laptop lid suspends

License:        MIT
URL:            https://github.com/aapolipponen/lidsleep
Source0:        %{url}/archive/refs/tags/v%{version}.tar.gz

BuildArch:      noarch
BuildRequires:  make
BuildRequires:  systemd-rpm-macros
Requires:       bash
Requires:       systemd

%description
lidsleep turns lid close suspend on or off for the current user on
systemd-logind systems, either until logout or permanently. It works by
holding a handle-lid-switch inhibitor from a systemd user service, so it
needs no root access and does not edit logind.conf.

%prep
%autosetup

%build

%check
tests/run.sh

%install
%make_install PREFIX=%{_prefix} USERUNITDIR=%{_userunitdir}

%files
%license LICENSE
%doc README.md CHANGELOG.md
%{_bindir}/lidsleep
%{_userunitdir}/lidsleep.service
%{_mandir}/man1/lidsleep.1*
%{_datadir}/bash-completion/completions/lidsleep
%{_datadir}/zsh/site-functions/_lidsleep
%{_datadir}/fish/vendor_completions.d/lidsleep.fish

%changelog
* Wed Sep 16 2026 Aapo Lipponen <47327885+aapolipponen@users.noreply.github.com> - 1.0.0-1
- Initial package
