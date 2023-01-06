# MISC SETTINGS
#
export ZSH="$HOME/.oh-my-zsh"
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump
export HISTFILE=$ZSH/log/.zsh_history   # Don't litter home folder
ZSH_THEME="nicoulaj"
HIST_STAMPS="yyyy-mm-dd"                # Timestamp format
export MOZ_ENABLE_WAYLAND=1             # Set firefox to use wayland
export EDITOR=nvim                      # Set neovim as my default text editor
export LESSHISTFILE=/dev/null           # Stop less creating a history file

alias rm=trash-put                      # Move to trash instead of permantenty deleting

setopt RC_QUOTES                        # Use '' in quoted strings to insert '




zstyle ':omz:update' mode reminder	# just remind me to update when it's time
zstyle ':omz:update' frequency 14	# Check every 14 days


plugins=(git)

source $ZSH/oh-my-zsh.sh
