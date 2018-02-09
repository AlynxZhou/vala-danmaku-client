# vala-danmaku-client

A danmaku client on desktop, written in Vala and using GTK+, Cairo.

Dependency:

- glib-2.0
- gio-2.0
- gtk+-3.0
- gee-0.8
- libsoup-2.4
- json-glib-1.0

Compile it with:

```
$ make
```

If you are using Windows, install [MSYS 2](http://www.msys2.org/) (I use 32-bit version in Makefile), and use `pacman -S make git` to install `make` and `git`, then use `pacman -S mingw-w64-i686-gcc mingw-w64-i686-pkg-config mingw-w64-i686-vala mingw-w64-i686-gtk3 mingw-w64-i686-libgee mingw-w64-i686-libsoup` to install dependency and then `make win32`. Then you can copy all files under `bin`, and run it needs `msvcrt.dll`.

```
$ pacman -S make git
$ pacman -S mingw-w64-i686-gcc mingw-w64-i686-pkg-config mingw-w64-i686-vala mingw-w64-i686-gtk3 mingw-w64-i686-libgee mingw-w64-i686-libsoup
$ make win32
```

Run it with:

```
$ ./bin/vala-danmaku-client
```

Visit [http://danmaku.ismyonly.one:2333/](http://danmaku.ismyonly.one:2333/) to find channel and shoot danmakus!

If you want to create your own server see [coffee-danmaku-server](https://github.com/AlynxZhou/coffee-danmaku-server).

Currently tested in GNOME 3.26 and Windows.

Needs Noto Sans CJK SC font to work!
