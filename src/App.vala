namespace VDMKC {
	public class App : Gtk.Application {
		private Window window;
		public Gee.LinkedList<Danmaku> danmakus;
		public Poller poller;
		public Canvas canvas;
		public int64 animate_time;
		public int slot_length;
		public signal void alloc_danmaku(Danmaku danmaku);
		public App() {
			this.animate_time = 10 * 1000;
			this.slot_length = 30;
			this.danmakus = new Gee.LinkedList<Danmaku>();
		}
		protected override void activate() {
			window = new Window(this);
			window.show_all();
		}
	}
}
