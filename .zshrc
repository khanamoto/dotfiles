# --------------------------------------------------
# 一般設定
# --------------------------------------------------
# 補完機能の強化
autoload -U compinit && compinit
# プロンプトの色を変更する
autoload -Uz colors
colors
# 入力しているコマンド名が間違っている場合にもしかして：を出す
setopt correct
# ビープを鳴らさない
setopt nobeep
# バックグラウンドジョブが終了したらすぐに知らせる
setopt no_tify
# タブによるファイルの順番切り替えをしない
unsetopt auto_menu
# cd -[tab]で過去のディレクトリにひとっ飛びできるようにする
setopt auto_pushd
# ディレクトリ名を入力するだけでcdできるようにする
setopt auto_cd
# コマンドラインでも # 以降をコメントと見なす
setopt interactive_comments

# --------------------------------------------------
# ヒストリ設定
# --------------------------------------------------
# ヒストリファイル名
HISTFILE=$HOME/.zsh_history
# メモリに保存される履歴の件数
HISTSIZE=10000
# 履歴ファイルに保存される履歴の件数
SAVEHIST=10000
# 直前と同じコマンドをヒストリに追加しない
setopt hist_ignore_dups
# 重複するコマンドは古い法を削除する
setopt hist_ignore_all_dups
# 異なるウィンドウでコマンドヒストリを共有する
setopt share_history
# historyコマンドは履歴に登録しない
setopt hist_no_store
# 余分な空白は詰めて記録
setopt hist_reduce_blanks
# `!!`を実行したときにいきなり実行せずコマンドを見せる
setopt hist_verify

# --------------------------------------------------
# エイリアス設定
# --------------------------------------------------
alias ..='cd ..'
alias ..2='cd ../..'
alias ..3='cd ../../..'
alias v='vim'
alias g='git'
alias ga='git add'
alias gc='git commit'
alias gps='git push'
alias gpl='git pull'
alias gs='git status'
alias gb='git branch'
alias gco='git checkout'
alias gf='git fetch -p'
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
alias gla="git log --graph --all --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
alias gss='git stash --include-untracked'

# --------------------------------------------------
# プロンプト設定
# --------------------------------------------------
# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
autoload -Uz promptinit
promptinit
prompt pure

# --------------------------------------------------
# 環境変数設定
# --------------------------------------------------
# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# go
export GOPATH=$HOME/dev
export PATH=$PATH:$GOPATH/bin
# 研修用(Go 1.12)
# export GO111MODULE=on

# node.js
export PATH=$PATH:$HOME/.nodebrew/current/bin

# --------------------------------------------------
# その他設定
# --------------------------------------------------
# pecoとghqで簡単にリポジトリ移動をする
bindkey '^]' peco-src

function peco-src() {
  local src=$(ghq list --full-path | peco --query "$LBUFFER")
  if [ -n "$src" ]; then
    BUFFER="cd $src"
    zle accept-line
  fi
  zle -R -c
}
zle -N peco-src

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/khanamoto/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/khanamoto/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/khanamoto/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/khanamoto/google-cloud-sdk/completion.zsh.inc'; fi
