# 创建安装脚本 build/install
cat << CEND > $INSTALL

test -d $SRC_ROOT_DIR || mkdir $SRC_ROOT_DIR

# 下载源码
## 1. 安装 git
yum install git
## 2. 下载 nginx 源码
cd $SRC_ROOT_DIR
git clone https://github.com/nginx/nginx.git
## 3. 下载 OpenSSL 源码
git clone https://github.com/openssl/openssl.git
## 4. 下载 pcre 源码
wget https://ftp.pcre.org/pub/pcre/pcre-8.43.tar.gz
tar zxf pcre-8.43.tar.gz
rm -f pcre-8.43.tar.gz
## 5. 下载 zlib 源码
wget http://zlib.net/zlib-1.2.11.tar.gz
tar zxf zlib-1.2.11.tar.gz
rm -f zlib-1.2.11.tar.gz

cat << END
安装依赖：$INSTALL_DEPENDENCES
nginx 源码目录：$NGINX_SRC_DIR
pcre 源码目录：$PCRE_SRC_DIR
zlib 源码目录：$ZLIB_SRC_DIR
openssl 源码目录：$OPENSSL_SRC_DIR
nginx 安装目录：$NGINX_INSTALL_DIR
END

cat << END > INSTALL.LOG
安装依赖：$INSTALL_DEPENDENCES
nginx 源码目录：$NGINX_SRC_DIR
pcre 源码目录：$PCRE_SRC_DIR
zlib 源码目录：$ZLIB_SRC_DIR
openssl 源码目录：$OPENSSL_SRC_DIR
nginx 安装目录：$NGINX_INSTALL_DIR
END

cd $NGINX_SRC_DIR
test -f ./Makefile && make clean

echo "configure nginx installation ..."
./auto/configure --with-http_v2_module --with-http_ssl_module \
    --with-pcre=$PCRE_SRC_DIR \
    --with-zlib=$ZLIB_SRC_DIR \
    --with-openssl=$OPENSSL_SRC_DIR \
    --prefix=$NGINX_INSTALL_DIR

echo "start nginx installation ..."
make && make install
CEND

chmod +x $INSTALL

echo "created installfile $INSTALL"
