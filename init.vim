set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching
set ignorecase smartcase    " case insensitive
set hlsearch                " highlight search
set incsearch               " incremental search

set tabstop=4               " number of columns occupied by a tab
set softtabstop=4           " see multiple spaces as tab stops so <BS> does the right thing
set expandtab               " converts tabs to white space
set autoindent              " indent a new line the same amount as the line just typed
set shiftwidth=4            " width for auto indents

set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions
syntax on                   " syntax highlighting
set mouse=a                 " enable mouse click
set clipboard=unnamedplus   " using system clipboard
filetype plugin on
filetype plugin indent on   " allow auto-indenting depending on file type
set ttyfast                 " Speed up scrolling in Vim
set spell                   " enable spell check (may need to download language package)

match OverLength /\%>80v.\+/ " Highlight over 80 lines
highlight OverLength ctermbg=darkblue " Set the background to darkblue
