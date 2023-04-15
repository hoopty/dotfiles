# If not running interactively, don't do anything
[ -z "$PS1" ] && return

which vim >/dev/null 2>&1 &&        export EDITOR='vim'
which vimpager >/dev/null 2>&1 &&   export PAGER='vimpager'
#which less >/dev/null 2>&1 &&       export MANPAGER='less'
#export MANPAGER="col -b | vim -R -c 'set ft=man nomod nolist' -"

HISTCONTROL=ignoredups:erasedups  # no duplicate entries
HISTIGNORE="?:??:???:$HISTIGNORE" # Ignore short (1-3 digit) commands from history
HISTSIZE=100000
HISTFILESIZE=100000
#HISTTIMEFORMAT="%b/%d %T "
shopt -s histappend               # append to history, don't overwrite it
alias hdedupe="tac $HISTFILE | awk '!x[\$0]++' | tac > ~/.tmp.newhist && mv ~/.tmp.newhist $HISTFILE"

#export TERM=xterm-color
#export CLICOLOR=1
#export GREP_OPTIONS='--color=auto' GREP_COLOR='1;36'
#export LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rb=90'

export C_NC='\[\e[0m\]' # No Color
#export C_WHITE='\[\e[1;37m\]'
#export C_BLACK='\[\e[0;30m\]'
#export C_BLUE='\[\e[0;34m\]'
#export C_LIGHT_BLUE='\[\e[1;34m\]'
#export C_GREEN='\[\e[0;32m\]'
export C_LIGHT_GREEN='\[\e[1;32m\]'
#export C_CYAN='\[\e[0;36m\]'
export C_LIGHT_CYAN='\[\e[1;36m\]'
export C_RED='\[\e[0;31m\]'
export C_U_RED='\[\e[4;31m\]'
#export C_LIGHT_RED='\[\e[1;31m\]'
#export C_PURPLE='\[\e[0;35m\]'
export C_LIGHT_PURPLE='\[\e[1;35m\]'
#export C_BROWN='\[\e[0;33m\]'
export C_YELLOW='\[\e[1;33m\]'
#export C_GRAY='\[\e[1;30m\]'
#export C_LIGHT_GRAY='\[\e[0;37m\]'
alias colorslist="for c in $(set | egrep '^C_' | cut -f 1 -d = | xargs); do printf \"\${!c:2:-2}\${c}\${C_NC:2:-2}\n\"; done"


#function num_files() {
#    ls -1 | wc -l | sed 's: ::g'
#}

#function free_space() {
#    df -h . | awk 'NR==2{ print $4 }'
#}

