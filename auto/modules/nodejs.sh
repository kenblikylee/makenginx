install()
{
yum install -y nodejs
npm install -g n
n 8.11.4
NODE_BIN_DIR=$(n which 8.11.4 | sed -e 's/node$//')
echo "node bin: $NODE_BIN_DIR"
n run 8.11.4 -v
n exec 8.11.4 npm -v
n exec 8.11.4 npx -v
sed -i -e "/^export PATH/ i\# makenginx install nodejs\n\PATH=$NODE_BIN_DIR:\$PATH\n" ~/.bash_profile
}

helpinfo()
{
cat <<END
usage: ./configure nodejs <command>
commands:
    - install:    install nodejs.

END
}

cmd=${1:-''}

case $cmd in
    install)
        install
    ;;
    '')
        helpinfo
        exit 0
    ;;
esac
