ZSH="$HOME/.oh-my-zsh"
ZSH_COMPDUMP=$ZSH/cache/.zcompdump

HISTFILE=$ZSH/log/.zsh_history
HISTSIZE=10000			 				# How much to load into memory
SAVEHIST=10000			 				# How many to write to file
setopt hist_ignore_all_dups				# History won't save duplicates.
setopt hist_find_no_dups				# History won't show duplicates on search.

export EDITOR=nvim                      # Set neovim as my default text editor
export PAGER=less
export LESSHISTFILE=/dev/null           # Stop less creating a history file

export DATE=$(date +'%Y-%m-%d')
alias du='du -sh ./*'
alias dl='trash'
alias rm="echo 'use trash (dl)'; true "		# Trailing 'true' so the args are discarded
alias chromium='chromium --guest --no-default-browser-check'
alias qmv='fd . --color=never -t f | qmv'
alias vlc='cvlc --play-and-exit --fullscreen --no-video-title --mouse-hide-timeout 1 --stereo-mode 1'
alias dirs='echo ${"$(\dirs -v)"[@]:4}'		# Don't show current dir

autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

setopt multios							# enable redirect to multiple streams: echo >file1 >file2
setopt long_list_jobs					# show long list format job notifications
setopt interactivecomments 				# recognize comments
setopt rc_quotes						# Use '' in quoted strings to insert '
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_minus

# Preserve dirstack
DIRSTACKSIZE=10		# ZSH config
DIRSTACKFILE=$ZSH/dirstack
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then		# If the dirstack file exists, and dirstack has size 0
	dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )						# load it ( the (f) means split on whitespace (characters defined in $IFS)
	[[ -d $dirstack[1] ]] && cd $dirstack[1] && cd $OLDPWD		# Preload #OLDPWD. Arrays are 1 indexed??
elif [[ ! -f $DIRSTACKFILE ]]; then
	touch $DIRSTACKFILE
fi

function chpwd() {
	print -l $PWD ${(u)dirstack}> $DIRSTACKFILE
}

source $ZSH/oh-my-zsh.sh
source $HOME/Coding/dotfiles/zsh/nicoulaj.zsh-theme
