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
					this.uri = "http://" + base_uri.strip() + "/api/channel/" + channel.strip() + "/danmaku";
				else
					this.uri = "http://" + base_uri.strip() + "api/channel/" + channel.strip() + "/danmaku";
			else
				if (!(base_uri.strip().has_suffix("/")))
					this.uri = base_uri.strip() + "/api/channel/" + channel.strip() + "/danmaku";
				else
					this.uri = base_uri.strip() + "api/channel/" + channel.strip() + "/danmaku";
			this.password = password;
			this.poll_offset = 0;
			this.session = new Soup.Session();
			this.poll = false;
		}
		public void start_poll() {
			this.poll = true;
			new Thread<int>("polling", () => {
				while (this.poll) {
					var message;
					if (this.poll_offset != 0)
						message = new Soup.Message("GET", this.uri + "?time=" + this.poll_offset.to_string());
					else
						message = new Soup.Message("GET", this.uri);
					message.request_headers.append("X-Danmaku-Auth-Key", this.password);
					this.session.send_message(message);
					var flatten_buffer = message.response_body.flatten();
					var parser = new Json.Parser();
					try {
						parser.load_from_data((string)flatten_buffer.data);
					} catch (Error e) {
						this.app.status.set_label("Error: %s".printf(e.message));
					}
					flatten_buffer.free();
					if (message.status_code != 200) {
						this.app.poll_switch.set_active(false);
						var error = parser.get_root().get_object();
						this.app.status.set_label("Error: %s %s: %s".printf(error.get_string_member("statusCode"), error.get_string_member("error"), error.get_string_member("message")));
						break;
					}
					var root_node = parser.get_root();
					if (root_node == null) {
						this.app.status.set_label("Warning: Invalid Node, continue.");
						continue;
					}
					var danmakus = root_node.get_array();
					var danmakus_length = danmakus.get_length();
					for (var i = 0; i < danmakus_length; ++i) {
						var danmaku = danmakus.get_object_element(i);
						var content = danmaku.get_string_member("content");
						var position = danmaku.get_string_member("position");
						var color = danmaku.get_string_member("color");
						var time = danmaku.get_int_member("time");
						this.app.status.set_label("Danmaku: content: %s, position: %s, color: %s".printf(content, position, color));
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
