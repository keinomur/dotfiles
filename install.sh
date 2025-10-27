#!/bin/bash

# Dotfiles インストールスクリプト
# zsh、nvim、tmuxの開発環境をセットアップします

set -e

# 色の定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ログ関数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# スクリプトのディレクトリを取得
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.config/dotfiles_backup"

log_info "Dotfiles directory: $DOTFILES_DIR"

# バックアップディレクトリの作成
log_info "Creating backup directory..."
mkdir -p "$BACKUP_DIR"

# 既存の設定ファイルをバックアップ
backup_file() {
    local file=$1
    if [ -f "$file" ] || [ -L "$file" ]; then
        log_warning "Backing up existing file: $file"
        cp -L "$file" "$BACKUP_DIR/$(basename $file).$(date +%Y%m%d_%H%M%S)" 2>/dev/null || true
        rm -f "$file"
    fi
}

# シンボリックリンクを作成
create_symlink() {
    local source=$1
    local target=$2

    # ターゲットのディレクトリを作成
    mkdir -p "$(dirname $target)"

    # 既存ファイルのバックアップ
    backup_file "$target"

    # シンボリックリンクを作成
    ln -sf "$source" "$target"
    log_success "Created symlink: $target -> $source"
}

# OSの検出
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
    elif [ -f /etc/redhat-release ]; then
        OS="rhel"
    else
        OS="unknown"
    fi
    log_info "Detected OS: $OS"
}

# パッケージのインストール
install_packages() {
    log_info "Installing required packages..."

    case $OS in
        ubuntu|debian)
            sudo apt update
            sudo apt install -y git curl wget zsh tmux neovim \
                build-essential fzf ripgrep xclip nodejs npm || true
            ;;
        centos|rhel|fedora)
            sudo yum install -y git curl wget zsh tmux neovim \
                gcc gcc-c++ make fzf ripgrep xclip nodejs npm || true
            ;;
        *)
            log_warning "Unknown OS. Please install packages manually."
            log_warning "Required: git curl wget zsh tmux neovim build-essential fzf ripgrep xclip nodejs npm"
            ;;
    esac

    log_success "Package installation completed"
}

# Oh My Zshのインストール
install_oh_my_zsh() {
    log_info "Installing Oh My Zsh..."

    if [ -d "$HOME/.oh-my-zsh" ]; then
        log_warning "Oh My Zsh is already installed. Skipping..."
        return
    fi

    # Oh My Zshのインストール（非対話モード）
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true

    log_success "Oh My Zsh installed"
}

# Powerlevel10kテーマのインストール
install_powerlevel10k() {
    log_info "Installing Powerlevel10k theme..."

    local P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

    if [ -d "$P10K_DIR" ]; then
        log_warning "Powerlevel10k is already installed. Updating..."
        git -C "$P10K_DIR" pull
    else
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
    fi

    log_success "Powerlevel10k installed"
}

# zshプラグインのインストール
install_zsh_plugins() {
    log_info "Installing zsh plugins..."

    local CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    # zsh-autosuggestions
    if [ ! -d "$CUSTOM_DIR/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "$CUSTOM_DIR/plugins/zsh-autosuggestions"
        log_success "zsh-autosuggestions installed"
    else
        log_warning "zsh-autosuggestions already installed. Skipping..."
    fi

    # zsh-syntax-highlighting
    if [ ! -d "$CUSTOM_DIR/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$CUSTOM_DIR/plugins/zsh-syntax-highlighting"
        log_success "zsh-syntax-highlighting installed"
    else
        log_warning "zsh-syntax-highlighting already installed. Skipping..."
    fi
}

# vim-plugのインストール
install_vim_plug() {
    log_info "Installing vim-plug for Neovim..."

    local PLUG_FILE="$HOME/.local/share/nvim/site/autoload/plug.vim"

    if [ -f "$PLUG_FILE" ]; then
        log_warning "vim-plug is already installed. Skipping..."
        return
    fi

    curl -fLo "$PLUG_FILE" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    log_success "vim-plug installed"
}

# 設定ファイルのリンク作成
setup_symlinks() {
    log_info "Creating symlinks for configuration files..."

    # zsh
    create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
    create_symlink "$DOTFILES_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
    create_symlink "$DOTFILES_DIR/zsh/.dircolors" "$HOME/.dircolors"

    # nvim
    create_symlink "$DOTFILES_DIR/nvim/init.vim" "$HOME/.config/nvim/init.vim"
    create_symlink "$DOTFILES_DIR/nvim/coc-settings.json" "$HOME/.config/nvim/coc-settings.json"

    # tmux
    create_symlink "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"

    # bin/env
    mkdir -p "$HOME/.local/bin"
    create_symlink "$DOTFILES_DIR/bin/env" "$HOME/.local/bin/env"

    log_success "All symlinks created"
}

# Neovimプラグインのインストール
install_nvim_plugins() {
    log_info "Installing Neovim plugins..."

    # Neovimが利用可能か確認
    if ! command -v nvim &> /dev/null; then
        log_warning "Neovim is not installed. Skipping plugin installation..."
        return
    fi

    # プラグインのインストール
    nvim --headless +PlugInstall +qall 2>/dev/null || true

    log_success "Neovim plugins installed"
}

# coc.nvim拡張機能のインストール
install_coc_extensions() {
    log_info "Installing coc.nvim extensions..."

    # Node.jsが利用可能か確認
    if ! command -v node &> /dev/null; then
        log_warning "Node.js is not installed. Skipping coc extensions installation..."
        return
    fi

    # coc拡張機能のインストール
    nvim --headless +"CocInstall -sync coc-yaml coc-json coc-sh" +qall 2>/dev/null || true

    log_success "coc.nvim extensions installed"
}

# メイン処理
main() {
    echo ""
    echo "======================================"
    echo "  Dotfiles Installation Script"
    echo "======================================"
    echo ""

    # OS検出
    detect_os

    # パッケージのインストール確認
    read -p "Do you want to install required packages? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_packages
    else
        log_warning "Skipping package installation. Make sure required packages are installed."
    fi

    # Oh My Zshのインストール
    install_oh_my_zsh

    # Powerlevel10kのインストール
    install_powerlevel10k

    # zshプラグインのインストール
    install_zsh_plugins

    # vim-plugのインストール
    install_vim_plug

    # シンボリックリンクの作成
    setup_symlinks

    # Neovimプラグインのインストール
    read -p "Do you want to install Neovim plugins now? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_nvim_plugins
        install_coc_extensions
    else
        log_warning "Skipping Neovim plugin installation. Run ':PlugInstall' in Neovim manually."
    fi

    echo ""
    echo "======================================"
    echo "  Installation Complete!"
    echo "======================================"
    echo ""
    log_info "Next steps:"
    echo "  1. Change default shell to zsh: chsh -s \$(which zsh)"
    echo "  2. Logout and login again"
    echo "  3. Run 'p10k configure' to configure Powerlevel10k (if needed)"
    echo "  4. Install Nerd Font for proper icon display"
    echo "  5. Restart your terminal"
    echo ""
    log_info "Backup files are stored in: $BACKUP_DIR"
    echo ""
}

# スクリプトの実行
main "$@"
