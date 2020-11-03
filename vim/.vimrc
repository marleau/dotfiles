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
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

" Colors
Plug 'rigellute/rigel'
Plug 'bluz71/vim-nightfly-guicolors'
Plug 'dylanaraps/wal.vim'
Plug 'ap/vim-css-color'

" Git
Plug 'tpope/vim-fugitive'

" Make the editor nice
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'godlygeek/tabular'

" Finding/opening files
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

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
set wildignore+=*/node_modules/*,*.swp,*.bak " Ignore these folders and files

" colorscheme wal
colorscheme rigel
"colorscheme nightfly

" Make background transparent
hi Normal guibg=NONE ctermbg=NONE
" Make SignColumn transparent
highlight SignColumn guibg=NONE
" Make line numbers transparent
highlight LineNr guibg=NONE ctermbg=NONE

" ===============
"   Keymappings
" ===============

let mapleader="," " Use , as leader instead of \

" Use ; instead of : for command line
nnoremap ; :

" Open vimrc
nnoremap <leader>v :e $MYVIMRC<cr>
" Save and source current file
nnoremap <leader>vv :w % <bar> :so %<cr> <bar> :exe ":echo 'vimrc reloaded'"<cr>

" Clear search highlighting
nnoremap <silent> <leader>/ :nohlsearch<CR><C-L>

" jk = esc
inoremap jk <Esc>

" Untab in insert mode with shift+tab
inoremap <s-tab> <c-d>

" Open fzf
nnoremap <silent> <c-p> :GFiles --cached --others --exclude-standard<cr>

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

" =====================
"   coc.nvim settings
" =====================

let g:coc_global_extensions = ['coc-json', 'coc-prettier', 'coc-tsserver', 'coc-css', 'coc-html', 'coc-angular', 'coc-python', 'coc-svg']
" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)
