FROM ubuntu:16.10
LABEL maintainer="cyrill.kulka@gmail.com"

RUN apt-get update && apt-get install -y	\
			apache2 						\
			libapache2-mod-svn				\
			inotify-tools					\
		&& rm -rf /var/lib/apt/lists/*		\
		&& a2enmod dav_svn					\
		&& a2enmod headers					\
		&& a2enmod authn_anon

COPY files/000-default.conf /etc/apache2/sites-enabled/000-default.conf

RUN useradd rhodecode -u 1000 -s /sbin/nologin	\
		&& sed -i 's/www-data/rhodecode/' /etc/apache2/envvars

COPY files .

EXPOSE 80
CMD [ "bash", "./start.sh" ]
