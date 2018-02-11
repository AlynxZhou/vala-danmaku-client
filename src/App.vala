namespace VDMKC {
	public class App : Gtk.Application {
		private Window window;
		public Gee.LinkedList<Danmaku> danmakus;
		public Gtk.Switch poll_switch;
		public Gtk.Label status;
		public Poller poller;
		public Gee.ArrayList<Canvas> canvases;
		public int64 display_time;
		public int slot_number;
		public int fps;
		public signal void alloc_danmaku(Danmaku danmaku);
		public App() {
			this.display_time = 10 * 1000;
			this.slot_number = 18;
			this.fps = 60;
			this.danmakus = new Gee.LinkedList<Danmaku>();
			this.canvases = new Gee.ArrayList<Canvas>();
		}
		protected override void activate() {
			window = new Window(this);
			this.add_window(window);
			window.show_all();
		}
	}
}
