export ZSH="$HOME/.oh-my-zsh"
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump
export HISTFILE=$ZSH/log/.zsh_history   # Don't litter home folder
HIST_STAMPS="yyyy-mm-dd"                # Timestamp format

export EDITOR=nvim                      # Set neovim as my default text editor
export LESSHISTFILE=/dev/null           # Stop less creating a history file

export DATE=$(date +'%Y-%m-%d')

alias rm="echo 'use trash\n'"
alias chromium='chromium --guest --no-default-browser-check'
alias qmv='fd . --color=never -t f | qmv'
alias vidir='fd . | vidir -'
alias vlc='cvlc --play-and-exit --fullscreen --no-video-title -d --mouse-hide-timeout 1'
alias du='du -sh ./*'


setopt RC_QUOTES                        # Use '' in quoted strings to insert '
source ~/Coding/dotfiles/zsh/nicoulaj.zsh-theme

autoload -U compinit; compinit
