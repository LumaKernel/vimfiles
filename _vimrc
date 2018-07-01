" エンコーディング次第でうまくいかないプラグイン対策
set encoding=utf-8
if &compatible
  set nocompatible
endif

let g:mapleader = " "

" 軽いと思う環境
let g:light = has("unix")

augroup MyAutoCmd
  autocmd!
augroup END

" dein settings {{{
filetype plugin indent off
let s:cache_home = expand('~/.cache')
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
let &runtimepath = s:dein_repo_dir .",". &runtimepath

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  call dein#add("~/.cache/dein")
  call dein#load_toml("~/vimfiles/dein.toml")
  call dein#end()
  call dein#save_state()
  if has('vim_starting') && dein#check_install()
    call dein#install()
  endif
endif
filetype plugin indent on
" }}}

" 基本的な見た目の設定{{{
syntax enable

set number
set cursorline
set cursorcolumn
set virtualedit=onemore " 行末の1文字先までカーソルを移動できるように
set smartindent " インデントはスマートインデント
set laststatus=2 " ステータスラインを常に表示
set notitle
set wrap

set noshowmatch
set novisualbell " 画面がガビガビする原因

"}}}

" MatchParen{{{
let g:loaded_matchparen = 1
"}}}

" 基本設定{{{
set fenc=utf-8 "文字コードをUFT-8に設定
set noswapfile " スワップファイルを作らない
set autoread " 編集中のファイルが変更されたら自動で読み直す
set hidden " バッファが編集中でもその他のファイルを開けるように
set showcmd " 入力中のコマンドをステータスに表示する
set wildmode=full:list

set foldmethod=marker

set backup
set backupdir=~/vimfiles/tmp

set undofile
set undodir=~/vimfiles/tmp

set matchpairs+=<:>

set scrolloff=7

set backspace=indent,eol,start

" beep音を消す
set belloff=all

set ttimeout " キーコードに問題はないが
set notimeout " マッピングのキー列をタイムアウトにしない

"}}}

" IME系{{{
augroup MyIMEGroup
  autocmd!
  autocmd InsertLeave * set iminsert=0
augroup END
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
nnoremap <silent> <F5><F5> :e ~/vimfiles/_vimrc<CR>
nnoremap <silent> <F5>g :e ~/vimfiles/_gvimrc<CR>
nnoremap <silent> <F5>d :e ~/vimfiles/dein.toml<CR>
nnoremap <silent> <F5>l :e ~/vimfiles/dein_lazy.toml<CR>

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

nnoremap <silent> <Leader>r :reg<CR>

" + コマンド モード中はCTRLで移動できるように
cnoremap <C-H> <LEFT>
cnoremap <C-J> <DOWN>
cnoremap <C-K> <UP>
cnoremap <C-L> <RIGHT>
" + Delキー
inoremap <C-L> <DEL>
cnoremap <C-D> <DEL>

" バッファ切り替え
nnoremap <silent> <C-H> :call <SID>myBufPrevious()<CR>
nnoremap <silent> <C-L> :call <SID>myBufNext()<CR>
nnoremap <silent> <C-J> :b#<CR>
" C-L をmap
nnoremap <silent> <C-K> <C-L>

let g:skipQF = 1

" myBufPrevious/Next {{{
function! s:myBufPrevious()
  if !exists("g:skipQF")
    let g:skipQF = 0
  endif
  bprevious
  if g:skipQF
    let l:count = 0
    while &ft == "qf" && l:count < 1
      bprevious
      let l:count = l:count + 1
    endwhile
  endif
endfunction

function! s:myBufNext()
  if !exists("g:skipQF")
    let g:skipQF = 0
  endif
  bnext
  if g:skipQF
    let l:count = 0
    while &ft == "qf" && l:count < 1
      bnext
      let l:count = l:count + 1
    endwhile
  endif
endfunction
" }}}

" }}}

" Tab系{{{
set list " 不可視文字表示
" 不可視文字を可視化
set listchars=tab:\»-,eol:\\,extends:»,precedes:«,nbsp:%
set expandtab " Tab文字を半角スペースにする
set tabstop=2 " 行頭以外のTab文字の表示幅(スペースいくつ分)
set shiftwidth=2 " 行頭でのTab文字の表示幅