function parse_git_branch {
    [[ -n "${PROMPT_SKIP_GIT_BRANCH}" ]] && return
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

function parse_git_dirty {
    [[ -n "${PROMPT_SKIP_GIT_STATUS}" ]] && return
    [[ $(git status -s 2> /dev/null) != '' ]] && echo '*'
}

# color prompt (using colors by name)
#PS1="${C_YELLOW}\u${C_NC}@${C_LIGHT_GREEN}\h${C_NC}[${C_LIGHT_CYAN}\w${C_NC}]$"

set_bash_prompt() {
    PS1="${C_LIGHT_PURPLE}\u${C_NC}@${C_LIGHT_GREEN}\h${C_NC} "
    [[ "${1}" != "0" ]] && PS1+="${C_U_RED}${1}${C_NC} "
    #PS1+="(${C_LIGHT_CYAN}\$(num_files) files, \$(free_space)${C_NC}) "
    PS1+="\w "
    [[ -z "${PROMPT_SKIP_VENV}" && -n "${VIRTUAL_ENV}" ]] && PS1+="[${C_YELLOW}\$(basename ${VIRTUAL_ENV})${C_NC}] "
    [[ -z "${PROMPT_SKIP_GIT}" && -d .git ]] && PS1+="(${C_LIGHT_CYAN}\$(parse_git_branch)${C_RED}\$(parse_git_dirty)${C_NC}) "
    PS1+="\\$"
    [[ "${TERM::5}" == "xterm" ]] && PS1+="\[\e]0;\u@\h \w\007\]"
}
PROMPT_COMMAND="RC=$?; set_bash_prompt $RC"
# append & read new history to sync with other shells
#PROMPT_COMMAND='RC=$?; history -a; history -n; set_bash_prompt $RC'
# Save and reload the history after each command finishes
#PROMPT_COMMAND="RC=$?; history -a; history -c; history -r; set_bash_prompt $RC"

# Less Colors for Man Pages
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

DOTFILES='.bashrc .vimrc .gitconfig .tmux.conf .config/htop/htoprc'
DOTFILES_URL='https://raw.githubusercontent.com/hoopty/dotfiles/master'
which fetch >/dev/null 2>&1 && DOTFILES_GET='fetch --no-verify-peer -o'
which wget >/dev/null 2>&1  && DOTFILES_GET='wget -nv -O'
which curl >/dev/null 2>&1  && DOTFILES_GET='curl -s -o'

S=
if [[ "$(id -u)" -ne 0 ]]; then
    which sudo >/dev/null 2>&1 && S="sudo " && alias s='sudo'
fi


which colordiff >/dev/null 2>&1 && alias diff='colordiff'
which vim >/dev/null 2>&1 && alias vi='vim'

alias duf="${S}du -h -d 1 | sort -hr"
alias dufx="${S}du -x -h -d 1 | sort -hr"
alias h='history'
alias ha='history -a'
alias hn='history -n'
alias l='less -gimS'
alias ll='ls -aFGhl'
alias m='more -i'
alias new_dotfiles="for f in ${DOTFILES}; do ${DOTFILES_GET} ~/\$f ${DOTFILES_URL}/\$f; done; . ~/.bash_profile"
alias whereis='whereis -b'

OS=$(uname -o 2>/dev/null || uname 2>/dev/null)
if [[ "$OS" == 'Linux' || "$OS" == 'GNU/Linux' ]]; then
    export PATH=/usr/local/sbin:/usr/sbin:/sbin:$PATH
    alias ll='LC_COLLATE=C ls -alhF --group-directories-first --color=auto'
    alias pkg-all="${S}apt-get update && ${S}apt-get dist-upgrade && ${S}apt-get check && ${S}apt-get autoremove && ${S}apt-get autoclean"

    LOGFILE=/var/log/syslog
elif [[ "$OS" == 'Darwin' ]]; then
    export PATH=/usr/local/sbin:/usr/local/bin:$PATH
    #export MANPATH=/opt/local/share/man:$MANPATH

    which gls >/dev/null 2>&1 && alias ll='gls -alhF --group-directories-first --color=auto'

    alias pkg-all='brew update && brew upgrade && brew upgrade --cask && brew cleanup'

    LOGFILE=/var/log/system.log
elif [[ "$OS" == 'FreeBSD' ]]; then
    alias pkg-all="${S}pkg upgrade -y && ${S}pkg check -Bds && ${S}pkg clean -ay && ${S}pkg autoremove"
    alias gstat="${S}gstat -p -f '^([a]?da|nvd)[0-9]+$'"
    alias iotop='top -m io -o total'
    alias systat='systat -vm 1'

    function je () { for j in $(jls name); do echo "${j}:"; ${S}jexec ${j} $@; echo; done }
    function jc () { for j in $(jls name); do echo "${j}:"; ${S}cp -pv ${1} /jail/${j}/${1}; echo; done }
    LOGFILE=/var/log/messages
fi

function ffind () { find / -name $@ -ls; }
function inlog () { ${S}grep $@ ${LOGFILE}; }
function msglog () { ${S}tail $@ ${LOGFILE}; }


[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases

[[ $PS1 && -f /etc/bash_completion ]] && . /etc/bash_completion

[[ $PS1 && -f /usr/local/share/bash-completion/bash_completion.sh ]] && \
    . /usr/local/share/bash-completion/bash_completion.sh

which keychain >/dev/null 2>&1 && eval `keychain --eval id_ed25519 id_rsa --ignore-missing -q`


# deal with terminal resizing
shopt -s checkwinsize
# minor errors in the spelling of a directory component in a cd command will be corrected
shopt -s cdspell
# match filenames in a case-insensitive fashion when performing pathname expansion
#shopt -s nocaseglob
# append to the history file, don't overwrite it
shopt -s histappend
# make sure variables are expanded on prompts
shopt -s promptvars
# collapse multiline commands to one history entry
shopt -s cmdhist


# do not show hidden files in the list: really useful when working in your home directory
bind "set match-hidden-files off"
# removes the annoying "-- more --" prompt for long lists
bind "set page-completions off"
# show the "Display all 123 possibilities? (y or n)" prompt only for really long lists
bind "set completion-query-items 350"
# show the list at first TAB, instead of beeping and and waiting for a second TAB to do that
bind "set show-all-if-ambiguous on"
# perform filename matching and completion in a case-insensitive fashion
bind "set completion-ignore-case on"

## Bringing VI to bash prompts
#set -o vi
# Goto begin of line
#bind -m vi-insert C-a:vi-insert-beg
#bind -m vi-command C-a:vi-insert-beg
# Goto end of line
#bind -m vi-insert C-e:vi-append-eol
#bind -m vi-command C-e:vi-append-eol
# clear screen
#bind -m vi-insert C-l:clear-screen
#bind -m vi-command C-l:clear-screen
# insert last argument
#bind -m vi-insert C-k:insert-last-argument
#bind -m vi-command C-k:insert-last-argument
# Used by macros
#bind -m vi-insert C-K:kill-whole-line
# C-i is used in other macros.
#bind -m vi-command C-i:vi-insertion-mode

#bind -m vi-command -r 'v'

# bind "tr" to reverse-search-history
#bind -m vi-command '"\x74\x72"':"\"\C-i\C-r\""
# Binding shell ls command to a key tl
#bind -m vi-command -x '"tl":ls'
# bind tt to !:* : All argument of last command
#bind -m vi-command '"\x74\x74"':" \"\C-i \!:* \""
# Bind "tk" to save the current command to history without executing
#bind -m vi-command '"\x74\x6b"':"\"\C-ahistory -s '\C-e'\C-m"
# th shows the last 8 commands.
#bind -m vi-command -x '"th":"history 8"'

#bind -m vi-command b:vi-prev-word
#bind -m vi-command c:vi-change-to
#bind -m vi-command /:vi-search

