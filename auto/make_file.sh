# 创建 build/MakeFile
cat << END > $MAKEFILE

install:
	@. $INSTALL

END
echo "created makefile $MAKEFILE"


# 创建根目录 MakeFile
cat << END > Makefile

include $MAKEFILE

.PHONY: clean
clean:
	rm -rf $BUILD_DIR *.dSYM Makefile
	rm -f start stop reload restart show  status  test help init version diffconf log

END
echo "created Makefile"
