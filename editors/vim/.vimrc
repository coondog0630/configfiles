" ------------------
" |Default Options |
" ------------------
call pathogen#infect()  " Pathogen load
syntax on               " Turn on syntax highlighting

"set t_Co=256            " playing it safe and not going crazy with the colors
set ruler               " set the ruler
set number              " Turn on line numbering
set nocompatible        " this is vim, not vi: set this first
set autoread            " detect changes outside of vim
set visualbell         " flash instead of beep

set nofoldenable        " Folding
set foldmethod=syntax   

set splitbelow          " Window Splitting
set hlsearch
set history=1000        " Remember more histor
if has ("mouse")
  set mouse=a             " command line mouse-fu
  set mousehide
  set selectmode=mouse    " Mouse Select Mode
endif
"
set wildmenu            " List Long for tab completion
set wildmode=list:longest,full

set nobackup            " no backup files
set nowritebackup       " only in case you don't want a backup file while editing
set noswapfile          " no swap files

" Set the GUI Font
if has("gui")
  "set guifont=GraphicPixel:h10
  set guifont=Anonymous\ Pro:h10
  colorscheme vividchalk
else
  colorscheme vividchalk
endif

" --------------
" |Key Mappings|
" --------------
map <C-j> <C-W><Down>
map <C-k> <C-W><Up>
map <C-h> <C-W><Left>
map <C-l> <C-W><Right>
map <C-x><C-n> :NERDTree<CR>
map <C-x><C-t> :NERDTreeToggle<CR>
map <C-b><C-n> :bn<CR>
map <C-b><C-p> :bp<CR>

"set statusline=[%n]\ %<%.99f\ %h%w%m%r%y%{exists('g:loaded_rvm')?rvm#statusline():''}%=%-16(\ %l,%c-%v\ %)%P
set statusline=[%n]\ %<%.99f\ %h%w%m%r%y%{exists('g:loaded_fugitive')?fugitive#statusline():''}%{exists('g:loaded_rvm')?rvm#statusline():''}%=%-16(\ %l,%c-%v\ %)%P
"           
"Nerd Core
"            
let g:NERDCreateDefaultMappings = 0
let g:NERDSpaceDelims = 1
let g:NERDShutUp = 1
let g:NERDTreeHijackNetrw = 0
let g:NERDChristmasTree = 1
let g:NERDTreeWinPos = "left"
let g:NERDTreeCaseSensitiveSort = 1
let g:NERDTreeIgnore = ['\.vim$', '\-$','\.git']

