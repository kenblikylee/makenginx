# makenginx

use make to auto-config nginx.

最新测试通过：

- 阿里云ECS: CentOS Linux release 7.6.1810 (Core) 

## 生成 nginx 自动安装脚本 install

``` sh
# 指定安装目录
./configure --prefix=/ken
# 或
./configure -p=/ken
# 默认安装到 /usr/local 目录下
./configure
```

## 启动自动下载和安装

下载源码到 `~/source` 目录下：

``` sh
./build/download
```

启动源码安装:

``` sh
./build/install
```

## make clean

``` sh
# 删除 ./configure 生成的 makefile 文件和 build 目录
make clean
```
