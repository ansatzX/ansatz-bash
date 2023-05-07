# for stop printing zsh sb string

case $- in
    *i*) ;;
    *) return;;
esac

# Quit if bash version is less than 4
# by default, OSX use Bash 3
# @see https://github.com/mooz/percol/issues/14#issuecomment-150964987
# but you can upgrade bash
# @see http://clubmate.fi/upgrade-to-bash-4-in-mac-os-x/


# Source global definitions (if any)
if [ -f /etc/bashrc ]; then
    . /etc/bashrc   # --> Read /etc/bashrc, if present.
fi

# Gentoo Linux
if [ -f /etc/bash/bashrc ]; then
    . /etc/bash/bashrc
fi

# for what distribution?
if [ -f /etc/bash.bashrc ]; then
    . /etc/bash.bashrc
fi

# # {{ Shell in Emacs sets $TERM to "dumb"
#if [ "${TERM}" != "dumb" ]; then
#    # enable bash completion
#    # @see http://www.simplicidade.org/notes/archives/2008/02/bash_completion.html
#    if [ -f /etc/bash_completion ]; then
#        # ArchLinux
#        . /etc/bash_completion
#    elif [ -f /etc/profile.d/bash-completion.sh ]; then
#        # Gentoo Linux
#        . /etc/profile.d/bash-completion.sh
#    elif [ ! -z $BASH_COMPLETION ]; then
#        . $BASH_COMPLETION
#    fi
#fi
# }}

if [ -d $HOME/bash_completion.d ]; then
    . $HOME/bash_completion.d/gibo-completion.bash
    . $HOME/bash_completion.d/git-completion.bash
fi



if [ "$OSTYPE" = "cygwin" ]; then
	  OS_NAME='CYGWIN'
elif [ "`uname -s`" = "Darwin" ]; then
    OS_NAME="Darwin"
elif grep -q Microsoft /proc/version; then
    OS_NAME="WSL"
else
    OS_NAME=`uname -r`
fi




if [ "$OS_NAME" = "Darwin" ]; then
	export BASH_SILENCE_DEPRECATION_WARNING=1
	export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
	export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
	export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
	export HOMEBREW_NO_INSTALL_FROM_API=1
	eval $(/opt/homebrew/bin/brew shellenv) #ckbrew
	source /opt/homebrew/opt/modules/init/bash
	# coreutils binutils moreutils
	export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
	export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
	export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
	# openblas 
	export LDFLAGS="-L/opt/homebrew/opt/openblas/lib"
	export CPPFLAGS="-I/opt/homebrew/opt/openblas/include"
	# wolfram player
	export PATH="/Applications/Wolfram Player.app/Contents/MacOS":$PATH

fi

if [ "${BASH_VERSION%%[^0-9]*}" -lt "4" ]; then
	return;
fi


function proxyme {
  if [ "$OS_NAME" = "WSL" ]; then
		export hostip=$(ip route | grep default | awk '{print $3}')
	else 
		export hostip=localhost
	fi

	export SOCKS5_PROXY=socks5://${hostip}:22801
  export HTTP_PROXY=${hostip}:22801
  export HTTPS_PROXY=${hostip}:22801
  git config --global http.proxy ${SOCKS5_PROXY}
}

function unproxyme {
  unset HTTP_PROXY
  unset HTTPS_PROXY
  unset SOCKS5_PROXY
  git config --global --unset http.proxy
}

function wget2 {
  wget -e "http_proxy=localhost:22801" $@
}

# Easy extact
extract () {
  if [ -f $1 ] ; then
      case $1 in
          *.tar.xz)    tar xvJf $1    ;;
          *.tar.bz2)   tar xvjf $1    ;;
          *.tar.gz)    tar xvzf $1    ;;
          *.bz2)       bunzip2 $1     ;;
          *.rar)       unrar e $1     ;;
          *.gz)        gunzip $1      ;;
          *.tar)       tar xvf $1     ;;
          *.tbz2)      tar xvjf $1    ;;
          *.tgz)       tar xvzf $1    ;;
          *.apk)       unzip $1       ;;
          *.epub)      unzip $1       ;;
          *.xpi)       unzip $1       ;;
          *.zip)       unzip $1       ;;
          *.odt)       unzip $1       ;;
          *.war)       unzip $1       ;;
          *.jar)       unzip $1       ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1        ;;
          *)           echo "don't know how to extract '$1'..." ;;
      esac
  else
      echo "'$1' is not a valid file!"
  fi
}
# easy compress - archive wrapper
compress () {
    if [ -n "$1" ] ; then
        FILE=$1
        case $FILE in
        *.tar) shift && tar cf $FILE $* ;;
        *.tar.bz2) shift && tar cjf $FILE $* ;;
        *.tar.gz) shift && tar czf $FILE $* ;;
        *.tgz) shift && tar czf $FILE $* ;;
        *.zip) shift && zip $FILE $* ;;
        *.rar) shift && rar $FILE $* ;;
        esac
    else
        echo "usage: compress <foo.tar.gz> ./foo ./bar"
    fi
}


# enable starship  
eval "$(starship init bash)"

alias ll='ls -l '