" 全角スペース・行末のスペース・タブの可視化
" 全角スペース可視化のみ抜粋
if has("syntax")
    " PODバグ対策
    syn sync fromstart
    function! ActivateInvisibleIndicator()
        " 下の行の"　"は全角スペース
        syntax match InvisibleJISX0208Space "　" display containedin=ALL
        highlight InvisibleJISX0208Space term=underline ctermbg=Blue guibg=darkgray gui=underline
    endfunction
    augroup invisible
        autocmd! invisible
        autocmd BufNew,BufRead * call ActivateInvisibleIndicator()
    augroup END
endif

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
nmap <silent> <ESC><ESC> :nohlsearch<CR><ESC>
"}}}

" vimとFinder, terminalへの橋渡し{{{
if has('mac')
  nnoremap <silent> <Leader>e :!open .<CR>
  nnoremap <silent> <Leader>o :!open -a Terminal.app .<CR>
elseif has('win32')
  nnoremap <silent> <expr> <Leader>e ":!start explorer .\<CR>"
  nnoremap <silent> <Leader>o :!start cmd<CR>
endif
"}}}

" GVIMの設定{{{
if has('gui_running')
  set guioptions+=e
  set guioptions-=m " メニューバーを消す
  set guioptions-=T " ツールバーを消す
  " スクロールバーを消す
  set guioptions-=r
  set guioptions-=R
  set guioptions-=l
  set guioptions-=L

  if has('unix')
    set guifont=MyricaM\ M\ 14,Source\ Code\ Pro\ for\ Powerline\ 11,Source\ Code\ Pro\ 11
  else
    set guifont=Myrica\ M:h12,Osaka-Mono:h14
  endif
endif
set iminsert=0
" }}}

" c++ {{{

" private:とかのインデントを作らない(たぶん
set cinoptions=g0

augroup cpp-namespace
  autocmd!
  autocmd FileType cpp inoremap <buffer><expr>; <SID>expand_namespace()
augroup END
function! s:expand_namespace()
  let s = getline('.')[0:col('.')-1]
  if s =~# '\<b;;'
    return "\<BS>oost::"
  elseif s =~# '\<s;;'
    return "\<BS>\<BS>td::"
  elseif s =~# '\<d;;'
    return "\<BS>etail::"
  else
    return ';'
  endif
endfunction

" }}}

" 競プロ向け設定{{{

au FileType vimshell imap <buffer> <C-K> <Plug>(neosnippet_expand_or_jump)

au FileType text nnoremap <silent> <Leader>w :w!<CR>
let s:creg = has('unix') ? "+" : "*"

function! s:copyall()
  let l:cursor = getcurpos()
  execute 'normal! ggVG"' . s:creg . 'y'
  call setpos('.', l:cursor)
endfunction

nnoremap <silent> <Leader>c :call <SID>copyall()<CR>
if has('unix')
  nnoremap <silent> <Leader>v ggVGs<ESC>"+P:w!<CR>
else
  nnoremap <silent> <Leader>v ggVGs<ESC>"*P:w!<CR>
endif
nmap <Leader>t ggVGstemp

" <Leader>f#{a} で :e #{a}.cpp
for i in range(char2nr("a"), char2nr("z"))
  execute
        \ "nnoremap <Leader>f" . nr2char(i) . " " .
        \ ":e " . nr2char(i) . ".cpp\<CR>"
endfor

function! s:cp_cpp()
  " <Leader><F#{i}>
  " clipboard を "%:r" . _in#{i} に F#{i} キーで保存
  for i in range(1, 9)
    execute
          \ "nnoremap <expr><buffer> <Leader><F" . i .
          \'> ":e " . expand("%:r") . "_in' . i . '<CR>' .
          \ 'ggVG\"' . s:creg . 'P:w!<CR>2<C-O>"'
  endfor

  " <Leader>#{i} で "%:r" . _in#{i} を input として % を実行
  nnoremap <expr><buffer><Leader>0 ":ccl\|QuickRun\<CR>"
  for i in range(1, 9)
    execute
          \'nnoremap <expr><buffer> <Leader>' . i .
          \' ":ccl\|QuickRun -input " . expand("%:r") . "_in' . i .
          \'\<CR>"'
  endfor

  " F1押し間違えるので
  nnoremap <F1> <Nop>
endfunction

augroup MyAutoCmd
  autocmd Filetype cpp call <SID>cp_cpp()
augroup END

" }}}

