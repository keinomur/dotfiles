# Dotfiles

開発環境の設定ファイル集（zsh、nvim、tmux）

## 概要

このリポジトリには、以下のツールの設定ファイルが含まれています：

- **zsh**: Oh My Zsh + Powerlevel10k テーマ
- **nvim**: NeoVim + vim-plug + 各種プラグイン
- **tmux**: ターミナルマルチプレクサ設定

## 必要な依存関係

### 基本ツール
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install -y git curl wget zsh tmux neovim build-essential

# CentOS/RHEL
sudo yum install -y git curl wget zsh tmux neovim gcc gcc-c++ make
```

### その他の依存関係
- **fzf**: ファジーファインダー
- **ripgrep**: 高速grep代替ツール
- **xclip**: クリップボード連携（tmux用）
- **Node.js**: coc.nvim用（推奨: v16以上）

```bash
# Ubuntu/Debian
sudo apt install -y fzf ripgrep xclip nodejs npm

# CentOS/RHEL
sudo yum install -y fzf ripgrep xclip nodejs npm
```

## インストール手順

### 1. リポジトリのクローン

```bash
cd ~
git clone https://github.com/keinomur/dotfiles.git
cd dotfiles
```

### 2. インストールスクリプトの実行

```bash
chmod +x install.sh
./install.sh
```

インストールスクリプトは以下の処理を行います：
- 必要なツールの確認とインストール
- Oh My Zshのインストール
- Powerlevel10kテーマのインストール
- zshプラグインのインストール
- 設定ファイルのシンボリックリンク作成
- vim-plugのインストール
- Neovimプラグインのインストール

### 3. 手動での設定（必要に応じて）

#### zshをデフォルトシェルに設定
```bash
chsh -s $(which zsh)
```

ログアウトして再度ログインすると、zshがデフォルトシェルになります。

#### Powerlevel10kの設定
初回起動時に、Powerlevel10kの設定ウィザードが表示されます。
または、以下のコマンドで手動で設定できます：
```bash
p10k configure
```

#### Node.jsのバージョン確認（coc.nvim用）
```bash
node --version  # v16以上を推奨
```

Node.jsが古い場合は、nvmなどを使用してアップデートしてください。

## 設定内容

### zsh (.zshrc)

#### テーマ
- Powerlevel10k: 高速で美しいプロンプトテーマ

#### プラグイン
- `zsh-autosuggestions`: コマンドの自動提案
- `zsh-syntax-highlighting`: コマンドのシンタックスハイライト
- `fzf`: ファジーファインダー連携
- `ansible`: Ansible用の補完とエイリアス

#### 主なエイリアス
```bash
alias vim="nvim"
alias ll="ls -alF --color=auto"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias tm="tmux"
alias tma="tmux attach"
```

#### カスタム機能
- 履歴の重複除外
- fzfによる履歴検索（Ctrl+R）
- カラー設定（One Half Dark テーマ）

### nvim (init.vim)

#### プラグインマネージャー
- vim-plug: 自動インストール機能付き

#### 主要プラグイン
- `NERDTree`: ファイルエクスプローラー
- `fzf.vim`: ファジーファインダー
- `coc.nvim`: LSP補完機能
- `ansible-vim`: Ansible構文サポート
- `ale`: リンターと自動修正
- `vim-airline`: ステータスライン
- `onehalf`: カラースキーム

#### キーマップ
- `Ctrl+n`: NERDTreeのトグル
- `Ctrl+f`: 現在のファイルをNERDTreeで表示
- `ff`: ファイル検索（fzf）
- `fr`: テキスト検索（ripgrep + fzf）
- `Ctrl+h/j/k/l`: ウィンドウ間の移動

#### 自動設定
- YAML/Ansibleファイルは自動的にインデント幅2スペースに設定
- 保存時のlintは無効（手動でのlintを推奨）

### tmux (.tmux.conf)

#### プレフィックスキー
- `Ctrl+t`: tmuxのプレフィックスキー（デフォルトのCtrl+bから変更）

#### 主なキーバインド
- `Prefix + \`: 横分割
- `Prefix + -`: 縦分割
- `Prefix + h/j/k/l`: ペイン移動（vim風）
- `Prefix + H/J/K/L`: ペインのリサイズ
- `Prefix + m`: ペインの最大化/最小化
- `Prefix + r`: 設定ファイルのリロード

#### 機能
- マウス操作のサポート
- vim風のコピーモード
- クリップボード連携（xclip使用）
- 256色サポート
- ステータスバーのカスタマイズ

## トラブルシューティング

### Powerlevel10kのフォントが正しく表示されない
Nerd Fontをインストールしてターミナルのフォント設定を変更してください：
```bash
# 推奨フォント: MesloLGS NF
# https://github.com/romkatv/powerlevel10k#fonts
```

### coc.nvimが動作しない
Node.jsのバージョンを確認し、v16以上にアップデートしてください：
```bash
node --version
```

### nvimプラグインがインストールされない
nvimを起動して、手動でプラグインをインストール：
```vim
:PlugInstall
```

### tmuxでクリップボードが動作しない
xclipがインストールされているか確認：
```bash
sudo apt install xclip  # Ubuntu/Debian
sudo yum install xclip  # CentOS/RHEL
```

## アップデート

設定を更新した場合は、以下の手順で適用します：

```bash
cd ~/dotfiles
git pull
./install.sh
```

## バックアップ

インストールスクリプトは、既存の設定ファイルを `~/.config/dotfiles_backup/` にバックアップします。

元に戻す場合：
```bash
# シンボリックリンクを削除
rm ~/.zshrc ~/.p10k.zsh ~/.tmux.conf ~/.config/nvim/init.vim ~/.config/nvim/coc-settings.json

# バックアップから復元
cp ~/.config/dotfiles_backup/.zshrc ~/ 2>/dev/null
cp ~/.config/dotfiles_backup/.tmux.conf ~/ 2>/dev/null
cp ~/.config/dotfiles_backup/init.vim ~/.config/nvim/ 2>/dev/null
```

## ライセンス

MIT License

## 作成者

keinomur
