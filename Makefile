PKGS := --pkg=glib-2.0 --pkg=gio-2.0 --pkg=gtk+-3.0 --pkg=gee-0.8 --pkg=libsoup-2.4 --pkg=json-glib-1.0
SOURCES := src/main.vala src/App.vala src/Window.vala src/Canvas.vala src/Poller.vala src/Danmaku.vala
MSGSRC := $(wildcard msg/*.po)
MSGOBJ := $(foreach n,${MSGSRC},locale/$(notdir $(basename ${n}))/LC_MESSAGES/vala-danmaku-client.mo)
WIN32DLLS := {libatk-1.0-0.dll,libbz2-1.dll,libcairo-2.dll,libcairo-gobject-2.dll,libepoxy-0.dll,libexpat-1.dll,libffi-6.dll,libfontconfig-1.dll,libfreetype-6.dll,libgcc_s_dw2-1.dll,libgdk-3-0.dll,libgdk_pixbuf-2.0-0.dll,libgee-0.8-2.dll,libgettextlib-0-19-8-1.dll,libgettextpo-0.dll,libgettextsrc-0-19-8-1.dll,libgio-2.0-0.dll,libglib-2.0-0.dll,libgmodule-2.0-0.dll,libgobject-2.0-0.dll,libgraphite2.dll,libgtk-3-0.dll,libharfbuzz-0.dll,libiconv-2.dll,libintl-8.dll,libjson-glib-1.0-0.dll,liblzma-5.dll,libpango-1.0-0.dll,libpangocairo-1.0-0.dll,libpangoft2-1.0-0.dll,libpangowin32-1.0-0.dll,libpcre-1.dll,libpixman-1-0.dll,libpng16-16.dll,libsoup-2.4-1.dll,libsqlite3-0.dll,libstdc++-6.dll,libwinpthread-1.dll,libxml2-2.dll,zlib1.dll}

linux: ${MSGOBJ} ${SOURCES}
	mkdir -p bin/linux/
	cp -R locale/ bin/linux/
	valac --Xcc=-O2 --Xcc=-DGETTEXT_PACKAGE=\"vala-danmaku-client\" --thread ${PKGS} -o bin/linux/vala-danmaku-client ${SOURCES}

macos: ${MSGOBJ} ${SOURCES}
	mkdir -p bin/macos/
	cp -R locale/ bin/macos/
	valac --Xcc=-O2 --Xcc=-DGETTEXT_PACKAGE=\"vala-danmaku-client\" --thread ${PKGS} -o bin/macos/vala-danmaku-client ${SOURCES}

# Use -X -mwindows to pass this to mingw and disable the console in Windows.
win32: ${MSGOBJ} ${SOURCES}
	mkdir -p bin/win32/
	cp -R locale/ bin/win32/
	cp /mingw32/bin/${WIN32DLLS} bin/win32/
	valac --Xcc=-O2 --Xcc=-mwindows --Xcc=-DGETTEXT_PACKAGE=\"vala-danmaku-client\" --thread ${PKGS} -o bin/win32/vala-danmaku-client ${SOURCES}

.PHONY: debug
debug: ${MSGOBJ} ${SOURCES}
	mkdir -p bin/linux/
	cp -R locale/ bin/linux/
	valac -g -D __DEBUG__ --Xcc=-DGETTEXT_PACKAGE=\"vala-danmaku-client\" --thread ${PKGS} -o bin/linux/vala-danmaku-client_debug ${SOURCES}

.PHONY: win32_debug
win32_debug: ${MSGOBJ} ${SOURCES}
	mkdir -p bin/win32/
	cp -R locale/ bin/win32/
	cp /mingw32/bin/${WIN32DLLS} bin/win32/
	valac -g -D __DEBUG__ --Xcc=-DGETTEXT_PACKAGE=\"vala-danmaku-client\" --thread ${PKGS} -o bin/win32/vala-danmaku-client_debug ${SOURCES}

.PHONY: macos_debug
macos_debug: ${MSGOBJ} ${SOURCES}
	mkdir -p bin/macos/
	cp -R locale/ bin/macos/
	valac -g -D __DEBUG__ --Xcc=-DGETTEXT_PACKAGE=\"vala-danmaku-client\" --thread ${PKGS} -o bin/macos/vala-danmaku-client_debug ${SOURCES}

${MSGOBJ}: locale/%/LC_MESSAGES/vala-danmaku-client.mo: msg/%.po
	mkdir -p $(dir $@)
	msgfmt -c $< -o $@

# TODO: Install and uninstall locale/.
.PHONY: install
install:
	install -o root -m 0755 -D bin/linux/vala-danmaku-client /usr/bin/vala-danmaku-client

.PHONY: uninstall
uninstall:
	-rm -f /usr/bin/vala-danmaku-client

.PHONY: clean
clean:
	-rm -rf bin/win32 bin/linux locale/

.PHONY: rebuild
rebuild: clean linux
