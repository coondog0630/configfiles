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

#
# System Programming paths
#
#export PYTHONPATH=/System/Library/Frameworks/Python.framework/Versions/Current
#export PYTHONPATH=/opt/local/lib/python2.5/site-packages
export MACPORTS_PATH=/opt/local/bin:/opt/local/sbin
export MACMYSQL_PATH="/usr/local/mysql/bin"
export DEPOT_TOOLS="~/programming/google/depot_tools"
export ANDROID_TOOLS="~/build/droid-sdk/tools"

# Go(oogle) Language
export GOROOT=$HOME/programming/google/go
export GOOS="darwin"
export GOARCH="amd64"
export GOBIN=$HOME/.bin/go

# Google Web Toolkit
export GWT_HOME="$HOME/programming/google/gwt/2.0.1"

# Git Configuration Variables
GIT_EDITOR=vim

#
# PATH
#
#export PATH=~/.bin:$ANDROID_TOOLS:$MACPORTS_PATH:$MACMYSQL_PATH:$DEPOT_TOOLS:$GWT_HOME:$PYTHONPATH:$PATH
#export PATH=/opt/ruby-enterprise/bin:/opt/local/bin:/opt/local/sbin:$PATH:/opt/local/lib/postgresql83/bin/
export PATH=/opt/local/bin:/opt/local/sbin:$PATH:/opt/local/lib/postgresql83/bin/
export MANPATH=/opt/local/share/man:$MANPATH
export DISPLAY=:0.0
