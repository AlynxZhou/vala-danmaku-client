/*
 * main.vala
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

[CCode(cname="GETTEXT_PACKAGE")]
extern const string GETTEXT_PACKAGE;

int main(string[] args) {
	Intl.setlocale(LocaleCategory.MESSAGES, "");
	Intl.bind_textdomain_codeset(GETTEXT_PACKAGE, "utf-8");
	Intl.bindtextdomain(GETTEXT_PACKAGE, "locale");
	if (!Thread.supported()) {
	        stderr.printf(_("Cannot run without thread support.\n"));
	        return 1;
	}
	// Window hint won't work in GNOME/Wayland 3.26, use XWayland instead.
	if (Environment.get_variable("XDG_SESSION_TYPE") == "wayland")
		Environment.set_variable("GDK_BACKEND", "x11", true);
	var result = new VDMKC.App().run(args);
	Environment.unset_variable("GDK_BACKEND");
	return result;
}
