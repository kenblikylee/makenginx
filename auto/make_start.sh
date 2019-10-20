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
$NGINX_INSTALL_DIR/sbin/nginx -T |  grep -v -E '^\s*#|^\s*$'

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

echo "created nginx-run script: start stop reload restart show  status  test help"
