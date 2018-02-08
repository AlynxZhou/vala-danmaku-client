namespace VDMKC {
	public class Window : Gtk.ApplicationWindow {
		private App app;
		private Gtk.Switch poll_switch;
		private Gtk.Entry server_entry;
		private Gtk.Entry channel_entry;
		private Gtk.Entry password_entry;
		public Window(App app) {
			// Super.
			Object(application: app);
			this.app = app;
			this.set_title("VDMKC.Window");
			this.set_border_width(10);
			var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 10);
			var child_boxes = new Gtk.Box[4];
			child_boxes[0] = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 10);
			child_boxes[0].pack_start(new Gtk.Label("开关："), false, false, 0);
			this.poll_switch = new Gtk.Switch();
			this.poll_switch.set_active(false);
			this.poll_switch.notify["active"].connect(this.on_active);
			child_boxes[0].pack_end(this.poll_switch, true, false, 0);
			box.pack_start(child_boxes[0], true, false, 0);
			child_boxes[1] = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 10);
			child_boxes[1].pack_start(new Gtk.Label("服务器地址："), false, false, 0);
			this.server_entry = new Gtk.Entry();
			this.server_entry.set_text("http://danmaku.ismyonly.one:2333/");
			child_boxes[1].pack_end(this.server_entry, true, true, 0);
			box.pack_start(child_boxes[1], true, false, 0);
			child_boxes[2] = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 10);
			child_boxes[2].pack_start(new Gtk.Label("频道名称："), false, false, 0);
			this.channel_entry = new Gtk.Entry();
			this.channel_entry.set_text("demo");
			child_boxes[2].pack_end(this.channel_entry, true, true, 0);
			box.pack_start(child_boxes[2], true, false, 0);
			child_boxes[3] = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 10);
			child_boxes[3].pack_start(new Gtk.Label("频道密码（如果有）："), false, false, 0);
			this.password_entry = new Gtk.Entry();
			this.password_entry.set_visibility(false);
			child_boxes[3].pack_end(this.password_entry, true, true, 0);
			box.pack_start(child_boxes[3], true, false, 0);
			this.add(box);
			this.show_all();
		}
		public void on_active() {
			if (this.poll_switch.get_active()) {
				this.app.poller = new Poller(this.app, this.server_entry.get_text(), this.channel_entry.get_text(), this.password_entry.get_text());
				this.app.poller.start_poll();
				this.app.canvas = new Canvas(this.app);
				this.app.canvas.show_all();
			} else {
				this.app.canvas.close();
				this.app.poller.stop_poll();
				this.app.poller = null;
				this.app.canvas = null;
			}
		}
	}
}
