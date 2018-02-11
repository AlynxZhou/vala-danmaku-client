namespace VDMKC {
	public class Canvas : Gtk.Window {
		private App app;
		private bool[] fly_slots;
		private bool[] fix_slots;
		private Rand rand;
		private Pango.FontDescription font_desc;
		public Canvas(App app, int mon) {
			this.app = app;
			this.set_title("VDMKC.Canvas");
			this.set_icon_name("preferences-desktop-screensaver");
			// Disable window border.
			this.set_decorated(false);
			// Hide window in overview (just hint).
			this.set_focus_on_map(false);
			this.set_skip_pager_hint(true);
			this.set_skip_taskbar_hint(true);
			this.set_accept_focus(false);
			this.set_position(Gtk.WindowPosition.CENTER);
			this.set_gravity(Gdk.Gravity.NORTH_WEST);
			this.set_to_monitor(mon);
			this.set_input_through();
			this.set_keep_above(true);
			// Set always on visible workspace.
			this.stick();
			// Do NOT use Gtk.Widget.set_opacity(0) because it will make the whole window including DrawingArea transparent.
			// ((Gtk.Widget)this).set_opacity(0);
			this.set_transparent_visual();
			this.font_desc = new Pango.FontDescription();
			this.font_desc.set_family("Sans");
			this.font_desc.set_weight(Pango.Weight.BOLD);
			// Keep animation.
			((Gtk.Widget)this).set_app_paintable(true);
			((Gtk.Widget)this).draw.connect((context) => {
				context.set_source_rgba(1, 1, 1, 0);
				context.set_operator(Cairo.Operator.SOURCE);
				context.paint();
				int width = this.get_allocated_width();
				int height = this.get_allocated_height();
				int64 time = get_real_time() / 1000;
				var font_size = height / this.app.slot_number;
				this.font_desc.set_absolute_size(font_size * Pango.SCALE);
				var layout = Pango.cairo_create_layout(context);
				layout.set_font_description(this.font_desc);
				layout.set_ellipsize(Pango.EllipsizeMode.NONE);
				layout.set_width(-1);
				layout.set_spacing(0);
				for (var i = 0; i < this.app.danmakus.size; ++i)
					this.app.danmakus.@get(i).draw(context, layout, time, width, height, font_size);
				Thread.usleep(1000 * 1000 / this.app.fps);
				this.queue_draw();
				this.set_keep_above(true);
				return false;
			});
			this.fly_slots = new bool[this.app.slot_number];
			this.fix_slots = new bool[this.app.slot_number];
			for (var i = 0; i < this.app.slot_number; ++i) {
				this.fly_slots[i] = false;
				this.fix_slots[i] = false;
			}
			this.rand = new Rand.with_seed((uint8)(get_real_time() / 1000));
			this.app.alloc_danmaku.connect((app, danmaku) => {
				this.app.danmakus.add(danmaku);
				danmaku.close.connect((danmaku) => {
					if (danmaku.position != Position.FLY)
						this.fix_slots[danmaku.slot] = false;
					this.app.danmakus.remove(danmaku);
				});
				danmaku.left.connect((danmaku) => {
					if (danmaku.position == Position.FLY)
						this.fly_slots[danmaku.slot] = false;
				});
				var full = true;
				switch (danmaku.position) {
				case Position.TOP:
					for (var i = 0; i < this.app.slot_number; ++i) {
						if (!this.fix_slots[i]) {
							this.fix_slots[i] = true;
							danmaku.start_display(i, this.app.display_time);
							full = false;
							break;
						}
					}
					if (full) {
						int slot = this.rand.int_range(0, this.app.slot_number);
						this.fix_slots[slot] = true;
						danmaku.start_display(slot, this.app.display_time);
					}
					break;
				case Position.BOTTOM:
					for (var i = this.app.slot_number - 1; i >= 0; --i) {
						if (!this.fix_slots[i]) {
							this.fix_slots[i] = true;
							danmaku.start_display(i, this.app.display_time);
							full = false;
							break;
						}
					}
					if (full) {
						int slot = this.rand.int_range(0, this.app.slot_number);
						this.fix_slots[slot] = true;
						danmaku.start_display(slot, this.app.display_time);
					}
					break;
				case Position.FLY:
					for (var i = 3; i < this.app.slot_number + 3; ++i) {
						if (i >= this.app.slot_number)
							i %= this.app.slot_number;
						if (!this.fly_slots[i]) {
							this.fly_slots[i] = true;
							danmaku.start_display(i, this.app.display_time);
							full = false;
							break;
						}
					}
					if (full) {
						int slot = this.rand.int_range(0, this.app.slot_number);
						this.fly_slots[slot] = true;
						danmaku.start_display(slot, this.app.display_time);
					}
					break;
				}
			});
		}
		public void set_transparent_visual() {
			var screen = this.get_screen();
			var visual = screen.get_rgba_visual();
			if (visual == null)
				visual = screen.get_system_visual();
			this.set_visual(visual);
		}
		public void set_input_through() {
			Cairo.RectangleInt rect = { 0, 0, 1, 1 };
			var region = new Cairo.Region.rectangle(rect);
			if (!region.is_empty()) {
				((Gtk.Widget)this).input_shape_combine_region(null);
				((Gtk.Widget)this).input_shape_combine_region(region);
			}
		}
		public void set_to_monitor(int mon) {
			int x;
			int y;
			this.get_position(out x, out y);
			var geometry = this.get_screen().get_display().get_monitor(mon).get_geometry();
			x += geometry.x;
			y += geometry.y;
			this.move(x, y);
			this.set_default_size(geometry.width, geometry.height);
			this.maximize();
		}
	}
}
