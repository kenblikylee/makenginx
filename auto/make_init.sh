cpu_num=$(cat /proc/cpuinfo | grep name | wc -l)

cat << END > init
echo "detected ${cpu_num} cpu cores, init worker_processes to ${cpu_num} at config-file $NGINX_CONF_FILE ."

sed -i.backup "s/worker_processes\s*[0-9]*/worker_processes $cpu_num/" $NGINX_CONF_FILE

cat $NGINX_CONF_FILE | grep worker_processes

echo "backup config file to $NGINX_CONF_FILE.backup"

echo "check: cat $NGINX_CONF_FILE | grep worker_processes"

./reload

END

chmod u+x init

cat << END > $NGINX_INSTALL_DIR/html/index.html

<!DOCTYPE html>
<html>
<head>
<title>makenginx</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1 style='text-align: center'>Welcome to nginx!</h1>
<p style='text-align: center'>powered by <a href='https://github.com/kenblikylee/makenginx' target='_blank'>makenginx</a></p>
</body>
</html>

END
