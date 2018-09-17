"---------------------
" 文字
"---------------------
" 読み込み時の文字コード
set encoding=utf-8
" Vim Script内でマルチバイトを使う場合
scriptencoding utf-8
" 保存時の文字コード
set fileencoding=utf-8
" 読み込み時の文字コードの自動判別. 左側が優先される
set fileencodings=ucs-boms,utf-8,euc-jp,cp932
" 改行コードの自動判別. 左側が優先される
set fileformats=unix,dos,mac

"---------------------
" 行
"---------------------
" 行数表示
set number
" 折り返し
set wrap

"---------------------
" インデント（Go向け）
"---------------------
set noexpandtab
set tabstop=4
set shiftwidth=4
set autoindent

"---------------------
" 作らない系
"---------------------
"スワップファイルを作らない
set noswapfile
"バックアップファイルを作らない
set nobackup
"undoファイルを作らない
set noundofile

"---------------------
" 検索
"---------------------
" インクリメンタルサーチ. １文字入力毎に検索を行う
set incsearch
" 検索パターンに大文字小文字を区別しない
set ignorecase
" 検索パターンに大文字を含んでいたら大文字小文字を区別する
set smartcase

"---------------------
" その他
"---------------------
" クリップボードの共有
set clipboard=unnamed
" イントロダクション非表示
set shortmess+=I

"---------------------
" dein
"---------------------
" プラグインが実際にインストールされるディレクトリ
let s:dein_dir = expand('~/.cache/dein')
" dein.vim 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vim がなければ github から落としてくる
if !isdirectory(s:dein_repo_dir)
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif
execute 'set runtimepath^=' . s:dein_repo_dir

" 設定開始
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " プラグインリストを収めた TOML ファイル
  " 予め TOML ファイルを用意しておく
  let s:toml      = s:dein_dir . '/.dein.toml'
  let s:lazy_toml = s:dein_dir . '/.dein_lazy.toml'

  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  " 設定終了
  call dein#end()
  call dein#save_state()
endif

" もし、未インストールものものがあったらインストール
if dein#check_install()
  call dein#install()
endif

"---------------------
" vim-goの設定
"---------------------
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1

"---------------------
" vim側の画面分割
"---------------------
" 画面分割
nmap ss :split<Return><C-w>w
nmap sv :vsplit<Return><C-w>w
" 画面移動
nmap <Space> <C-w>w
map s<left> <C-w>h
map s<up> <C-w>k
map s<down> <C-w>j
map s<right> <C-w>l
map sh <C-w>h
map sk <C-w>k
map sj <C-w>j
map sl <C-w>l
" 画面リサイズ
nmap <C-w><left> <C-w><
nmap <C-w><right> <C-w>>
nmap <C-w><up> <C-w>+
nmap <C-w><down> <C-w>-

"---------------------
" vimfilerの設定（ファイル表示）
"---------------------
nmap sf :VimFilerBufferDir<Return>
nmap sF :VimFilerExplorer -find<Return>
nmap sb :Unite buffer<Return>
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_safe_mode_by_default = 0
let g:vimfiler_enable_auto_cd = 0
let g:vimfiler_tree_leaf_icon = ''
let g:vimfiler_tree_opened_icon = '▾'
let g:vimfiler_tree_closed_icon = '▸'
let g:vimfiler_marked_file_icon = '✓'

"---------------------
" aleの設定（Lintエラー）
"---------------------
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" 特定のLintツールのみを有効にする
let g:ale_linters = {
\  'python': ['flake8'],
\}
" エラー間をキー操作で移動する
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
" ファイル保存時のみチェックする
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0
" ファイルオープン時にチェックしない
let g:ale_lint_on_enter = 0

"---------------------
" カラー
"---------------------
" True Color有効化
set termguicolors
" カラースキーム
colorscheme iceberg
syntax on

"---------------------
" プラグイン削除コマンド実装 :DeinClean
"---------------------
command! -bang DeinClean call s:dein_clean(<bang>0)

function! s:dein_clean(force) abort "{{{
  let del_all = a:force
  for p in dein#check_clean()
    if !del_all
      let answer = s:input(printf('Delete %s ? [y/N/a]', fnamemodify(p, ':~')))

      if type(answer) is type(0) && answer <= 0
        " Cancel (Esc or <C-c>)
        break
      endif

      if answer !~? '^\(y\%[es]\|a\%[ll]\)$'
        continue
      endif

      if answer =~? '^a\%[ll]$'
        let del_all = 1
      endif
    endif

    " Delete plugin dir
    call dein#install#_rm(p)
  endfor
endfunction "}}}

function! s:input(...) abort "{{{
  new
  cnoremap <buffer> <Esc> __CANCELED__<CR>
  try
    let input = call('input', a:000)
    let input = input =~# '__CANCELED__$' ? 0 : input
  catch /^Vim:Interrupt$/
    let input = -1
  finally
    bwipeout!
    return input
  endtry
endfunction "}}}