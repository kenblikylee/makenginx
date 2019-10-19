# 创建安装脚本 build/install
cat << CEND > $INSTALL

cat << END
安装依赖：$INSTALL_DEPENDENCES
nginx 源码目录：$NGINX_SRC_DIR
nginx 安装目录：$NGINX_INSTALL_DIR
pcre 源码目录：$PCRE_SRC_DIR
zlib 源码目录：$ZLIB_SRC_DIR
openssl 源码目录：$OPENSSL_SRC_DIR
END

CEND
echo "created installfile $INSTALL"
