# RhodeCode Subversion Backend

This is still work in progress.

Dockerfile for a Subversion backend for [RhodeCode Community Edition](https://rhodecode.com/open-source) and [RhodeCode Enterprise Edition](https://docs.rhodecode.com/RhodeCode-Enterprise/).

For more details, see <https://docs.rhodecode.com/RhodeCode-Enterprise/admin/svn-http.html>.

## Supported Tags

- latest

## Usage

The following steps are required to add SVN support to your RhodeCode stack from  the example described in [ckulka/rhodecode-rccontrol](https://github.com/ckulka/rhodecode-rccontrol)

1. Configure the container volumes
1. Configure SVN in RhodeCode CE/EE

```yaml
version: "3"

services:
  db:
    image: postgres:alpine
    environment:
      POSTGRES_PASSWORD: cookiemonster

  vcsserver:
    image: ckulka/rhodecode-vcsserver
    volumes:
      - repos:/data

  rhodecode:
    image: ckulka/rhodecode-ce
    environment:
      RC_DB: postgresql://postgres:cookiemonster@db
      RC_CONFIG:
        [app:main]
        vcs.server.enable = true
        vcs.server = vcsserver:9900

        svn.proxy.generate_config = true
        svn.proxy.list_parent_path = true
        svn.proxy.config_file_path = /data/httpd.d/mod_dav_svn.conf
        svn.proxy.location_root = /
        svn.proxy.reload_cmd = touch /data/httpd.d/inotify
    ports:
      - "5000:5000"
    links:
      - db
      - vcsserver
    volumes:
      - repos:/data

  svn:
    image: ckulka/rhodecode-svnbackend
    volumes:
      - repos:/data

volumes:
  repos:
```

See [example/docker-compose.yaml](https://github.com/ckulka/rhodecode-svnbackend/blob/master/example/docker-compose.yaml) for a complete example including volumes for persistence.
