#!/bin/bash
# Use the exec command to start the app you want to run in this container.
# Don't let the app daemonize itself.
# `/sbin/setuser memcache` runs the given command as the user `memcache`.
# If you omit that part, the command will be run as root.
# Read more here: https://github.com/phusion/baseimage-docker#adding-additional-daemons'

# Replace variables in the varnish config file

replace_vars() {
  OUTPUT=$(echo $1 | sed -e 's/.source//');
  SOURCE=$1

  eval "cat <<EOF
  $(<$SOURCE)
EOF
  " > $OUTPUT
}


if [ -e "$VCL_FILE.source" ]
then
  replace_vars "$VCL_FILE.source"
fi

cat $VCL_FILE

# Starts the varnish server
#echo "Running varnishd -a ${LISTEN_ADDR:$LISTEN_PORT} -T ${TELNET_ADDR}:${TELNET_PORT} -f ${VCL_FILE} -s file,/var/cache/varnish.cache,${CACHE_SIZE} -F ; ldconfig ; varnishncsa"
# Run it
#exec varnishd -a "$LISTEN_ADDR:$LISTEN_PORT" -T $TELNET_ADDR:$TELNET_PORT -f "$VCL_FILE" -s "file,/var/cache/varnish.cache,$CACHE_SIZE" -F ; ldconfig ; varnishncsa

exec varnishd -F -f $VCL_FILE