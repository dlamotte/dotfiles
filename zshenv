export PATH=/usr/local/bin:/usr/local/sbin:$PATH:/sbin:/usr/sbin
export PATH=/usr/local/share/python:/usr/local/opt/ruby/bin:/usr/local/opt/coreutils/libexec/gnubin:/usr/local/share/npm/bin:$PATH
export PATH=$PATH:/Applications/Xcode.app/Contents/Developer/usr/bin:/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin
export PATH=~/bin:$PATH

if locale -a | grep 'en_US.utf8' >/dev/null 2>/dev/null; then
    export LANG='en_US.utf8'
elif locale -a | grep 'en_US.UTF-8' >/dev/null 2>/dev/null; then
    export LANG='en_US.UTF-8'
else
    echo "zshrc error: LANG=C, en_US.utf8-ish not found"
    export LANG='C'
fi

if [[ -z $JAVA_HOME ]]; then
    export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_66.jdk/Contents/Home
fi

export EDITOR=vim
export GOPATH=$HOME/go
export LC_COLLATE='C'
export LESS="-MSRniFX"
export LESSOPEN="|lesspipe.sh %s"
export MANPAGER='vimmanpager'
export PAGER='less'
export PGDATA='/usr/local/var/postgres'
export PYTHONDONTWRITEBYTECODE=1
export PYTHONPATH="${PYTHONPATH}${PYTHONPATH+:}${HOME}/.python/lib"
export PYTHONSTARTUP=~/.pythonrc
export PYTHONDOCS=$(echo ${PYTHONDOCS} | sed -e 's:/lib::g')
export TZ='US/Central'

export HISTFILE=~/.histfile
export HISTSIZE=10000
export SAVEHIST=10000

export PS1='%B%F{red}!%! %F{magenta}$(scmstatus)%F%1~ %(?.%? .%F{red}%? )%F{red}>> %f%b'
export PS1_BACKUP=$PS1
export PS1_DEMO='%B%F{red}>> %f%b'
export PS2='%B%F{red}>>> %f%b'
export RPS1=' %B%F{red}<<%(!..%F) %M%f%b'
export RPS1_BACKUP=$RPS1
