" エンコーディング次第でうまくいかないプラグイン対策
set encoding=utf-8

" バンドルのセットアップ {{{
" + プラグインが実際にインストールされるディレクトリ
let s:dein_dir = expand('~/.cache/dein')
" dein.vim 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" + dein.vim がなければ github から落としてくる
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . s:dein_repo_dir
endif

" + プラグイン初期化
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " プラグインリストを収めた TOML ファイル
  let g:rc_dir    = expand('~/.vim/rc')
  let g:dein      = g:rc_dir . '/dein.toml'
  let g:dein_lazy = g:rc_dir . '/dein_lazy.toml'

  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(g:dein,      {'lazy': 0})
  call dein#load_toml(g:dein_lazy, {'lazy': 1})

  " 設定終了
  call dein#end()
  call dein#save_state()
endif

" もし、未インストールものものがあったらインストール
if dein#check_install()
  call dein#install()
endif
" }}}

" 基本的な見た目の設定{{{
syntax on

set number " 行番号を表示
set cursorline " 現在の行を強調表示
set cursorcolumn " 現在の行を強調表示（縦）
set virtualedit=onemore " 行末の1文字先までカーソルを移動できるように
set smartindent " インデントはスマートインデント
set visualbell " ビープ音を可視化
set showmatch " 括弧入力時の対応する括弧を表示
set laststatus=2 " ステータスラインを常に表示
set wildmode=list:longest " コマンドラインの補完
set notitle
"}}}

" 基本設定{{{
set nocompatible
set fenc=utf-8 "文字コードをUFT-8に設定
set backup " バックアップファイルを作る
set noswapfile " スワップファイルを作らない
set autoread " 編集中のファイルが変更されたら自動で読み直す
set hidden " バッファが編集中でもその他のファイルを開けるように
set showcmd " 入力中のコマンドをステータスに表示する

set foldmethod=marker

" undofileが作られるディレクトリを調整
set undodir=~/var/vim/undo

cd ~
set mouse=
"}}}

" キーバインド{{{
" + 折り返し時に表示行単位での移動できるようにする
nnoremap j gj
nnoremap k gk

" + 矢印キー禁止
noremap <LEFT> <NOP>
noremap <RIGHT> <NOP>
noremap <UP> <NOP>
noremap <DOWN> <NOP>

noremap! <LEFT> <NOP>
noremap! <RIGHT> <NOP>
noremap! <UP> <NOP>
noremap! <DOWN> <NOP>

" + vimrc関係をすぐに編集
nnoremap <silent> <F5><F5> :vsplit ~/vimfiles/_vimrc<CR>
nnoremap <silent> <F5>g :vsplit ~/vimfiels/_gvimrc<CR>
nnoremap <silent> <F5>d :execute "vsplit ~/vimfiles/_vim/rc/dein.toml"<CR>
nnoremap <silent> <F5>l :execute "vsplit ~/vimfiles/_vim/rc/dein_lazy.toml"<CR>
nnoremap <silent> <expr> <F6> ":source $MYVIMRC \| :source $MYGVIMRC\<CR>"

" + タブ切り替えなど{{{
nnoremap <expr> ts ":split "
nnoremap <expr> tv ":vsplit "

nnoremap th <C-w>h
nnoremap tj <C-w>j
nnoremap tk <C-w>k
nnoremap tl <C-w>l
nnoremap tw <C-w>w

nnoremap tH <C-w>H
nnoremap tJ <C-w>J
nnoremap tK <C-w>K
nnoremap tL <C-w>L
nnoremap tr <C-w>r

nnoremap t= <C-w>=
nnoremap t> <C-w>>
nnoremap t< <C-w><
nnoremap t+ <C-w>+
nnoremap t- <C-w>-

nnoremap tn gt
nnoremap tp gT

nnoremap tq :q<CR>

" タブで開く、を上書き
nnoremap tt <Nop>
" + }}}

" + スペースキー関係
nnoremap <SPACE> <Nop>
nnoremap <silent> <SPACE>r :reg<CR>

" + コマンド/インサート モード中はCTRLで移動できるように
cnoremap <C-H> <LEFT>
cnoremap <C-J> <DOWN>
cnoremap <C-K> <UP>
cnoremap <C-L> <RIGHT>
" + Delキー
noremap! <C-D> <DEL>
" }}}

" NERDTree {{{
au FileType nerdtree nmap <buffer> za o
au FileType nerdtree nnoremap <buffer> <silent> <SPACE>n :q<CR>
" }}}

" Tab系{{{
set list listchars=tab:\>\- " 不可視文字を可視化(タブが「>-」と表示される)
set expandtab " Tab文字を半角スペースにする
set tabstop=2 " 行頭以外のTab文字の表示幅（スペースいくつ分）
set shiftwidth=2 " 行頭でのTab文字の表示幅
"}}}

" 検索系{{{
" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch
" 検索時に最後まで行ったら最初に戻る
set wrapscan
" 検索語をハイライト表示
set hlsearch
" ハイライト解除
nmap <silent> <Esc><Esc> :nohlsearch<CR><Esc>
"}}}

" 行末スペースハイライト{{{
augroup HighlightTrailingSpaces
  autocmd!
  autocmd VimEnter,WinEnter,ColorScheme * highlight TrailingSpaces term=underline guibg=Red ctermbg=Red
  autocmd VimEnter,WinEnter * match TrailingSpaces /\s\+$/
augroup END
" }}}

" vimとFinder, terminalへの橋渡し{{{
if has('mac')
  nnoremap <silent> <SPACE>e :!open .<CR>
  nnoremap <silent> <SPACE>o :!open -a Terminal.app .<CR>
elseif has('win32')
  nnoremap <silent> <expr> <SPACE>e ":!explorer .\<CR>"
  nnoremap <silent> <SPACE>o :!cmd<CR>
endif

"}}}

" GVIMの設定{{{
if has('gui')
  set guioptions+=e
  set guioptions-=m " メニューバーを消す
  set guioptions-=T " ツールバーを消す
  " スクロールバーを消す
  set guioptions-=r
  set guioptions-=R
  set guioptions-=l
  set guioptions-=L
endif
" }}}

" 見た目の設定 for CUI{{{
colorscheme molokai
set guifont=Myrica\ M:h12,Osaka-Mono:h14
set t_Co=256
set lines=55
set columns=160
"}}}

