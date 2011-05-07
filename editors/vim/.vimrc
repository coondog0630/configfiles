" ------------------
" |Default Options |
" ------------------
syntax on               " Turn on syntax highlighting

set t_Co=256
set number              " Turn on line numbering
set nocompatible        " this is vim, not vi: set this first
set autoread            " detect changes outside of vim
set visualbell         " flash instead of beep

set nofoldenable        " Folding
set foldmethod=syntax   

set splitbelow          " Window Splitting
set hlsearch
set history=1000        " Remember more histor
set selectmode=mouse    " Mouse Select Mode
"
set wildmenu            " List Long for tab completion
set wildmode=list:longest,full

set nobackup            " no backup files
set nowritebackup       " only in case you don't want a backup file while editing
set noswapfile          " no swap files

" Set the GUI Font
if has("gui")
  set guifont=ProggyTiny:h11
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

" preserves window when deleting buffer.
nnoremap <C-x><C-k> :enew \| bd #<CR>

" -----------------
" |Coding Options |
" -----------------
set tabstop=2           
set shiftwidth=2
set softtabstop=2
set expandtab
set smarttab

filetype plugin indent on           " Enable filetype-specific indenting on plugins

" -----------
" | Plugins |
" -----------
let g:rubycomplete_rails = 1        " Omni Complete


let g:NERDCreateDefaultMappings = 0 " NERDTree
let g:NERDSpaceDelims = 1
let g:NERDShutUp = 1
let g:NERDTreeHijackNetrw = 0
let g:NERDChristmasTree = 1
let g:NERDTreeWinPos = "right"
let g:NERDTreeCaseSensitiveSort = 1
let g:NERDTreeIgnore = ['\.vim$', '\-$','\.git']

" Cscope settings
if has ("cscope")
  set cscopetag cscopeverbose
  if has ("quickfix")
    set cscopequickfix=s-,c-,d-,i-,t-,e-
  endif

  cnoreabbrev csa cs  add
  cnoreabbrev csf cs  find
  cnoreabbrev csk cs  kill
  cnoreabbrev csr cs  reset
  cnoreabbrev css cs  show
  cnoreabbrev csh cs  help
endif

