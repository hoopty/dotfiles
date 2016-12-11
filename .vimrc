syntax on

set encoding=utf-8

set bg=dark
set ruler
"set virtualedit=all

set nocompatible
set nomodeline
set paste

"set expandtab       "Use softtabstop spaces instead of tab characters for indentation
"set tabstop=4       "Show 4 spaces when a tabs are displayed
"set shiftwidth=4    "Indent by 4 spaces when using >>, <<, == etc.
"set softtabstop=4   "Indent by 4 spaces when pressing <TAB>

set autoindent      "Keep indentation from previous line
set smartindent     "Automatically inserts indentation in some cases
"set cindent         "Like smartindent, but stricter and more customisable
set smarttab

set ignorecase
set smartcase

set showmatch       "Show matching brackets
set incsearch       "Highlight search string matches as you type
set hlsearch        "Highlight all search patterns
set iskeyword-=_    "Treat _ as a word boundary

highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
"match ExtraWhitespace /\s\+$/                   " Show trailing whitespace
"match ExtraWhitespace /\s\+\%#\@<!$/            " Show trailing whitespace, except when typing at the end of a line
match ExtraWhitespace /\s\+$\| \+\ze\t/         " Show trailing whitespace and spaces before a tab
"match ExtraWhitespace /[^\t]\zs\t\+/            " Show tabs that are not at the start of a line

highlight OverLength ctermfg=white ctermbg=darkred ctermfg=white guibg=#FFD9D9
"2match OverLength '\%>79v.\+'

" vimpager specific
let vimpager_passthrough = 1

autocmd BufWritePost *.php silent! !php -l <afile> > /dev/null
autocmd BufWritePost *.py  silent! !pyflakes <afile> > /dev/null
