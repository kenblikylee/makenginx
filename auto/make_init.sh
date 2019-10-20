cpu_num=$(cat /proc/cpuinfo | grep name | wc -l)
NGINX_CONF_FILE=$NGINX_INSTALL_DIR/conf/nginx.conf

cat << END > init
echo "detected ${cpu_num} cpu cores, init worker_processes to ${cpu_num} at config-file $NGINX_CONF_FILE ."

sed -i.backup "s/worker_processes\s*[0-9]*/worker_processes $cpu_num/" $NGINX_CONF_FILE

cat $NGINX_CONF_FILE | grep worker_processes

echo "backup config file to $NGINX_CONF_FILE.backup"

echo "check: cat $NGINX_CONF_FILE | grep worker_processes"

END

chmod u+x init
