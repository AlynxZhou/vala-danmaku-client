namespace VDMKC {
	public class Canvas : Gtk.Window {
		private App app;
		private Gtk.DrawingArea danmaku_area;
		private int slot_length;
		private bool[] fly_slots;
		private bool[] fix_slots;
		private Rand rand;
		public Canvas(App app) {
			this.app = app;
			this.set_title("VDMKC.Canvas");
			// Disable window border.
			this.set_decorated(false);
			// Hide window in overview (just hint).
			this.set_focus_on_map(false);
			this.set_skip_pager_hint(true);
			this.set_skip_taskbar_hint(true);
			this.set_accept_focus(false);
			// Set window size
			var geometry = this.get_screen().get_display().get_monitor(0).get_geometry();
			this.set_default_size(geometry.width, geometry.height);
			this.set_transparent_visual();
			((Gtk.Widget)this).set_app_paintable(true);
			((Gtk.Widget)this).draw.connect(this.on_transparent_draw);
			// fullscreen();
			this.set_input_through();
			this.set_keep_above(true);
			// Set always on visible workspace.
			this.stick();
			this.slot_length = this.app.slot_length;
			this.fly_slots = new bool[this.slot_length];
			this.fix_slots = new bool[this.slot_length];
			for (var i = 0; i < this.slot_length; ++i) {
				this.fly_slots[i] = false;
				this.fix_slots[i] = false;
			}
			this.danmaku_area = new Gtk.DrawingArea();
			// Animate.
			const int fps = 30;
			Timeout.add(1000 / fps, () => {
				this.danmaku_area.queue_draw();
				return true;
			});
			this.danmaku_area.draw.connect(this.on_draw);
			this.add(this.danmaku_area);
			this.rand = new Rand.with_seed((uint8)(get_real_time() / 1000));
			this.app.alloc_danmaku.connect(on_alloc_danmaku);
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
		public bool on_transparent_draw(Cairo.Context context) {
			context.set_source_rgba(1, 1, 1, 0);
			context.set_operator(Cairo.Operator.SOURCE);
			context.paint();
			context.set_operator(Cairo.Operator.OVER);
			return false;
		}
		public bool on_draw(Cairo.Context context) {
			int width = this.danmaku_area.get_allocated_width();
			int height = this.danmaku_area.get_allocated_height();
			int64 time = get_real_time() / 1000;
			for (var i = 0; i < this.app.danmakus.size; ++i)
				this.app.danmakus.@get(i).draw(context, time, width, height);
			return false;
		}
		public void on_alloc_danmaku(App app, Danmaku danmaku) {
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
			switch (danmaku.position) {
			case Position.TOP:
				for (var i = 0; i < this.slot_length; ++i) {
					if (!this.fix_slots[i]) {
						this.fix_slots[i] = true;
						danmaku.start_display(i, this.app.animate_time);
						return;
					}
				}
				int slot = this.rand.int_range(0, this.slot_length);
				this.fix_slots[slot] = true;
				danmaku.start_display(slot, this.app.animate_time);
				return;
				break;
			case Position.BOTTOM:
				for (var i = this.slot_length; i >= 0; --i) {
					if (!this.fix_slots[i]) {
						this.fix_slots[i] = true;
						danmaku.start_display(i, this.app.animate_time);
						return;
					}
				}
				int slot = this.rand.int_range(0, this.slot_length);
				this.fix_slots[slot] = true;
				danmaku.start_display(slot, this.app.animate_time);
				return;
				break;
			case Position.FLY:
				for (var i = 0; i < this.slot_length; ++i) {
					if (!this.fly_slots[i]) {
						this.fly_slots[i] = true;
						danmaku.start_display(i, this.app.animate_time);
						return;
					}
				}
				int slot = this.rand.int_range(0, this.slot_length);
				this.fly_slots[slot] = true;
				danmaku.start_display(slot, this.app.animate_time);
				return;
				break;
			}
		}
	}
}
