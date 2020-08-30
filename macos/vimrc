if &compatible
  set compatible
endif

set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')

  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
  call dein#add('Shougo/deoplete.nvim')

  call dein#add('roxma/nvim-yarp')
  call dein#add('roxma/vim-hug-neovim-rpc')

  call dein#add('editorconfig/editorconfig-vim')
  call dein#add('cohama/lexima.vim')
  call dein#add('junegunn/goyo.vim')

  call dein#add('kristijanhusak/vim-hybrid-material')
  call dein#add('itchyny/lightline.vim')
  call dein#add('cocopon/lightline-hybrid.vim')

  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable

if dein#check_install()
  call dein#install()
endif

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

set number
set showcmd
set showmatch
set laststatus=2

set title
set titlestring=nvim%(\ %)\|%(\ %)%f%(\ %)%m

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

autocmd FileType python setlocal autoindent
autocmd FileType python setlocal smartindent
autocmd FileType python setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType python setlocal tabstop=4 expandtab shiftwidth=4 softtabstop=4

map q: :q
nmap <silent> <Esc><Esc> :nohlsearch<CR>

noremap j gj
noremap k gk

nnoremap ; :

let g:deoplete#enable_at_startup = 1
call deoplete#custom#option("smart_case", v:true)

inoremap <expr><tab> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><BS> deoplete#smart_close_popup()."\<C-h>"

let g:enable_bold_font = 1
let g:lightline = { 'colorscheme': 'hybrid' }
