[[ -d $HOME/bin ]] && export PATH=$PATH:$HOME/bin
which vim >/dev/null 2>&1 &&        export EDITOR='vim'
which vimpager >/dev/null 2>&1 &&   export PAGER='vimpager'
which less >/dev/null 2>&1 &&       export MANPAGER='less'
#export MANPAGER="col -b | vim -R -c 'set ft=man nomod nolist' -"

shopt -s histappend
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=10000
export HISTFILESIZE=10000
#export HISTTIMEFORMAT="%b/%d %T "

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


function num_files() {
    ls -1 | wc -l | sed 's: ::g'
}

function free_space() {
    df -h . | awk 'NR==2{ print $4 }'
}

function parse_git_dirty {
    [[ -n "${PROMPT_SKIP_GIT_STATUS}" ]] && return
    [[ $(git status -s 2> /dev/null) != '' ]] && echo '*'
}

function parse_git_branch {
    [[ -n "${PROMPT_SKIP_GIT_BRANCH}" ]] && return
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

# color prompt (using colors by name)
#PS1="${C_YELLOW}\u${C_NC}@${C_LIGHT_GREEN}\h${C_NC}[${C_LIGHT_CYAN}\w${C_NC}]$"

set_bash_prompt() {
    PS1="${C_YELLOW}┌─[${C_LIGHT_GREEN}"
    [[ "${1}" != "0" ]] && PS1+="${C_U_RED}"
    PS1+="${1}${C_NC}${C_YELLOW}]"
    PS1+="─(${C_LIGHT_PURPLE}\u${C_NC}@${C_LIGHT_GREEN}\h${C_YELLOW})"
    PS1+="─(${C_LIGHT_CYAN}\$(num_files) files, \$(free_space)${C_YELLOW})"
    [[ -z "${PROMPT_SKIP_GIT}" && -d .git ]] && PS1+="─[${C_NC}\$(parse_git_branch)${C_RED}\$(parse_git_dirty)${C_YELLOW}]"
    PS1+="\n└─"
    PS1+="─[${C_NC}\w${C_YELLOW}]"
    PS1+=" ${C_NC}\$"
    [[ "${TERM::5}" == "xterm" ]] && PS1="\[\e]0;\u@\h \w\007\]${PS1}"
}
#PROMPT_COMMAND='RC=$?; history -a; set_bash_prompt $RC'
PROMPT_COMMAND='set_bash_prompt $?'


# Less Colors for Man Pages
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

DOTFILES='.bash_profile .vimrc .gitconfig .tmux.conf .config/htop/htoprc'
DOTFILES_URL='https://raw.github.com/hoopty/dotfiles/master'
which wget >/dev/null 2>&1  && DOTFILES_GET='wget -nv -O'
which curl >/dev/null 2>&1  && DOTFILES_GET='curl -o'
which fetch >/dev/null 2>&1 && DOTFILES_GET='fetch -o'

SUDO_CMD=
if [[ "$(id -u)" -ne 0 ]]; then
    which sudo >/dev/null 2>&1 && SUDO_CMD="sudo"
fi


which colordiff >/dev/null 2>&1 && alias diff='colordiff'
alias duf='sudo du -sk * | sort -nr | perl -ne '\''($s,$f)=split(m{\t});for (qw(k M G T)) {if($s<1024) {printf("%.1f",$s);print "$_\t$f"; last};$s=$s/1024}'\'
alias h='history'
alias ha='history -a'
alias hn='history -n'
alias l='less -gimS'
alias ll='ls -aFGhl'
alias m='more -i'
alias new_dotfiles="for f in ${DOTFILES}; do ${DOTFILES_GET} ~/\$f ${DOTFILES_URL}/\$f; done; . ~/.bash_profile"
which sudo >/dev/null 2>&1 && alias s='sudo'
which vim >/dev/null 2>&1 && alias vi='vim'
alias whereis='whereis -b'
function ffind () { find / -name $@ -ls; }

OS=$(uname -o 2>/dev/null || uname 2>/dev/null)
if [[ "$OS" == 'Linux' || "$OS" == 'GNU/kFreeBSD' ]]; then
    alias ll='LC_COLLATE=C ls -alhF --group-directories-first --color=auto'
    alias fis="${SUDO_CMD} apt-get update"
    alias fiuw="${SUDO_CMD} apt-get upgrade"
    alias fir="${SUDO_CMD} apt-get check"
    alias fic="${SUDO_CMD} apt-get autoremove && ${SUDO_CMD} apt-get autoclean"
    function inlog () { grep $@ /var/log/syslog; }
    function msglog () { tail $@ /var/log/syslog; }

elif [[ "$OS" == 'GNU/Linux' ]]; then
    alias ll='LC_COLLATE=C ls -alhF --color=auto'

elif [[ "$OS" == 'FreeBSD' ]]; then
    alias fis="cd /usr/ports && ${SUDO_CMD} make update"
    alias fiuw="${SUDO_CMD} portmaster -a"
    alias fir="${SUDO_CMD} portmaster --check-depends"
    alias fic="${SUDO_CMD} portmaster -s && ${SUDO_CMD} portmaster --clean-distfiles && ${SUDO_CMD} portmaster --clean-packages && ${SUDO_CMD} portmaster --check-port-dbdir"
    function inlog () { grep $@ /var/log/messages; }
    function msglog () { tail $@ /var/log/messages; }
    function wwwlog () { tail $@ /var/log/httpd-access-$(date '+%Y-%m').log; }
    function wwwerrlog () { tail $@ /var/log/httpd-error-$(date '+%Y-%m').log; }
    alias gstat="${SUDO_CMD} gstat -f da\.$"
    alias iotop='top -m io -o total'
    alias systat='systat -vm 1'

elif [[ "$OS" == 'Darwin' ]]; then
    export PATH=/opt/local/bin:/opt/local/sbin:$PATH
    export MANPATH=/opt/local/share/man:$MANPATH
    alias fis="${SUDO_CMD} port -d selfupdate"
    alias fiuw="${SUDO_CMD} port -v upgrade outdated"
    alias fic="${SUDO_CMD} port -v uninstall inactive"
    function inlog () { grep $@ /var/log/system.log; }
    function msglog () { tail $@ /var/log/system.log; }
fi


[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases

[[ $PS1 && -f /etc/bash_completion ]] && . /etc/bash_completion

[[ $PS1 && -f /usr/local/share/bash-completion/bash_completion.sh ]] && \
    . /usr/local/share/bash-completion/bash_completion.sh


# deal with terminal resizing
shopt -s checkwinsize
# minor errors in the spelling of a directory component in a cd command will be corrected
shopt -s cdspell
# match filenames in a case-insensitive fashion when performing pathname expansion
#shopt -s nocaseglob


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

