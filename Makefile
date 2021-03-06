# first entries are for gnu make, 2nd for BSD make.  see http://lists.uzbl.org/pipermail/uzbl-dev-uzbl.org/2009-July/000177.html

CFLAGS:=-std=c99 $(shell pkg-config --cflags gtk+-2.0 webkit-1.0 libsoup-2.4 gthread-2.0) -ggdb -Wall -W -DARCH="\"$(shell uname -m)\"" -lgthread-2.0 -DG_ERRORCHECK_MUTEXES -DCOMMIT="\"$(shell git log | head -n1 | sed "s/.* //")\"" $(CPPFLAGS) -fPIC -W -Wall -Wextra -pedantic -ggdb3
CFLAGS!=echo -std=c99 `pkg-config --cflags gtk+-2.0 webkit-1.0 libsoup-2.4 gthread-2.0` -ggdb -Wall -W -DARCH='"\""'`uname -m`'"\""' -lgthread-2.0 -DG_ERRORCHECK_MUTEXES -DCOMMIT='"\""'`git log | head -n1 | sed "s/.* //"`'"\""' $(CPPFLAGS) -fPIC -W -Wall -Wextra -pedantic -ggdb3

LDFLAGS:=$(shell pkg-config --libs gtk+-2.0 webkit-1.0 libsoup-2.4 gthread-2.0) -pthread $(LDFLAGS)
LDFLAGS!=echo `pkg-config --libs gtk+-2.0 webkit-1.0 libsoup-2.4 gthread-2.0` -pthread $(LDFLAGS)

all: uzbl

PREFIX?=$(DESTDIR)/usr/local

# When compiling unit tests, compile uzbl as a library first
tests: uzbl.o
	$(CC) -DUZBL_LIBRARY -shared -Wl uzbl.o -o ./tests/libuzbl.so
	cd ./tests/; $(MAKE)

test: uzbl
	./uzbl --uri http://www.uzbl.org --verbose

test-dev: uzbl
	XDG_DATA_HOME=./examples/data               XDG_CONFIG_HOME=./examples/config               ./uzbl --uri http://www.uzbl.org --verbose

test-share: uzbl
	XDG_DATA_HOME=${PREFIX}/share/uzbl/examples/data XDG_CONFIG_HOME=${PREFIX}/share/uzbl/examples/config ./uzbl --uri http://www.uzbl.org --verbose


clean:
	rm -f uzbl
	rm -f uzbl.o
	cd ./tests/; $(MAKE) clean

install:
	install -d $(PREFIX)/bin
	install -d $(PREFIX)/share/uzbl/docs
	install -d $(PREFIX)/share/uzbl/examples
	install -m755 uzbl $(PREFIX)/bin/uzbl
	cp -rp docs     $(PREFIX)/share/uzbl/
	cp -rp config.h $(PREFIX)/share/uzbl/docs/
	cp -rp examples $(PREFIX)/share/uzbl/
	install -m644 AUTHORS $(PREFIX)/share/uzbl/docs
	install -m644 README  $(PREFIX)/share/uzbl/docs


uninstall:
	rm -rf $(PREFIX)/bin/uzbl
	rm -rf $(PREFIX)/share/uzbl
