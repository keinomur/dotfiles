#=======================================================#
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  zsh-autosuggestions
  zsh-syntax-highlighting
  fzf
  ansible
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
#=======================================================#

export PATH=/home/keinomur/.local/bin:/home/keinomur/.npm-global/bin:$PATH

# ベル音を無効化
setopt no_beep

# 履歴の設定
setopt HIST_IGNORE_DUPS      # 直前と同じコマンドは履歴に追加しない
setopt HIST_IGNORE_ALL_DUPS  # 履歴中の重複行をすべて削除
setopt HIST_FIND_NO_DUPS     # 履歴検索中、重複を飛ばす
setopt HIST_SAVE_NO_DUPS     # 履歴ファイルに重複を保存しない
setopt HIST_IGNORE_SPACE     # スペースで始まるコマンドは履歴に追加しない

# 特定のコマンドを履歴から除外
export HISTORY_IGNORE="(ls|ls *|cd|cd *|pwd|exit|clear)"

# 補完機能の有効化
autoload -Uz compinit && compinit

# 大文字小文字を区別しない補完
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# 補完候補をメニュー表示
zstyle ':completion:*:default' menu select=2

# 補完候補に色をつける
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

alias ls="ls -G"
alias ll="ls -l"
alias la="ls -a"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias rm="rm -i"
alias cm="claude-monitor --timezone Asia/Tokyo"

. "$HOME/.local/bin/env"

# LS_COLORS configuration for One Half Dark theme
if [ -f ~/.dircolors ]; then
    eval "$(dircolors ~/.dircolors)"
else
    eval "$(dircolors -b)"
fi

# Enable colored output for ls
alias ls='ls --color=auto'
alias ll='ls -alF --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias vim="nvim"

# fzf設定
export FZF_DEFAULT_OPTS="--layout=reverse --height=40% \
--color=bg+:#4c566a,bg:#2e3440,spinner:#81a1c1,hl:#616e88 \
--color=fg:#d8dee9,header:#616e88,info:#81a1c1,pointer:#bf616a \
--color=marker:#ebcb8b,fg+:#eceff4,prompt:#81a1c1,hl+:#81a1c1"

# Ctrl+Rで履歴番号を非表示にする
export FZF_CTRL_R_OPTS="--no-sort --preview 'echo {}' --preview-window=down:3:wrap"

# カスタムhistory widget（履歴番号なし）
fzf-history-widget-no-numbers() {
  local selected
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
  selected=($(fc -rl 1 | awk '{ $1=""; print substr($0,2) }' |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m --bind='ctrl-/:toggle-preview'" $(__fzfcmd)))
  local ret=$?
  if [ -n "$selected" ]; then
    zle -U -- "$selected"
  fi
  zle reset-prompt
  return $ret
}
zle -N fzf-history-widget-no-numbers
bindkey '^R' fzf-history-widget-no-numbers

# 失敗したコマンドを履歴に保存しない
zshaddhistory() {
  local last_status="${?}"
  if [[ "${last_status}" -ne 0 ]]; then
    return 1  # 履歴に追加しない
  fi
  # HISTORY_IGNOREパターンに一致する場合も除外
  emulate -L zsh
  if [[ "${1%%$'\n'}" =~ ${~HISTORY_IGNORE} ]]; then
    return 1
  fi
  return 0
}

# tmux関連の設定とエイリアス
alias tm="tmux"
alias tma="tmux attach"
alias tmls="tmux list-sessions"
alias tmks="tmux kill-session"

# tmuxセッション内でzshのテーマが正しく表示されるように
if [[ -n "$TMUX" ]]; then
    export TERM="screen-256color"
fi

# Ansible specific aliases and functions
alias ap="ansible-playbook"
alias av="ansible-vault"
alias ai="ansible-inventory"
alias ag="ansible-galaxy"
alias al="ansible-lint"

# Ansible environment variables
export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_NOCOWS=1

# Function to run ansible-playbook with common options
aprun() {
    if [ $# -eq 0 ]; then
        echo "Usage: aprun <playbook.yml> [additional options]"
        return 1
    fi
    ansible-playbook -i inventory "$@"
}

# Function to encrypt/decrypt ansible vault files
avault() {
    case "$1" in
        enc|encrypt)
            shift
            ansible-vault encrypt "$@"
            ;;
        dec|decrypt)
            shift
            ansible-vault decrypt "$@"
            ;;
        view)
            shift
            ansible-vault view "$@"
            ;;
        edit)
            shift
            ansible-vault edit "$@"
            ;;
        *)
            echo "Usage: avault [enc|dec|view|edit] <file>"
            ;;
    esac
}

# Ansible completion for custom functions
compdef aprun=ansible-playbook
compdef avault=ansible-vault

export GIT_EDITOR=vim
