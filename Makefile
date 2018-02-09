PKGS ?= --pkg glib-2.0 --pkg gio-2.0 --pkg gtk+-3.0 --pkg gee-0.8 --pkg libsoup-2.4 --pkg json-glib-1.0
SOURCES := src/main.vala src/App.vala src/Window.vala src/Canvas.vala src/Poller.vala src/Danmaku.vala
WIN32DLLS := {libatk-1.0-0.dll,libbz2-1.dll,libcairo-2.dll,libcairo-gobject-2.dll,libepoxy-0.dll,libexpat-1.dll,libffi-6.dll,libfontconfig-1.dll,libfreetype-6.dll,libgcc_s_dw2-1.dll,libgdk-3-0.dll,libgdk_pixbuf-2.0-0.dll,libgee-0.8-2.dll,libgio-2.0-0.dll,libglib-2.0-0.dll,libgmodule-2.0-0.dll,libgobject-2.0-0.dll,libgraphite2.dll,libgtk-3-0.dll,libharfbuzz-0.dll,libiconv-2.dll,libintl-8.dll,libjson-glib-1.0-0.dll,liblzma-5.dll,libpango-1.0-0.dll,libpangocairo-1.0-0.dll,libpangoft2-1.0-0.dll,libpangowin32-1.0-0.dll,libpcre-1.dll,libpixman-1-0.dll,libpng16-16.dll,libsoup-2.4-1.dll,libsqlite3-0.dll,libstdc++-6.dll,libwinpthread-1.dll,libxml2-2.dll,zlib1.dll}

vala-danmaku-client: ${SOURCES}
	-mkdir bin
	valac -X -O2 -o bin/vala-danmaku-client --thread ${PKGS} ${SOURCES}

# Use -X -mwindows to pass this to mingw and disable the console in Windows.
win32: ${SOURCES}
	-mkdir bin
	valac -X -O2 -X -mwindows -o bin/vala-danmaku-client --thread ${PKGS} ${SOURCES}
	cp /mingw32/bin/${WIN32DLLS} bin/

.PHONY: debug
debug: ${SOURCES}
	-mkdir bin
	valac -g -o bin/vala-danmaku-client_debug --thread ${PKGS} ${SOURCES}

.PHONY: win32_debug
win32_debug: ${SOURCES}
	-mkdir bin
	valac -g -X -mwindows -o bin/vala-danmaku-client_debug --thread ${PKGS} ${SOURCES}
	cp /mingw32/bin/${WIN32DLLS} bin/

.PHONY: install
install:
	install -o root -m 0755 -D bin/vala-danmaku-client /usr/bin/vala-danmaku-client

.PHONY: uninstall
uninstall:
	-rm -f /usr/bin/vala-danmaku-client

.PHONY: clean
clean:
	-rm -f bin/vala-danmaku-client bin/vala-danmaku-client_debug bin/vala-danmaku-client.exe bin/vala-danmaku-client_debug.exe bin/${WIN32DLLS}

.PHONY: rebuild
rebuild: clean vala-danmaku-client
