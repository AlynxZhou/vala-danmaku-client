namespace VDMKC {
	public class Window : Gtk.ApplicationWindow {
		private App app;
		private Gtk.Entry server_entry;
		private Gtk.Entry channel_entry;
		private Gtk.Entry password_entry;
		private Gtk.Entry display_time_entry;
		private Gtk.Entry slot_number_entry;
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
			child_boxes[0].pack_start(new Gtk.Label(_("Switch: ")), false, false, 0);
			this.app.poll_switch = new Gtk.Switch();
			this.app.poll_switch.set_active(false);
			this.app.poll_switch.notify["active"].connect(() => {
				if (this.app.poll_switch.get_active()) {
					this.server_entry.set_editable(false);
					this.channel_entry.set_editable(false);
					this.password_entry.set_editable(false);
					this.display_time_entry.set_editable(false);
					this.slot_number_entry.set_editable(false);
					this.app.status.set_label(_("Code by AlynxZhou, GPLv3 License."));
					this.app.display_time = (int64)(double.parse(this.display_time_entry.get_text()) * 1000);
					if (this.app.display_time < 1000) {
						this.app.display_time = 10 * 1000;
						this.display_time_entry.set_text((this.app.display_time / 1000).to_string());
						this.app.status.set_label(_("Display time too short and set it to default 10s!"));
					}
					this.app.slot_number = int.parse(this.slot_number_entry.get_text());
					this.app.poller = new Poller(this.app, this.server_entry.get_text(), this.channel_entry.get_text(), this.password_entry.get_text());
					this.app.poller.start_poll();
					var monitor_count = this.get_screen().get_display().get_n_monitors();
					for (var i = 0; i < monitor_count; ++i) {
						var canvas = new Canvas(this.app, i);
						this.app.canvases.add(canvas);
						canvas.show_all();
					}
				} else {
					for (var i = 0; i < this.app.canvases.size; ++i)
						this.app.canvases.@get(i).close();
					this.app.canvases.clear();
					this.app.danmakus.clear();
					this.app.poller.stop_poll();
					this.app.poller = null;
					this.server_entry.set_editable(true);
					this.channel_entry.set_editable(true);
					this.password_entry.set_editable(true);
					this.display_time_entry.set_editable(true);
					this.slot_number_entry.set_editable(true);
				}
			});
			child_boxes[0].pack_end(this.app.poll_switch, true, false, 0);
			box.pack_start(child_boxes[0], true, false, 0);
			child_boxes[1] = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 10);
			child_boxes[1].pack_start(new Gtk.Label(_("Server Link: ")), false, false, 0);
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
			child_boxes[2].pack_start(new Gtk.Label(_("Channel Name: ")), false, false, 0);
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
			child_boxes[3].pack_start(new Gtk.Label(_("Channel Password (If have): ")), false, false, 0);
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
			child_boxes[4].pack_start(new Gtk.Label(_("Danmaku Display Time (Second): ")), false, false, 0);
			this.display_time_entry = new Gtk.Entry();
			this.display_time_entry.set_text((this.app.display_time / 1000).to_string());
			this.display_time_entry.activate.connect(() => {
				if (this.app.poll_switch.get_active())
					this.app.poll_switch.set_active(false);
				else
					this.app.poll_switch.set_active(true);
			});
			child_boxes[4].pack_end(this.display_time_entry, true, true, 0);
			box.pack_start(child_boxes[4], true, false, 0);
			child_boxes[5] = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 10);
			child_boxes[5].pack_start(new Gtk.Label(_("Danmaku Slot Number: ")), false, false, 0);
			this.slot_number_entry = new Gtk.Entry();
			this.slot_number_entry.set_text(this.app.slot_number.to_string());
			this.slot_number_entry.activate.connect(() => {
				if (this.app.poll_switch.get_active())
					this.app.poll_switch.set_active(false);
				else
					this.app.poll_switch.set_active(true);
			});
			child_boxes[5].pack_end(this.slot_number_entry, true, true, 0);
			box.pack_start(child_boxes[5], true, false, 0);
			this.app.status = new Gtk.Label(_("Code by AlynxZhou, GPLv3 License."));
			this.app.status.set_ellipsize(Pango.EllipsizeMode.END);
			box.pack_end(this.app.status, false, false, 0);
			this.add(box);
		}
	}
}
