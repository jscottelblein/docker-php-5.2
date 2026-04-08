#!/bin/bash

# Prevent user from inputting garbage like "banana"
normalize_onoff() {
    case "$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')" in
        1|on|yes|true) echo "On" ;;
        0|off|no|false|'') echo "Off" ;;
        *) echo "Off" ;;
    esac
}

# Use the Docker Run/Compose Environment variables for the PHP error logging
PHP_DISPLAY_ERRORS="$(normalize_onoff "${PHP_DISPLAY_ERRORS:-Off}")"
PHP_HTML_ERRORS="$(normalize_onoff "${PHP_HTML_ERRORS:-Off}")"
PHP_LOG_ERRORS="$(normalize_onoff "${PHP_LOG_ERRORS:-On}")"

cat > /opt/php-5.2.17/php.ini.d/01-runtime-errors.ini <<EOF
display_errors = ${PHP_DISPLAY_ERRORS}
html_errors = ${PHP_HTML_ERRORS}
log_errors = ${PHP_LOG_ERRORS}
EOF

# Remove the httpd.pid file if it exists, and create empty log files for Apache and PHP to ensure
# they exist and are writable by the container's processes. Then start the necessary services and
# tail the logs to keep the container running and provide real-time logging output.
rm -rf /opt/httpd-2.2.3/logs/httpd.pid
echo "" > /var/log/php/error.log
echo "" > /var/log/php/xdebug.log
echo "" > /var/log/apache/access_log
echo "" > /var/log/apache/error_log

# Start the services and tail the logs. The Apache logs are sent to stdout and stderr.
tail -f /var/log/apache/access_log > /dev/stdout & \
tail -f /var/log/php/error.log /var/log/apache/error_log > /dev/stderr & \
/opt/httpd-2.2.3/bin/apachectl -D FOREGROUND
