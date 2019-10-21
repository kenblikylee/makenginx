install()
{
curl -O https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh
sh ./Anaconda3-2019.10-Linux-x86_64.sh
}

helpinfo()
{
cat <<END
usage: ./configure python <command>
commands:
    - install:    install python.

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
