
BIN ?= uget
PREFIX ?= /usr/local

install:
	cp uget.sh $(PREFIX)/bin/$(BIN)

uninstall:
	rm -f $(PREFIX)/bin/$(BIN)

