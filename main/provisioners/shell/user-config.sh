#!/usr/bin/env bash
set -e

echo "INFO>>> Setting User Bash Shell environment"

ENV_VARS='/home/vagrant/.bash_profile'
ENV_ALIASES='/home/vagrant/.bash_aliases'

tee() { touch "$1" && command tee "$@"; }


tee "$ENV_VARS" > "/dev/null" <<EOF

parse_git_branch_and_add_brackets() {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \[\1\]/'
}

# pip bash completion start
pip_completion()
{
    COMPREPLY=( \$( COMP_WORDS="\${COMP_WORDS[*]}" \\
    COMP_CWORD=\$COMP_CWORD \\
    PIP_AUTO_COMPLETE=1 \$1 ) )
}

complete -o default -F pip_completion pip
# pip bash completion end


# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
    fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

export PS1='\[\033[1;36m\]\u\[\033[1;31m\]@\[\033[1;32m\]\h:\[\033[1;35m\]\w\[\033[1;31m\]\$(parse_git_branch_and_add_brackets)\$\[\033[0m\] '
export PROMPT_DIRTRIM=3
export HISTSIZE=1000
export HISTFILESIZE=2000
EOF


tee "$ENV_ALIASES" > "/dev/null" <<EOF

#Aliases
alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'

alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias tshark='/opt/wireshark/bin/tshark'
EOF
