# makenginx
use make to auto-config nginx.

## configure

``` sh
# print help info
./configure --help|-h
# auto generate makefile
./configure
# config module
./configure python
./configure nodejs
```

## make

``` sh
# 删除 ./configure 生成的 makefile 文件和 build 目录
make clean
```
