" Neovim Configuration with NERDTree
" This file should be placed at ~/.config/nvim/init.vim

" Install vim-plug if not found
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" Plugins
call plug#begin('~/.local/share/nvim/plugged')

" NERDTree - File explorer
Plug 'preservim/nerdtree'

" NERDTree Git plugin
Plug 'Xuyuanp/nerdtree-git-plugin'

" fzf - Fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Devicons for NERDTree (requires Nerd Font) - disabled due to font issues
" Plug 'ryanoasis/vim-devicons'

" Better syntax highlighting (disabled due to compatibility issues with nvim 0.6.1)
" Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Color scheme
Plug 'sonph/onehalf', { 'rtp': 'vim' }

" Status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Ansible and YAML support
Plug 'pearofducks/ansible-vim'              " Ansible syntax highlighting and indentation
Plug 'stephpy/vim-yaml'                      " Better YAML support
" Plug 'pedrohdz/vim-yaml-folds'              " YAML folding (無効化 - level/lines表示の原因)
Plug 'dense-analysis/ale'                    " Linting and fixing (ansible-lint, yamllint)
Plug 'Yggdroot/indentLine'                  " Show indentation guides

" LSP support for better autocompletion (optional but recommended)
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" GitHub Copilot (disabled)
" Plug 'github/copilot.vim'

call plug#end()

" Basic Settings
set number                    " Show line numbers
" set relativenumber           " Show relative line numbers
set expandtab                " Use spaces instead of tabs
set tabstop=4                " Tab width
set shiftwidth=4             " Indent width
set softtabstop=4            " Soft tab width
set autoindent               " Auto indent
set smartindent              " Smart indent
set wrap                     " Wrap lines
set ignorecase               " Ignore case in search
set smartcase                " Smart case sensitivity
set incsearch                " Incremental search
set hlsearch                 " Highlight search results
set scrolloff=8              " Keep 8 lines visible when scrolling
set sidescrolloff=8          " Keep 8 columns visible when scrolling
set mouse=a                  " Enable mouse support
set clipboard=unnamedplus    " Use system clipboard
set termguicolors            " True color support
set fillchars=eob:\          " Hide tildes on empty lines

" Color scheme
colorscheme onehalfdark

" Make line numbers less prominent
highlight LineNr ctermfg=darkgray guifg=#5c6370 cterm=NONE gui=NONE

" NERDTree Configuration
let g:NERDTreeWinSize=30
let g:NERDTreeShowHidden=1
let g:NERDTreeMinimalUI=1
let g:NERDTreeDirArrows=1
let g:NERDTreeAutoDeleteBuffer=1

" Key mappings
" Toggle NERDTree
nnoremap <C-n> :NERDTreeToggle<CR>
" Find current file in NERDTree
nnoremap <C-f> :NERDTreeFind<CR>
" Open terminal in current directory
nnoremap <C-t> :terminal<CR>
" Easy escape from terminal mode (use <C-\><C-n> or :q to exit terminal)
" tnoremap <Esc> <C-\><C-n>  " Commented out - use default ESC behavior

" Tab management
nnoremap <C-t> :tabnew<CR>:terminal<CR>
nnoremap <Tab> :tabnext<CR>
nnoremap <S-Tab> :tabprevious<CR>
nnoremap <C-w>c :tabclose<CR>
" Switch to existing terminal buffer
nnoremap <Leader>t :buffer term://<Tab>

" Open NERDTree automatically when nvim starts up
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Close vim if NERDTree is the only window remaining
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Close vim when :q is used in NERDTree
autocmd FileType nerdtree cnoreabbrev <buffer> q qa

