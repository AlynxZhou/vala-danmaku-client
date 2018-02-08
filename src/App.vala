namespace VDMKC {
	public class App : Gtk.Application {
		private Window window;
		public Gee.LinkedList<Danmaku> danmakus;
		public Gtk.Switch poll_switch;
		public Gtk.Label status;
		public Poller poller;
		public Canvas canvas;
		public int64 animate_time;
		public int slot_length;
		public int fps;
		public signal void alloc_danmaku(Danmaku danmaku);
		public App() {
			this.animate_time = 10 * 1000;
			this.slot_length = 30;
			this.fps = 30;
			this.danmakus = new Gee.LinkedList<Danmaku>();
		}
		protected override void activate() {
			window = new Window(this);
			this.add_window(window);
			window.show_all();
		}
	}
}
