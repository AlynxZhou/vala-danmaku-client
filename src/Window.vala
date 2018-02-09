namespace VDMKC {
	public class Window : Gtk.ApplicationWindow {
		private App app;
		private Gtk.Entry server_entry;
		private Gtk.Entry channel_entry;
		private Gtk.Entry password_entry;
		private Gtk.Entry animate_time_entry;
		private Gtk.Entry slot_length_entry;
		public Window(App app) {
			// Super.
			Object(application: app);
			this.app = app;
			this.set_title("VDMKC.Window");
			this.set_icon_name("preferences-desktop-screensaver");
			this.set_border_width(10);
			var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 10);
			var child_boxes = new Gtk.Box[6];
			child_boxes[0] = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 10);
			child_boxes[0].pack_start(new Gtk.Label("开关："), false, false, 0);
			this.app.poll_switch = new Gtk.Switch();
			this.app.poll_switch.set_active(false);
			this.app.poll_switch.notify["active"].connect(() => {
				if (this.app.poll_switch.get_active()) {
					this.server_entry.set_editable(false);
					this.channel_entry.set_editable(false);
					this.password_entry.set_editable(false);
					this.animate_time_entry.set_editable(false);
					this.slot_length_entry.set_editable(false);
					this.app.animate_time = (int64)(double.parse(this.animate_time_entry.get_text()) * 1000);
					if (this.app.animate_time < 1000) {
						this.app.animate_time = 10 * 1000;
						this.animate_time_entry.set_text("10");
						this.app.status.set_label("显示时间太短，设为默认值 10 秒！");
					}
					this.app.slot_length = int.parse(this.slot_length_entry.get_text());
					this.app.status = new Gtk.Label("Code by AlynxZhou, GPLv3 License.");
					this.app.poller = new Poller(this.app, this.server_entry.get_text(), this.channel_entry.get_text(), this.password_entry.get_text());
					this.app.poller.start_poll();
					this.app.canvas = new Canvas(this.app);
					this.app.canvas.show_all();
				} else {
					this.app.canvas.close();
					this.app.poller.stop_poll();
					this.app.poller = null;
					this.app.canvas = null;
					this.server_entry.set_editable(true);
					this.channel_entry.set_editable(true);
					this.password_entry.set_editable(true);
					this.animate_time_entry.set_editable(true);
					this.slot_length_entry.set_editable(true);
				}
			});
			child_boxes[0].pack_end(this.app.poll_switch, true, false, 0);
			box.pack_start(child_boxes[0], true, false, 0);
			child_boxes[1] = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 10);
			child_boxes[1].pack_start(new Gtk.Label("服务器地址："), false, false, 0);
			this.server_entry = new Gtk.Entry();
			this.server_entry.set_text("http://danmaku.ismyonly.one:2333/");
			this.server_entry.activate.connect(() => {
				if (this.app.poll_switch.get_active())
					this.app.poll_switch.set_active(false);
				else
					this.app.poll_switch.set_active(true);
			});
			child_boxes[1].pack_end(this.server_entry, true, true, 0);
			box.pack_start(child_boxes[1], true, false, 0);
			child_boxes[2] = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 10);
			child_boxes[2].pack_start(new Gtk.Label("频道名称："), false, false, 0);
			this.channel_entry = new Gtk.Entry();
			this.channel_entry.set_text("demo");
			this.channel_entry.activate.connect(() => {
				if (this.app.poll_switch.get_active())
					this.app.poll_switch.set_active(false);
				else
					this.app.poll_switch.set_active(true);
			});
			child_boxes[2].pack_end(this.channel_entry, true, true, 0);
			box.pack_start(child_boxes[2], true, false, 0);
			child_boxes[3] = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 10);
			child_boxes[3].pack_start(new Gtk.Label("频道密码（如果有）："), false, false, 0);
			this.password_entry = new Gtk.Entry();
			this.password_entry.set_visibility(false);
			this.password_entry.caps_lock_warning = true;
			this.password_entry.activate.connect(() => {
				if (this.app.poll_switch.get_active())
					this.app.poll_switch.set_active(false);
				else
					this.app.poll_switch.set_active(true);
			});
			child_boxes[3].pack_end(this.password_entry, true, true, 0);
			box.pack_start(child_boxes[3], true, false, 0);
			child_boxes[4] = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 10);
			child_boxes[4].pack_start(new Gtk.Label("弹幕显示时间（秒）："), false, false, 0);
			this.animate_time_entry = new Gtk.Entry();
			this.animate_time_entry.set_text("10");
			this.animate_time_entry.activate.connect(() => {
				if (this.app.poll_switch.get_active())
					this.app.poll_switch.set_active(false);
				else
					this.app.poll_switch.set_active(true);
			});
			child_boxes[4].pack_end(this.animate_time_entry, true, true, 0);
			box.pack_start(child_boxes[4], true, false, 0);
			child_boxes[5] = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 10);
			child_boxes[5].pack_start(new Gtk.Label("弹幕槽数："), false, false, 0);
			this.slot_length_entry = new Gtk.Entry();
			this.slot_length_entry.set_text("30");
			this.slot_length_entry.activate.connect(() => {
				if (this.app.poll_switch.get_active())
					this.app.poll_switch.set_active(false);
				else
					this.app.poll_switch.set_active(true);
			});
			child_boxes[5].pack_end(this.slot_length_entry, true, true, 0);
			box.pack_start(child_boxes[5], true, false, 0);
			this.app.status = new Gtk.Label("Code by AlynxZhou, GPLv3 License.");
			box.pack_end(this.app.status, false, true, 0);
			this.add(box);
			this.show_all();
		}
	}
}
