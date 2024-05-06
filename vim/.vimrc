if has('nvim')
  let $VIMHOME=$HOME.'/.config/nvim'
else
  let $VIMHOME=$HOME.'/.vim'
endif

" ===================
"   Plugins
" ==================

" Install junegunn/vim-plug if necessary
let $PLUGDIR=$VIMHOME.'/autoload'
if !filereadable(expand($PLUGDIR.'/plug.vim'))
  echo "Downloading junegunn/vim-plug to manage plugins..."
  silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" -o $PLUGDIR'/plug.vim' --create-dirs
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

" Testing
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'liuchengxu/graphviz.vim'
Plug 'stevearc/conform.nvim'

" Languages/filetypes
Plug 'ledger/vim-ledger'
Plug 'leafgarland/typescript-vim'
" Plug 'leafOfTree/vim-svelte-plugin'
Plug 'evanleck/vim-svelte', {'branch': 'main'}

" Colors
Plug 'Rigellute/rigel'

" Git
Plug 'tpope/vim-fugitive'

" Make the editor nice
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'godlygeek/tabular'
Plug 'ap/vim-css-color'
Plug 'norcalli/nvim-colorizer.lua'

" Finding/opening files
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Notational Velocity
Plug 'alok/notational-fzf-vim'

call plug#end()

" ====================
"   General Settings
" ====================

set nocompatible                             " Use vim settings rather than vi
filetype plugin indent on                    " Load plugin and indent files for specific filetypes
set termguicolors                            " Enable 24-bit color
syntax enable                                " Enable syntax highlighting
set nu                                       " Show current line number
set rnu                                      " Show relative line numbers
set autoindent                               " Automatically indent new lines
set smartindent                              " Smart automatic indent new lines for programming languages
set expandtab                                " Replace tab character with spaces
set tabstop=2                                " Number for spaces inserted instead of tab
set shiftwidth=2                             " Use 2 spaces for indenting
set softtabstop=2                            " Use 2 spaces for tabbing
set hlsearch                                 " Highlight search term
set incsearch                                " Highlight search matches as you type
set ignorecase                               " Ignore case while searching
set smartcase                                " If search contains uppercase, make case-sensitive
set splitbelow                               " Spawn horizontal splits below
set splitright                               " Spawn vertical splits to the right
set cursorline                               " Highlight current line
set autoread                                 " Reload file when changed externally
set signcolumn=yes                           " Always show signcolumns
set showmatch                                " Show matching parenthesis/brackets
set wildmenu                                 " Turn on commandline completion wild style
set directory=$VIMHOME/tmp                   " Put swap files in temp dir
set backupdir=$VIMHOME/tmp                   " Put backup files in temp dir
set wildignore+=*/node_modules/*,*.swp,*.bak " Ignore these folders and files
set completeopt=menuone,noinsert,noselect
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

" colorscheme wal
colorscheme rigel
"colorscheme nightfly

" Make background transparent
hi Normal guibg=NONE ctermbg=NONE
" Make SignColumn transparent
highlight SignColumn guibg=NONE
" Make line numbers transparent
highlight LineNr guibg=NONE ctermbg=NONE

lua require('init')

" ===============
"   Keymappings
" ===============

let mapleader="," " Use , as leader instead of \

" Use ; instead of : for command line
nnoremap ; :

" Open vimrc
nnoremap <leader>v :e $MYVIMRC<cr>
" Save and source current file
nnoremap <leader>vv :w $MYVIMRC <bar> :so $MYVIMRC<cr> <bar> :exe ":echo 'vimrc reloaded'"<cr>

" Clear search highlighting
nnoremap <silent> <leader>/ :nohlsearch<CR><C-L>

" jk = esc
inoremap jk <Esc>

" Untab in insert mode with shift+tab
inoremap <s-tab> <c-d>

" Open fzf
" If in git repo, search git files; else, search all files
if filereadable('.git/config')
  nnoremap <silent> <c-p> :GFiles --cached --others --exclude-standard<cr>
else
  nnoremap <silent> <c-p> :Files<cr>
endif

" =================
"   Auto Commands
" =================

" Create the following folders if DNE
silent execute '!mkdir -p $VIMHOME/tmp'

" Source vimrc after every write
" TODO: Figure out why this freezes nvim
" au BufWritePost $MYVIMRC source %

" If file begins with #! or has bin, make executable on write
"au BufWritePost * if getline(1) =~ "^#!" | if getline(1) =~ "/bin/" | silent !chmod +x <afile> | endif | endif

" Automatically toggle relative line numbers when entering buffer and insert
" mode
augroup line_number_toggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set rnu
  autocmd BufLeave,FocusLost,InsertEnter * set nornu
augroup END

" ======================
"   notational-fzf-vim
" ======================

let g:nv_search_paths = ['~/notes']

