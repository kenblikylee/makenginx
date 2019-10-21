# 配置与默认配置差异
cat << END > diffconf
git diff $NGINX_CONF_FILE.default $NGINX_CONF_FILE

END

chmod u+x diffconf

# 复制当前使用配置到当前目录
cat << END > cpconf
cp $NGINX_CONF_FILE .

END

chmod u+x cpconf

# 自动初始化配置
cat $NGINX_CONF_FILE.default > $NGINX_CONF_FILE
test -d $MAKENGINX_CONFD || mkdir $MAKENGINX_CONFD
sed -i '$ i\    include makenginx_servers/*.conf;' $NGINX_CONF_FILE

# 添加服务
cat << XEND > addser

APP=\${1:-''}
HOST=\${2:-'localhost'}
PORT=\${3:-'80'}

if [ ! \$APP ]; then
    echo "usage: ./addser <app> <domain> [port(default: 80)]"
    exit 0
fi

ROOT_DIR=$INSTALL_ROOT_DIR/www/\$APP
test -d \$ROOT_DIR || mkdir -p \$ROOT_DIR

cat << END > \$ROOT_DIR/index.html

<!DOCTYPE html>
<html>
<head>
<title>\$APP</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1 style='text-align: center'>\$APP</h1>
<p style='text-align: center'>powered by <a href='https://github.com/kenblikylee/makenginx' target='_blank'>makenginx</a></p>
</body>
</html>

END

echo -e "\n" > "$MAKENGINX_CONFD/\$APP.conf"
sed -i -f ./auto/sed/add_server $MAKENGINX_CONFD/\$APP.conf

sed -i -e "s/\[host\]/\$HOST/" $MAKENGINX_CONFD/\$APP.conf
sed -i -e "s~\[root\]~\$ROOT_DIR~" $MAKENGINX_CONFD/\$APP.conf
sed -i -e "s/\[port\]/\$PORT/" $MAKENGINX_CONFD/\$APP.conf

cat $MAKENGINX_CONFD/\$APP.conf

XEND

chmod u+x addser

# 移除服务，备份在 ~/.makenginx/rm 目录下
test -d ~/.makenginx/rm || mkdir -p ~/.makenginx/rm

cat << XEND > rmser

APP=\${1:-''}

if [ ! \$APP ]; then
    echo "usage: ./rmser <app>"
    exit 0
fi

BACKUP_DIR=~/.makenginx/rm/\$APP

test -d \$BACKUP_DIR && rm -rf \$BACKUP_DIR

mkdir \$BACKUP_DIR

mv $MAKENGINX_CONFD/\$APP.conf \$BACKUP_DIR
mv $INSTALL_ROOT_DIR/www/\$APP \$BACKUP_DIR

XEND

chmod u+x rmser

# 添加 location
cat << XEND > addloc

if [ \$# -lt 3 ]; then
    echo "usage: ./addloc <toapp> <uri> <rootdir>"
    exit 0
fi

APP=\${1:-''}
URI=\${2:-''}
ROOTDIR=\${3:-''}

APP_CONF=$MAKENGINX_CONFD/\$APP.conf

if [ ! -f \$APP_CONF ]; then
    echo "\$APP not exist, please create it with addser first."
    exit 0
fi

sed -i -f ./auto/sed/add_location \$APP_CONF

sed -i -e "s@\[uri\]@\$URI@" \$APP_CONF
sed -i -e "s~\[rootdir\]~\$ROOTDIR~" \$APP_CONF

cat \$APP_CONF

XEND

chmod u+x addloc


# 移除 location
cat << XEND > rmloc

if [ \$# -lt 2 ]; then
    echo "usage: ./rmloc <app> <uri>"
    exit 0
fi

APP=\${1:-''}
URI=\${2:-''}

APP_CONF=$MAKENGINX_CONFD/\$APP.conf

if [ ! -f \$APP_CONF ]; then
    echo "\$APP not exist, please create it with addser first."
    exit 0
fi

sed -i -e "/\$URI/,/}/ d" \$APP_CONF

cat \$APP_CONF

XEND

chmod u+x rmloc

# 增加反向代理

cat << XEND > addproxy

if [ \$# -lt 3 ]; then
    echo "usage: ./addloc <toapp> <uri> <proxy>"
    exit 0
fi

APP=\${1:-''}
URI=\${2:-''}
PROXY=\${3:-''}

APP_CONF=$MAKENGINX_CONFD/\$APP.conf

if [ ! -f \$APP_CONF ]; then
    echo "\$APP not exist, please create it with addser first."
    exit 0
fi

sed -i -f ./auto/sed/add_proxy \$APP_CONF

sed -i -e "s@\[uri\]@\$URI@" \$APP_CONF
sed -i -e "s~\[proxy\]~\$PROXY~" \$APP_CONF

cat \$APP_CONF

XEND

chmod u+x addproxy

# 便捷添加图片 location

cat << XEND > addimgloc

if [ \$# -lt 2 ]; then
    echo "usage: ./addimgloc <toapp> <imgdir>"
    exit 0
fi

APP=\${1:-''}
ROOTDIR=\${2:-''}

APP_CONF=$MAKENGINX_CONFD/\$APP.conf

if [ ! -f \$APP_CONF ]; then
    echo "\$APP not exist, please create it with addser first."
    exit 0
fi

sed -i -f ./auto/sed/add_location \$APP_CONF

IMG_URI="~ \.(gif|jpg|png)$"

sed -i -e "s@\[uri\]@\$IMG_URI@" \$APP_CONF
sed -i -e "s~\[rootdir\]~\$ROOTDIR~" \$APP_CONF

cat \$APP_CONF

XEND

chmod u+x addimgloc

# 添加 　SSL

cat << XEND > addssl

allapps=\$(./show app)

if [[ -z \$allapps ]]; then
  echo "还未创建应用，请使用 ./addser 添加引用。"
  exit 0
fi

if [ \$(./show app | wc -l) -gt 1 ]; then
  PS3="请选择要添加SSL的应用(输入序号)："
  select app in \$allapps
  do
    if [ \$app ]; then break; fi
  done
else
  app=\$allapps
fi

echo "添加SSL到\$app"

. ./auto/func/get_cert

echo "安装如下证书文件:"
cert_files=\$(ls \$cert_dir/\$cert_name.{pem,key})
echo \$cert_files

test -d $NGINX_CONFD/cert || mkdir $NGINX_CONFD/cert

cp \$cert_files $NGINX_CONFD/cert

cert_pem=cert/\$cert_name.pem
cert_key=cert/\$cert_name.key

APP_CONF=$MAKENGINX_CONFD/\$app.conf
sed -i -f ./auto/sed/add_ssl \$APP_CONF
sed -i -e "s@\[cert_pem\]@\$cert_pem@" \$APP_CONF
sed -i -e "s@\[cert_key\]@\$cert_key@" \$APP_CONF

cat \$APP_CONF

XEND

chmod u+x addssl
