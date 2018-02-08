PKGS ?= --pkg glib-2.0 --pkg gio-2.0 --pkg gtk+-3.0 --pkg gee-0.8 --pkg libsoup-2.4 --pkg json-glib-1.0
SOURCES := src/main.vala src/App.vala src/Window.vala src/Canvas.vala src/Poller.vala src/Danmaku.vala

vala-danmaku-client: ${SOURCES}
	valac --thread ${PKGS} -o bin/vala-danmaku-client ${SOURCES}

.PHONY: debug
debug: ${SOURCES}
	valac -g --thread ${PKGS} -o bin/vala-danmaku-client_debug ${SOURCES}

.PHONY: install
install:
	install -o root -m 0755 -D bin/vala-danmaku-client /usr/bin/vala-danmaku-client

.PHONY: uninstall
uninstall:
	-rm -f /usr/bin/vala-danmaku-client

.PHONY: clean
clean:
	-rm -f bin/vala-danmaku-client bin/vala-danmaku-client_debug

.PHONY: rebuild
rebuild: clean vala-danmaku-client
