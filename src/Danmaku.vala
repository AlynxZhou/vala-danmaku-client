namespace VDMKC {
	public enum Position { TOP, FLY, BOTTOM }
	public enum Color { RED, GREEN, BLUE, BLACK, YELLOW, CYAN, PURPLE, WHITE }
	public class Danmaku {
		private App app;
		public string content;
		public Color color;
		public Position position;
		public int64 offset;
		public int slot;
		private int64 display_time;
		private int64 start_display_time;
		public signal void close();
		public signal void left();
		public Danmaku(App app, string content, string color_str, string position_str, int64 offset) {
			this.app = app;
			this.content = content;
			switch (color_str) {
			case "red":
				this.color = Color.RED;
				break;
			case "green":
				this.color = Color.GREEN;
				break;
			case "blue":
				this.color = Color.BLUE;
				break;
			case "black":
				this.color = Color.BLACK;
				break;
			case "yellow":
				this.color = Color.YELLOW;
				break;
			case "cyan":
				this.color = Color.CYAN;
				break;
			case "purple":
				this.color = Color.PURPLE;
				break;
			default:
				this.color = Color.WHITE;
				break;
			}
			switch (position_str) {
			case "top":
				this.position = Position.TOP;
				break;
			case "bottom":
				this.position = Position.BOTTOM;
				break;
			default:
				this.position = Position.FLY;
				break;
			}
			this.offset = offset;
		}
		public void set_context_rgba(Cairo.Context context, Color color) {
			switch (color) {
			case Color.RED:
				context.set_source_rgba(1, 0, 0, 1);
				break;
			case Color.GREEN:
				context.set_source_rgba(0, 0.8, 0, 1);
				break;
			case Color.BLUE:
				context.set_source_rgba(0, 0, 1, 1);
				break;
			case Color.BLACK:
				context.set_source_rgba(0, 0, 0, 1);
				break;
			case Color.YELLOW:
				context.set_source_rgba(0.9, 0.7, 0, 1);
				break;
			case Color.CYAN:
				context.set_source_rgba(0, 0.7, 0.9, 1);
				break;
			case Color.PURPLE:
				context.set_source_rgba(0.5, 0, 0.5, 1);
				break;
			case Color.WHITE:
				context.set_source_rgba(1, 1, 1, 1);
				break;
			}
		}
		public void start_display(int slot, int64 display_time) {
			this.slot = slot;
			this.display_time = display_time;
			this.start_display_time = get_real_time() / 1000;
		}
		public void draw(Cairo.Context context, Pango.Layout layout, int64 frame_time, int canvas_width, int canvas_height, int font_size) {
			layout.set_text(this.content, -1);
			Pango.Rectangle text_extents;
			layout.get_pixel_extents(out text_extents, null);
			int y = font_size * this.slot + (font_size - text_extents.height) / 2 - text_extents.y;
			if (this.position == Position.FLY) {
				int x = canvas_width - (int)((frame_time - this.start_display_time) * (canvas_width + text_extents.width) / this.display_time) - text_extents.x;
				if (this.color == Color.WHITE) {
					this.set_context_rgba(context, Color.BLACK);
					context.move_to(x + font_size / 40, y + font_size / 40);
					Pango.cairo_show_layout(context, layout);
					context.move_to(x + font_size / 40, y - font_size / 40);
					Pango.cairo_show_layout(context, layout);
					context.move_to(x - font_size / 40, y + font_size / 40);
					Pango.cairo_show_layout(context, layout);
					context.move_to(x - font_size / 40, y - font_size / 40);
					Pango.cairo_show_layout(context, layout);
				}
				if (this.color == Color.BLACK) {
					this.set_context_rgba(context, Color.WHITE);
					context.move_to(x + font_size / 40, y + font_size / 40);
					Pango.cairo_show_layout(context, layout);
					context.move_to(x + font_size / 40, y - font_size / 40);
					Pango.cairo_show_layout(context, layout);
					context.move_to(x - font_size / 40, y + font_size / 40);
					Pango.cairo_show_layout(context, layout);
					context.move_to(x - font_size / 40, y - font_size / 40);
					Pango.cairo_show_layout(context, layout);
				}
				this.set_context_rgba(context, this.color);
				context.move_to(x, y);
				Pango.cairo_show_layout(context, layout);
				if (x + text_extents.width < canvas_width)
					this.left();
				if (frame_time - this.start_display_time > this.display_time || x + text_extents.width < 0)
					this.close();
			} else {
				int x = canvas_width / 2 - text_extents.width / 2 - text_extents.x;
				if (this.color == Color.WHITE) {
					this.set_context_rgba(context, Color.BLACK);
					context.move_to(x + font_size / 40, y + font_size / 40);
					Pango.cairo_show_layout(context, layout);
					context.move_to(x + font_size / 40, y - font_size / 40);
					Pango.cairo_show_layout(context, layout);
					context.move_to(x - font_size / 40, y + font_size / 40);
					Pango.cairo_show_layout(context, layout);
					context.move_to(x - font_size / 40, y - font_size / 40);
					Pango.cairo_show_layout(context, layout);
				}
				if (this.color == Color.BLACK) {
					this.set_context_rgba(context, Color.WHITE);
					context.move_to(x + font_size / 40, y + font_size / 40);
					Pango.cairo_show_layout(context, layout);
					context.move_to(x + font_size / 40, y - font_size / 40);
					Pango.cairo_show_layout(context, layout);
					context.move_to(x - font_size / 40, y + font_size / 40);
					Pango.cairo_show_layout(context, layout);
					context.move_to(x - font_size / 40, y - font_size / 40);
					Pango.cairo_show_layout(context, layout);
				}
				this.set_context_rgba(context, this.color);
				context.move_to(x, y);
				Pango.cairo_show_layout(context, layout);
				if (frame_time - this.start_display_time > this.display_time || x + text_extents.width < 0)
					this.close();
			}
		}
	}

}
