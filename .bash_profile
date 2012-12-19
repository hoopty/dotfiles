export PATH=$PATH:$HOME/bin
which vim >/dev/null &&         export EDITOR='vim'
which vimpager >/dev/null &&    export PAGER='vimpager'
which less >/dev/null &&        export MANPAGER='less'
#export MANPAGER="col -b | vim -R -c 'set ft=man nomod nolist' -"

export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=1000
export HISTFILESIZE=1000
shopt -s histappend
export PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"

#export TERM=xterm-color
export CLICOLOR=1
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;36'
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
#export C_RED='\[\e[0;31m\]'
#export C_LIGHT_RED='\[\e[1;31m\]'
#export C_PURPLE='\[\e[0;35m\]'
#export C_LIGHT_PURPLE='\[\e[1;35m\]'
#export C_BROWN='\[\e[0;33m\]'
export C_YELLOW='\[\e[1;33m\]'
#export C_GRAY='\[\e[1;30m\]'
#export C_LIGHT_GRAY='\[\e[0;37m\]'
alias colorslist="set | egrep 'C_\w*'" # lists colors

# color prompt (using colors by name)
export PS1="${C_YELLOW}\u${C_NC}@${C_LIGHT_GREEN}\h${C_NC}[${C_LIGHT_CYAN}\w${C_NC}]$"
case $TERM in
    xterm*)
        export PS1="\[\e]0;\u@\h \w\007\]${PS1}"
        #set -o functrace
        #trap 'echo -ne "\033]0;${BASH_COMMAND}\007"' DEBUG
    ;;
esac

# Less Colors for Man Pages
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

CONFIG_FILES='.bash_profile .vimrc .gitconfig .tmux.conf .config/htop/htoprc'
CONFIG_URL='https://raw.github.com/hoopty/dotfiles/master'


which colordiff >/dev/null && alias diff='colordiff'
alias duf='du -sk * | sort -nr | perl -ne '\''($s,$f)=split(m{\t});for (qw(k M G T)) {if($s<1024) {printf("%.1f",$s);print "$_\t$f"; last};$s=$s/1024}'\'
alias h='history'
alias l='less -gimS'
alias ll='ls -aFGhl'
alias m='more -i'
which sudo >/dev/null && alias s='sudo'
which vim >/dev/null && alias vi='vim'
alias whereis='whereis -b'
alias new_dotfiles="for f in ${CONFIG_FILES}; do wget -nv -x -nH --cut-dirs=1 -N ${CONFIG_URL}/\$f; done; . ~/.bash_profile"
function ffind () { find / -name $@ -ls; }

OS=`uname`
if [ "$OS" = "Linux" -o "$OS" = "GNU/kFreeBSD" ]; then
    alias ll='LC_COLLATE=C ls -alhF --group-directories-first --color=auto'
    alias fis='sudo apt-get update'
    alias fiuw='sudo apt-get upgrade'
    alias fir='sudo apt-get check'
    alias fic='sudo apt-get autoremove && sudo apt-get autoclean'
    function inlog () { grep $@ /var/log/syslog; }
    function msglog () { tail $@ /var/log/syslog; }

elif [ "$OS" = "FreeBSD" ]; then
    alias fis='cd /usr/ports && sudo make update'
    alias fiuw='sudo portmaster -a'
    alias fir='sudo portmaster --check-depends'
    alias fic='sudo portmaster -s && sudo portmaster --clean-distfiles && sudo portmaster --clean-packages && sudo portmaster --check-port-dbdir'
    alias new_dotfiles="for f in ${CONFIG_FILES}; do fetch -o ~/\$f ${CONFIG_URL}/\$f; done; . ~/.bash_profile"
    function inlog () { grep $@ /var/log/messages; }
    function msglog () { tail $@ /var/log/messages; }
    function wwwlog () { tail $@ /var/log/httpd-access-`date '+%Y-%m'`.log; }
    function wwwerrlog () { tail $@ /var/log/httpd-error-`date '+%Y-%m'`.log; }
    alias systat='systat -vm 1'
    alias gstat='sudo gstat -f da\.$'

elif [ "$OS" = "Darwin" ]; then
    export PATH=/opt/local/bin:/opt/local/sbin:$PATH
    export MANPATH=/opt/local/share/man:$MANPATH
    alias fis='sudo port -d selfupdate'
    alias fiuw='sudo port -v upgrade outdated'
    alias fic='sudo port -v uninstall inactive'
    alias new_dotfiles="for f in ${CONFIG_FILES}; do curl -o ~/\$f ${CONFIG_URL}/\$f; done; . ~/.bash_profile"
    function inlog () { grep $@ /var/log/system.log; }
    function msglog () { tail $@ /var/log/system.log; }
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
[[ $PS1 && -f /usr/local/share/bash-completion/bash_completion.sh ]] && \
    source /usr/local/share/bash-completion/bash_completion.sh


# deal with terminal resizing
shopt -s checkwinsize
# minor errors in the spelling of a directory component in a cd command will be corrected
shopt -s cdspell
# match filenames in a case-insensitive fashion when performing pathname expansion
shopt -s nocaseglob


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
set -o vi
# Goto begin of line
bind -m vi-insert C-a:vi-insert-beg
bind -m vi-command C-a:vi-insert-beg
# Goto end of line
bind -m vi-insert C-e:vi-append-eol
bind -m vi-command C-e:vi-append-eol
# clear screen
bind -m vi-insert C-l:clear-screen
bind -m vi-command C-l:clear-screen
# insert last argument
bind -m vi-insert C-k:insert-last-argument
bind -m vi-command C-k:insert-last-argument
# Used by macros
bind -m vi-insert C-K:kill-whole-line
# C-i is used in other macros.
bind -m vi-command C-i:vi-insertion-mode

bind -m vi-command -r 'v'

# bind "tr" to reverse-search-history
bind -m vi-command '"\x74\x72"':"\"\C-i\C-r\""
# Binding shell ls command to a key tl
bind -m vi-command -x '"tl":ls'
# bind tt to !:* : All argument of last command
bind -m vi-command '"\x74\x74"':" \"\C-i \!:* \""
# Bind "tk" to save the current command to history without executing
bind -m vi-command '"\x74\x6b"':"\"\C-ahistory -s '\C-e'\C-m"
# th shows the last 8 commands.
bind -m vi-command -x '"th":"history 8"'

bind -m vi-command b:vi-prev-word
bind -m vi-command c:vi-change-to
bind -m vi-command /:vi-search

