if &compatible
  set compatible
endif

filetype plugin indent on
syntax enable

set encoding=utf-8
set mouse=a
set t_Co=256
set whichwrap=b,s,h,l,<,>,[,]

set background=dark

autocmd ColorScheme * highlight Normal ctermbg=none
colorscheme hybrid_material

set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L
set guioptions-=b

set backspace=indent,eol,start
set tabstop=2
set shiftwidth=2
set softtabstop=0
set expandtab

set autoindent
set cindent
set smartindent
set shiftround

set wrap
set display=lastline

set wildignorecase
set wildmode=list:full

set ignorecase
set smartcase
set wrapscan
set incsearch
set hlsearch

set title
set number
set showcmd
set showmatch
set laststatus=2

set t_vb=
set novisualbell

set iskeyword-=_
set matchpairs& matchpairs+=<:>

set wildmenu
set hidden
set nobackup
set noswapfile
set nowritebackup

set clipboard^=unnamed,unnamedplus

map q: :q
nmap <silent> <Esc><Esc> :nohlsearch<CR>

noremap j gj
noremap k gk

nnoremap ; :

let g:enable_bold_font = 1
let g:lightline = { 'colorscheme': 'hybrid' }