" NERDTree Git plugin customization
let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ 'Modified'  :'M',
    \ 'Staged'    :'S',
    \ 'Untracked' :'U',
    \ 'Renamed'   :'R',
    \ 'Unmerged'  :'═',
    \ 'Deleted'   :'D',
    \ 'Dirty'     :'✗',
    \ 'Ignored'   :'☒',
    \ 'Clean'     :'✔︎',
    \ 'Unknown'   :'?',
    \ }

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Better escape (optional - comment out if you don't want these)
" inoremap jk <Esc>
" inoremap kj <Esc>

" Clear search highlighting
nnoremap <leader><space> :nohlsearch<CR>

" fzf mappings - always open in main window (not NERDTree)
nnoremap ff :wincmd l<CR>:Files<CR>
nnoremap fr :wincmd l<CR>:Rg<CR>

" fzf settings
let g:fzf_layout = { 'down': '40%' }

" fzf key bindings - ESC to close
autocmd FileType fzf tnoremap <buffer> <Esc> <C-c>

" Airline configuration
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='onehalfdark'

" Ansible-vim configuration
let g:ansible_unindent_after_newline = 1
let g:ansible_extra_keywords_highlight = 1
let g:ansible_name_highlight = 'b'
let g:ansible_attribute_highlight = "ob"
let g:ansible_yamlKeyName = 'yamlKey'

" Auto-detect Ansible files
au BufRead,BufNewFile */playbooks/*.yml set filetype=yaml.ansible
au BufRead,BufNewFile */inventory/*.yml set filetype=yaml.ansible
au BufRead,BufNewFile */roles/*/tasks/*.yml set filetype=yaml.ansible
au BufRead,BufNewFile */roles/*/handlers/*.yml set filetype=yaml.ansible
au BufRead,BufNewFile */roles/*/vars/*.yml set filetype=yaml.ansible
au BufRead,BufNewFile */roles/*/defaults/*.yml set filetype=yaml.ansible
au BufRead,BufNewFile */roles/*/meta/*.yml set filetype=yaml.ansible
au BufRead,BufNewFile */group_vars/*.yml set filetype=yaml.ansible
au BufRead,BufNewFile */host_vars/*.yml set filetype=yaml.ansible

" YAML specific settings
autocmd FileType yaml,yaml.ansible setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType yaml,yaml.ansible setlocal indentkeys-=<:>
autocmd FileType yaml,yaml.ansible setlocal conceallevel=0 concealcursor=

" IndentLine configuration for YAML
let g:indentLine_enabled = 1  " IndentLineを有効化
let g:indentLine_char = '│'
let g:indentLine_leadingSpaceEnabled = 0  " 先頭スペースの表示を無効化
let g:indentLine_leadingSpaceChar = '·'
let g:indentLine_fileTypeExclude = ['nerdtree', 'help', 'terminal']
let g:indentLine_showFirstIndentLevel = 0  " 最初のインデントレベル表示を無効化
let g:indentLine_setConceal = 2  " デフォルトのconceal設定に戻す
let g:indentLine_concealcursor = 'inc'  " デフォルトに戻す

" Conceal設定を完全に無効化
set conceallevel=0
set concealcursor=

" ALE configuration for Ansible and YAML
let g:ale_linters = {
\   'yaml': ['yamllint'],
\   'ansible': ['ansible-lint', 'yamllint'],
\}
let g:ale_fixers = {
\   'yaml': ['prettier', 'trim_whitespace'],
\   'ansible': ['prettier', 'trim_whitespace'],
\}
let g:ale_fix_on_save = 0  " Set to 1 to auto-fix on save
let g:ale_lint_on_text_changed = 'delay'
let g:ale_lint_delay = 500
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

" ALE navigation
nmap <silent> [g <Plug>(ale_previous_wrap)
nmap <silent> ]g <Plug>(ale_next_wrap)


" CoC configuration for autocompletion
" Use Tab for trigger completion
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" ESC to cancel completion menu
inoremap <silent><expr> <Esc> coc#pum#visible() ? coc#pum#cancel() : "\<Esc>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" GitHub Copilot configuration (disabled)
" let g:copilot_no_tab_map = v:true
" let g:copilot_assume_mapped = v:true
" let g:copilot_tab_fallback = ""
" 
" " Copilot key mappings
" imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
" imap <C-]> <Plug>(copilot-next)
" imap <C-[> <Plug>(copilot-previous)
" imap <C-\> <Plug>(copilot-dismiss)
" 
" " Enable Copilot for specific filetypes
" let g:copilot_filetypes = {
"       \ '*': v:true,
"       \ }
" 
" " Copilot status in statusline
" set statusline+=%{copilot#status()}