#!/bin/sh

mkdir -p /data/httpd.d
[ -e "/data/httpd.d/inotify" ] || touch /data/httpd.d/inotify
[ -e "/data/httpd.d/mod_dav_svn.conf" ] || cp mod_dav_svn.conf /data/httpd.d/mod_dav_svn.conf
chown -R rhodecode:rhodecode /data/httpd.d

# Reloads Apache when RhodeCode updates the configuration file
# Courtesy of https://stackoverflow.com/questions/12264238/restart-process-on-file-change-in-linux
reloadHttpd() {
	while true; do
		inotifywait --event modify --event attrib /data/httpd.d/inotify
		apachectl -k graceful
	done
}

reloadHttpd &
apachectl -DFOREGROUND
