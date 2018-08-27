if &compatible
  set nocompatible
endif
set runtimepath+=~/.vim/bundles/repos/github.com/Shougo/dein.vim

call dein#begin(expand('~/.vim/bundles/'))

" dark power
call dein#add('Shougo/dein.vim')
call dein#add('Shougo/denite.nvim')
call dein#add('Shougo/deoplete.nvim')

" editor
call dein#add('editorconfig/editorconfig-vim')
call dein#add('junegunn/goyo.vim')
" call dein#add('w0rp/ale')

" move
call dein#add('easymotion/vim-easymotion')

" breacket
call dein#add('tpope/vim-surround')
call dein#add('jiangmiao/auto-pairs')

" indent
call dein#add('nathanaelkane/vim-indent-guides')

" utility
call dein#add('tyru/caw.vim')
call dein#add('junegunn/vim-easy-align')

" git
call dein#add('tpope/vim-fugitive')

" C++
call dein#add('octol/vim-cpp-enhanced-highlight')

" LaTeX
call dein#add('lervag/vimtex')

" web development
call dein#add('othree/html5.vim')
call dein#add('mattn/emmet-vim')
call dein#add('hail2u/vim-css3-syntax')
call dein#add('pangloss/vim-javascript')
call dein#add('mxw/vim-jsx')
call dein#add('styled-components/vim-styled-components')

" color scheme
call dein#add('w0ng/vim-hybrid')
call dein#add('cocopon/lightline-hybrid.vim')
call dein#add('itchyny/lightline.vim')

call dein#end()

filetype plugin indent on
syntax enable

if dein#check_install()
  call dein#install()
endif

" シンタックスハイライトを有効化
syntax on
" マウス機能を有効化
set mouse=a
" 256色ターミナルを有効化
set t_Co=256
" カーソルが行頭行末で停止しない
set whichwrap=b,s,h,l,<,>,[,]

" default shell in Terminal mode
set sh=zsh

" 暗色背景を設定
set background=dark
" カラースキームを設定
let g:hybrid_custom_term_colors = 1
colorscheme hybrid

" メニューバーを非表示
set guioptions-=m
" ツールバーを非表示
set guioptions-=T
" スクロールバーを非表示
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L
set guioptions-=b

" open file with ignore character size
set wildignorecase
set wildmode=list:full

" 検索文字列が小文字のみの場合は大文字小文字区別なく検索
set ignorecase
" 検索文字列に大文字が含まれている場合は区別して検索
set smartcase
" 検索対象と一致したものがファイル末尾まで到達したら最初に戻る
set wrapscan
" インクリメンタルサーチを有効化
set incsearch
" 検索にヒットしたものをハイライト
set hlsearch

" 行番号を表示
set number
" タイトルを表示
set title
" 入力中のコマンドをステータスラインに表示
set showcmd
" 括弧入力時に対応する括弧を明示
set showmatch
" ステータスラインを常に表示
set laststatus=2
" GUIでの使用フォントを指定
set guifont=CicaE\ 14
" スクリーンベルを無効化
set t_vb=
set novisualbell

" 改行などのバックスペースを有効化
set backspace=indent,eol,start
" タブ幅を指定
set tabstop=2
" インデントの深さを指定
set shiftwidth=2
" タブ文字編集時の扱いを指定
set softtabstop=0
" ソフトタブを有効化
set expandtab
" 手前の行と同じ深さのインデントを保持
set autoindent
" いくつかのC構文を認識
set smartindent
" C構文を認識
set cindent
" 折り返し表示を有効化
set wrap
" ウィンドウ高さを超える行について最大限表示
set display=lastline
" インデントの深さをshiftwidthの倍数に丸める
set shiftround
" 補完で大文字小文字を区別しない
set infercase
" 対応する括弧ペアに<と>の組み合わせを追加
set matchpairs& matchpairs+=<:>

" コマンドラインモードでTABによるファイル名補完を有効化
set wildmenu
" 保存されていないファイルが存在しても他のファイルを開けるようにする
set hidden
" バックアップファイルを生成しない
set nobackup
" スワップファイルを生成しない
set noswapfile
" ファイル上書き前にバックアップを生成しない
set nowritebackup
" クリップボードとヤンクを共有する
set clipboard=unnamedplus


" ハイライトを消去
nmap <silent> <Esc><Esc> :nohlsearch<CR>

" 折り返し表示の行の通りに移動する
noremap j gj
noremap k gk

" コマンド実行のタイプミスを補完
noremap ; :

" 挿入モード中に行頭/行末へ移動
inoremap <C-h> <Home>
inoremap <C-l> <End>

" 貼り付け時に対象の末尾へカーソルを移動
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

" 不要なウィンドウのポップアップを抑制
map q: :q

" ESC going to normal mode in Terminal mode
tnoremap <silent> <ESC> <C-\><C-n>

" HTMLのとじタグを補完
autocmd FileType html inoremap <silent> <buffer> </ </<C-x><C-o>

" Markdownでは行末の空白を除去しない
function! Rstrip()
  let s:tmppos = getpos(".")
  if &filetype == "markdown"
    %s/\v(\s{2})?(\s+)?$/\1\e
    match Underlined /\s\{2}$/
  else
    %s/\v\s+$//e
  endif
  call setpos(".", s:tmppos)
endfunction
autocmd BufWritePre * :call Rstrip()

"検索時のジャンプ移動の際、対象を画面中央に捕捉
nnoremap n nzz
nnoremap n Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" Resize bindings
nnoremap <S-Left> <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up> <C-w>-<CR>
nnoremap <S-Down> <C-w>+<CR>


let g:python_host_prog = '/usr/local/bin/python2'
let g:python3_host_prog = '/usr/local/bin/python3'

" deoplete.nvim
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#enable_fuzzy_completion = 1
let g:deoplete#sources#syntax#min_keyword_length = 2

inoremap <expr><tab> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><BS> deoplete#smart_close_popup()."\<C-h>"

" " ale
" let g:ale_lint_on_enter = 0
" let g:ale_sign_column_always = 0
" let g:ale_lint_on_text_changed = 'never'
" let g:ale_sign_error = "E"
" let g:ale_sign_warning = "W"

" vim-easymotion
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)

nmap s <Plug>(easymotion-overwin-f2)
vmap s <Plug>(easymotion-bd-f2)

map  <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

let g:EasyMotion_do_mapping = 0

" caw.vim
nmap <Leader>c <Plug>(caw:hatpos:toggle)
vmap <Leader>c <Plug>(caw:hatpos:toggle)

" vim-easy-align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" lightline.vim
let g:lightline = { 'colorscheme': 'hybrid' }

" vimtex
let g:tex_flavor = "latex"

let g:vimtex_latexmk_enabled = 1
let g:vimtex_latexmk_options = '-pdfdvi'
let g:vimtex_view_method = 'general'
let g:vimtex_view_general_viewer = 'open'
let g:vimtex_compiler_progname = 'nvr'

" vim-jsx
let g:jsx_ext_required = 0
