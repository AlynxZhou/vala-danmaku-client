namespace VDMKC {
	public enum Position { TOP, FLY, BOTTOM }
	public enum Color { RED, GREEN, BLUE, BLACK, YELLOW, CYAN, PURPLE, WHITE }
	public class Danmaku {
		private App app;
		public string content;
		public Color color;
		public Position position;
		public int64 time;
		public int slot;
		private int64 display_time;
		private int64 start_display_time;
		public signal void close();
		public signal void left();
		public Danmaku(App app, string content, string color_str, string position_str, int64 time) {
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
			this.time = time;
		}
		public void set_context_rgba(Cairo.Context context, Color color) {
			switch (color) {
			case Color.RED:
				context.set_source_rgba(1, 0, 0, 0.9);
				break;
			case Color.GREEN:
				context.set_source_rgba(0, 1, 0, 0.9);
				break;
			case Color.BLUE:
				context.set_source_rgba(0, 0, 1, 0.9);
				break;
			case Color.BLACK:
				context.set_source_rgba(0, 0, 0, 0.9);
				break;
			case Color.YELLOW:
				context.set_source_rgba(1, 1, 0, 0.9);
				break;
			case Color.CYAN:
				context.set_source_rgba(0, 1, 1, 0.9);
				break;
			case Color.PURPLE:
				context.set_source_rgba(0.5, 0, 0.5, 0.9);
				break;
			case Color.WHITE:
				context.set_source_rgba(1, 1, 1, 0.9);
				break;
			}
		}
		public void start_display(int slot, int64 display_time) {
			this.slot = slot;
			this.display_time = display_time;
			this.start_display_time = get_real_time() / 1000;
		}
		public void draw(Cairo.Context context, int64 frame_time, int canvas_width, int canvas_height) {
			this.set_context_rgba(context, this.color);
			context.set_line_width(1);
			context.select_font_face("Noto Sans CJK SC Regular", Cairo.FontSlant.NORMAL, Cairo.FontWeight.BOLD);
			var font_size = canvas_height / this.app.slot_number;
			context.set_font_size(font_size);
			Cairo.TextExtents text_extents;
			context.text_extents(this.content, out text_extents);
			var y = font_size * this.slot - text_extents.y_bearing;
			if (this.position == Position.FLY) {
				var x = canvas_width - (double)(frame_time - this.start_display_time) / this.display_time * (canvas_width + text_extents.width);
				context.move_to(x, y);
				context.text_path(this.content);
				context.fill();
				if (this.color == Color.WHITE || this.color == Color.GREEN || this.color == Color.YELLOW || this.color == Color.CYAN) {
					this.set_context_rgba(context, Color.BLACK);
					context.move_to(x, y);
					context.text_path(this.content);
					context.stroke();
				}
				if (x + text_extents.width < canvas_width)
					this.left();
				if (frame_time - this.start_display_time > this.display_time)
					this.close();
			} else {
				var x = canvas_width / 2 - text_extents.width / 2;
				context.move_to(x, y);
				context.text_path(this.content);
				context.fill();
				if (this.color == Color.WHITE || this.color == Color.GREEN || this.color == Color.YELLOW || this.color == Color.CYAN) {
					this.set_context_rgba(context, Color.BLACK);
					context.move_to(x, y);
					context.text_path(this.content);
					context.stroke();
				}
				if (frame_time - this.start_display_time > this.display_time)
					this.close();
			}
		}
	}

}
