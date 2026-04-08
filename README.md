# docker-php-5.2.17

Container with:

- PHP 5.2.17
- Apache 2.2.3
- Xdebug 2.1.7
- Zendopcache 7.0.5
- OpenSSL 0.9.8H

## Download
- Github:    `docker pull ghcr.io/jscottelblein/docker-php-5.2:latest`
- DockerHub: `docker pull jscottelblein/docker-php-5.2:latest`

## Usage
- DocumentRoot:               `/var/www/html/`
- Custom PHP Config:          `/opt/php-5.2.17/php.ini.d/`
- Custom Apache HTTPD Config: `/opt/httpd-2.2.3/conf.d/`
- OpCache Panel:              `http://localhost:8000/opcache/`

**Example:**
```bash
docker run --rm \
  -p 8000:80 \
  -e TZ=America/Chicago
  -e XDEBUG_REMOTE_ENABLE=1 \
  -e XDEBUG_REMOTE_HOST=host.docker.internal \
  -e XDEBUG_REMOTE_PORT=9000 \
  -e PHP_DISPLAY_ERRORS=on \
  -e PHP_HTML_ERRORS=on \
  -e PHP_LOG_ERRORS=on \
  -v .:/var/www/html \
  ghcr.io/jscottelblein/docker-php-5.2 
```

\* Things **removed** from the original image this was forked from:

- Oracle DB stuff (I never use it: MySQL and Postgres only)
- SSH
- All non-English locales

\* *The above were mostly removed to help shrink the image, it was pretty huge.*

Things **added** that were not in the original image:

- Some command-line tools (gzip, nano, ping, tar)
- New environment variables

```
TZ=<your locale: i.e. America/Chicago>
PHP_DISPLAY_ERRORS=off/on (default: off)
PHP_HTML_ERRORS=off/on    (default: off)
PHP_LOG_ERRORS=off/on     (default: on)
```

Things **changed** from the original image

- Apache documentat root changed to  `/var/www/html`
- Default PHP/System timezone is now `America/Chicago`

## Extra Note

I only needed this image for a small archival project I'm working on (an old Drupal 5 container), so things like SSH, multiple locales, Oracle DB weren't needed in my case and were only bloating the image size. If you want the original, unaltered image with all those things still in it use the imagine I forked this off of.
