cat << END > start
$NGINX_INSTALL_DIR/sbin/nginx

END

chmod u+x start

cat << END > reload
$NGINX_INSTALL_DIR/sbin/nginx -s reload

END

chmod u+x reload

cat << END > stop
$NGINX_INSTALL_DIR/sbin/nginx -s quit

END

chmod u+x stop

cat << END > restart
$NGINX_INSTALL_DIR/sbin/nginx -s reopen

END

chmod u+x restart

cat << END > test
$NGINX_INSTALL_DIR/sbin/nginx -t
curl localhost

END

chmod u+x test

cat << END > show

if [[ \$1 != app ]]; then
  $NGINX_INSTALL_DIR/sbin/nginx -T |  grep -v -E '^\s*#|^\s*$'
  exit 0
fi

for appconf in \$(ls $MAKENGINX_CONFD)
do
  echo \${appconf%.conf}
done

END

chmod u+x show

cat << END > help
$NGINX_INSTALL_DIR/sbin/nginx -h

END

chmod u+x help

cat << END > status
ps aufx | grep nginx | grep -v -E 'color=auto|grep'
netstat -lnp | grep nginx

END

chmod u+x status

cat << END > version
$NGINX_INSTALL_DIR/sbin/nginx -v

END

chmod u+x version

# 日志
cat << END > log
t=\${1:-''}

if [ \$t = 'error' ]; then
    cat $NGINX_INSTALL_DIR/logs/error.log
elif [ \$t = 'access' ]; then
    cat $NGINX_INSTALL_DIR/logs/access.log
else
    echo "ls $NGINX_INSTALL_DIR/logs"
    ls $NGINX_INSTALL_DIR/logs
    echo "usage: ./log [error|access]"
fi

END

chmod u+x log

echo "created nginx-run script: start stop reload restart show  status  test help"
