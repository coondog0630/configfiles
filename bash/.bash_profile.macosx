#
# Load other bash files
#
if [ -a ~/.bashrc ]; then
    source ~/.bashrc
fi

if [ -a ~/.bash_alias ]; then
    source ~/.bash_alias
fi

if [ $TERM == "screen" ]; then
    echo -ne "\ek${HOSTNAME}\e\\";
fi  

# PS1 Variable setup
export NONE="\[\033[0m\]"
export RED="\[\033[0;31m\]" 
if [ $HOSTNAME == "Sahil-Cooners-MacBook-Pro.local" ]; then
    export HC="\[\033[0;32m\]"
else
    export HC="\[\033[1;33m\]"
fi
export PS1="$RED[$NONE\u$RED] [$NONE\w$RED] [$HC\h$RED]$NONE\n> "

# System Programming paths
export MACPORTS_PATH="/opt/local/bin:/opt/local/sbin"
export BREW_PATH="/usr/local/bin:/usr/local/sbin"
export MACMYSQL_PATH="/usr/local/mysql/bin"
export DEPOT_TOOLS="~/build/depot_tools"
export CHROMIUM_ROOT="~/build/google/chromium"
export ANDROID_TOOLS="~/build/droid-sdk/tools"

# Go(oogle) Language
export GOROOT=`brew --cellar`/go/HEAD
export GOARCH=amd64
export GOOS=darwin


# Google Web Toolkit
export GWT_HOME="$HOME/programming/google/gwt/2.0.1"

# Editor Vars
export EDITOR=vim
export GIT_EDITOR=vim

#
# PATH
#
export PATH=$BREW_PATH:$MACPORTS_PATH:$PATH:$DEPOT_TOOLS
export MANPATH=/opt/local/share/man:$MANPATH
export DISPLAY=:0.0
