/* main.vala
 *
 * Copyright (C) 2018 AlynxZhou
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

int main (string[] args) {
	if (!Thread.supported()) {
	        stderr.printf("Cannot run without thread support.\n");
	        return 1;
	}
	// Window hint won't work in GNOME/Wayland 3.26, use XWayland instead.
	if (Environment.get_variable("XDG_SESSION_TYPE") == "wayland")
		Environment.set_variable("GDK_BACKEND", "x11", false);
	return new VDMKC.App().run(args);
}
