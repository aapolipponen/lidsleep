PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
MANDIR ?= $(PREFIX)/share/man
DATADIR ?= $(PREFIX)/share
USERUNITDIR ?= $(PREFIX)/lib/systemd/user

.PHONY: all install uninstall check test

all:

install:
	install -Dm755 lidsleep $(DESTDIR)$(BINDIR)/lidsleep
	install -Dm644 lidsleep.service $(DESTDIR)$(USERUNITDIR)/lidsleep.service
	install -Dm644 lidsleep.1 $(DESTDIR)$(MANDIR)/man1/lidsleep.1
	install -Dm644 completions/lidsleep.bash $(DESTDIR)$(DATADIR)/bash-completion/completions/lidsleep
	install -Dm644 completions/_lidsleep $(DESTDIR)$(DATADIR)/zsh/site-functions/_lidsleep
	install -Dm644 completions/lidsleep.fish $(DESTDIR)$(DATADIR)/fish/vendor_completions.d/lidsleep.fish

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/lidsleep
	rm -f $(DESTDIR)$(USERUNITDIR)/lidsleep.service
	rm -f $(DESTDIR)$(MANDIR)/man1/lidsleep.1
	rm -f $(DESTDIR)$(DATADIR)/bash-completion/completions/lidsleep
	rm -f $(DESTDIR)$(DATADIR)/zsh/site-functions/_lidsleep
	rm -f $(DESTDIR)$(DATADIR)/fish/vendor_completions.d/lidsleep.fish

check:
	shellcheck lidsleep install.sh completions/lidsleep.bash tests/run.sh

test:
	tests/run.sh
