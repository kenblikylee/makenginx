
# Copyright (C) kenblikylee
# Copyright (C) kenblog.top

NGINX_CONFD=$NGINX_INSTALL_DIR/conf
NGINX_CONF_FILE=$NGINX_CONFD/nginx.conf
MAKENGINX_CONFD=$NGINX_INSTALL_DIR/conf/makenginx_servers

. auto/make_file.sh
. auto/make_install.sh
. auto/make_init.sh
. auto/make_start.sh
. auto/make_conf.sh
