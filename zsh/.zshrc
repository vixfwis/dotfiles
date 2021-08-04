autoload -U colors select-word-style
colors          # colours
select-word-style bash # ctrl+w on words
stty -tostop

##
# Vcs info
##
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn hg
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' formats "%{$fg[yellow]%}%c%{$fg[green]%}%u%{$reset_color%} [%{$fg[blue]%}%b%{$reset_color%}] %{$fg[yellow]%}%s%{$reset_color%}:%r"
precmd() {  # run before each prompt
  vcs_info
}

##
# Prompt
##
setopt PROMPT_SUBST     # allow funky stuff in prompt
color="green"
if [[ $UID == 0 || $EUID == 0 ]]; then
    color="red"         # root is red, user is green
fi;
prompt="%{$fg[$color]%}%n %{$fg[yellow]%}%m%{$reset_color%} %B%~%b "
RPROMPT='${vcs_info_msg_0_}'

##
# Key bindings
##
bindkey -e                                                       # emacs keybindings
bindkey '\e[1;5C' forward-word                                   # C-Right
bindkey '\e[1;5D' backward-word                                  # C-Left
bindkey '\e[2~'   overwrite-mode                                 # Insert
bindkey '\e[3~'   delete-char                                    # Del
bindkey '\e[5~'   history-search-backward                        # PgUp
bindkey '\e[6~'   history-search-forward                         # PgDn
bindkey '\e[H'    beginning-of-line                              # Home
bindkey '\e[1~'   beginning-of-line                              # Home
bindkey '\e[F'    end-of-line                                    # End
bindkey '\e[4~'   end-of-line                                    # End
bindkey '^D'      delete-char                                    # Del
bindkey '^R'      history-incremental-pattern-search-backward    # History search
bindkey '^H'      backward-kill-word	                         # Ctrl Backspace
bindkey '\e[3;5~' kill-word		                         # Ctrl Delete


##
# Completion
##
autoload -U compinit
compinit
zmodload -i zsh/complist        
setopt hash_list_all            # hash everything before completion
setopt completealiases          # complete alisases
setopt always_to_end            # when completing from the middle of a word, move the cursor to the end of the word    
setopt complete_in_word         # allow completion from within a word/phrase
unsetopt correct                # spelling correction for commands
setopt list_ambiguous           # complete as much of a completion until it gets ambiguous.
setopt completealiases

zstyle ':completion::complete:*' use-cache on               # completion caching, use rehash to clear
zstyle ':completion:*' cache-path ~/.zsh/cache              # cache path
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # ignore case
zstyle ':completion:*' menu select=2                        # menu if nb items > 2
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}       # colorz !
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate # list of completers to use
zstyle ':completion:*' accept-exact '*(N)'

# sections completion !
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format $'\e[00;34m%d'
zstyle ':completion:*:messages' format $'\e[00;31m%d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:manuals' separate-sections true

zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=29=34"
zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*' force-list always

#generic completion with --help
compdef _gnu_generic gcc
compdef _gnu_generic r2
compdef _gnu_generic gdb
compdef _gnu_generic openssl

##
# Pushd
##
setopt auto_pushd               # make cd push old dir in dir stack
setopt pushd_ignore_dups        # no duplicates in dir stack
setopt pushd_silent             # no dir stack after pushd or popd
setopt pushd_to_home            # `pushd` = `pushd $HOME`

##
# History
##
HISTFILE=~/.zsh_history         # where to store zsh config
HISTSIZE=4096                   # big history
SAVEHIST=4096                   # big history
setopt append_history           # append
setopt hist_ignore_all_dups     # no duplicate
unsetopt hist_ignore_space      # ignore space prefixed commands
setopt hist_reduce_blanks       # trim blanks
setopt hist_verify              # show before executing history commands
setopt inc_append_history       # add commands as they are typed, don't wait until shell exit 
unsetopt share_history          # share hist between sessions
setopt bang_hist                # !keyword

##
# Various
##
setopt +o nomatch		        # pass "no match found" as-is
setopt auto_cd                  # if command is a path, cd into it
setopt auto_remove_slash        # self explicit
#setopt chase_links              # resolve symlinks
setopt correct                  # try to correct spelling of commands
setopt extended_glob            # activate complex pattern globbing
setopt glob_dots                # include dotfiles in globbing
#setopt print_exit_value         # print return value if non-zero
unsetopt beep                   # no bell on error
unsetopt bg_nice                # no lower prio for background jobs
setopt clobber                  # must use >| to truncate existing files
unsetopt hist_beep              # no bell on error in history
unsetopt hup                    # no hup signal at shell exit
unsetopt ignore_eof             # do not exit on end-of-file
unsetopt list_beep              # no bell on ambiguous completion
unsetopt rm_star_silent         # ask for confirmation for `rm *' or `rm path/*'

## Aliases
alias ls='ls --color=auto'
alias l='ls -lh'
alias ll='ls -lh'
alias la='ls -lhA'
alias less='less --quiet'
alias ffmpeg='ffmpeg -hide_banner'
alias grep='grep --color'
alias vim='nvim'
alias vi='nvim'
alias yeet='paru -Rcs'
alias gpgreset='pkill -SIGHUP gpg-agent'

mkcd() {
    mkdir -p -- "$1" && cd -- "$1"
}

## Keychain
eval $(keychain --eval --quiet --agents gpg)
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi

## DirEnv
eval "$(direnv hook zsh)"

## FZF
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
export FZF_DEFAULT_COMMAND='fd . -t f --hidden'
export FZF_CTRL_T_COMMAND='fd . -t f --hidden'
export FZF_ALT_C_COMMAND='fd . -t d --hidden'
