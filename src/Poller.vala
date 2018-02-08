namespace VDMKC {
	public class Poller {
		private App app;
		private Soup.Session session;
		private string uri;
		private string? password;
		private int64 poll_offset;
		private bool poll;
		public Poller(App app, string base_uri, string channel, string? password) {
			this.app = app;
			if (!(base_uri.strip().has_prefix("http://") || base_uri.strip().has_prefix("https://")))
				if (!(base_uri.strip().has_suffix("/")))
					this.uri = "http://" + base_uri.strip() + "/api/channel/" + channel + "/danmaku";
				else
					this.uri = "http://" + base_uri.strip() + "api/channel/" + channel + "/danmaku";
			else
				if (!(base_uri.strip().has_suffix("/")))
					this.uri = base_uri.strip() + "/api/channel/" + channel + "/danmaku";
				else
					this.uri = base_uri.strip() + "api/channel/" + channel + "/danmaku";
			this.password = password;
			this.poll_offset = get_real_time() / 1000;
			this.session = new Soup.Session();
			this.poll = false;
		}
		public void start_poll() {
			this.poll = true;
			new Thread<int>("polling", () => {
				while (this.poll) {
					var message = new Soup.Message("GET", this.uri + "?time=" + this.poll_offset.to_string());
					message.request_headers.append("X-Danmaku-Auth-Key", this.password);
					this.session.send_message(message);
					var flatten_buffer = message.response_body.flatten();
					var parser = new Json.Parser();
					try {
						parser.load_from_data((string)flatten_buffer.data);
					} catch (Error e) {
						stderr.printf("%s\n", e.message);
					}
					flatten_buffer.free();
					var danmakus = parser.get_root().get_array();
					var danmakus_length = danmakus.get_length();
					for (var i = 0; i < danmakus_length; ++i) {
						var danmaku = danmakus.get_object_element(i);
						var content = danmaku.get_string_member("content");
						var position = danmaku.get_string_member("position");
						var color = danmaku.get_string_member("color");
						var time = danmaku.get_int_member("time");
						stdout.printf("New Danmaku: content: %s, position: %s, color: %s, time: %s\n", content, position, color, time.to_string());
						this.app.alloc_danmaku(new Danmaku(this.app, content, color, position, time));
						if (time >= this.poll_offset)
							this.poll_offset = time + 1;
					}
					Thread.usleep(500 * 1000);
				}
				Thread.exit(0);
				return 0;
			});
		}
		public void stop_poll() {
			this.poll = false;
		}
	}
}
