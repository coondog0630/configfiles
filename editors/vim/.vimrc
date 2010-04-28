" Turn on syntax highlighting
syntax on

" Turn on line numbering
set number
" Highlight search patterns
set hlsearch
" Remember more history
set history=1000
" Mouse Select Mode
set selectmode=mouse
" Enable filetype-specific indenting on plugins
filetype plugin indent on

" Set the number of columns and lines
" set lines=80
" set columns=100

" Tabbing and Spaces for coding
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set smarttab

" List Long for tab completion
set wildmenu
set wildmode=list:longest,full

" Mouse hotness in console
set mouse=a

" Omni Complete
let g:rubycomplete_rails = 1

" Set the GUI Font
if has("gui")
  "set guifont=ProFontX:h9
  set guifont=ProggyTiny:h11
  "set guifont=Deka:h10
  colorscheme darkblue
else
  colorscheme elflord
endif
