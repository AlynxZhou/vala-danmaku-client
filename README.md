# vala-danmaku-client
A danmaku client on desktop, written in Vala and using GTK+, Cairo.

Compile it with:

```
$ valac --thread --pkg gio-2.0 --pkg glib-2.0 --pkg gtk+-3.0 --pkg gee-0.8 --pkg libsoup-2.4 --pkg json-glib-1.0 src/main.vala src/Window.vala src/App.vala src/Canvas.vala
src/Poller.vala src/Danmaku.vala -o bin/vala-danmaku-client
```

Currently tested in GNOME 3.26.

Needs Noto Sans CJK SC font to work!
