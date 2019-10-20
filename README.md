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

## 自动配置静态站点服务

``` sh
./addser <app> <domain> [port(default: 80)]
```

示例:
(阿里云需要添加安全组规则，设置入方向自定义 TCP 0.0.0.0/0 8080 ，才能通过外网IP访问)

``` sh
./init
./addser www 127.0.0.1 8080
./test && ./reload
curl 127.0.0.1:8080
```

``` sh
$ ./addser wecover wecover.xin 8080

server {
    listen       8080;
    server_name  wecover.xin;
    root         /ken/www/wecover;
}

```

移除应用:

``` sh
./rmser <app>
```

## 增加和移除 location

``` sh
./addloc <toapp> <uri> <rootdir>
./rmloc <app> <uri>
```

``` sh
$ ./addloc wecover '~ /(images|videos)/' '/ken/assets'

server {
    listen       8080;
    server_name  wecover.xin;
    root         /ken/www/wecover;
    location ~ /(images|videos)/ {
        root         /ken/assets;
    }

}
```

## 添加和移除反向代理

``` sh
$ ./addproxy wecover /api/ 127.0.0.1:4000

server {
    listen       8080;
    server_name  wecover.xin;
    root         /ken/www/wecover;
    location ~ /(images|videos)/ {
        root         /ken/assets;
    }

    location /api/ {
        proxy_pass         127.0.0.1:4000;
    }

}

$ ./rmloc wecover "\/api\/"

server {
    listen       8080;
    server_name  wecover.xin;
    root         /ken/www/wecover;
    location ~ /(images|videos)/ {
        root         /ken/assets;
    }


}

```

## 添加图片资源 location

``` sh
$ ./addimgloc wecover /ken/assets/images

server {
    listen       8080;
    server_name  wecover.xin;
    root         /ken/www/wecover;
    location ~ /(images|videos)/ {
        root         /ken/assets;
    }


    location ~ .(gif|jpg|png)$ {
        root         /ken/assets/images;
    }

}

```
