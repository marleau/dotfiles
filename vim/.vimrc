" Install junegunn/vim-plug if necessary
  let $VIMHOME=$HOME.'/.vim'
let $PLUGDIR=$VIMHOME.'/autoload'
if !filereadable(expand($PLUGDIR.'/plug.vim'))
  echo "Downloading junegunn/vim-plug to manage plugins..."
  silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" -o $PLUGDIR'/plug.vim' --create-dirs
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'Rigellute/rigel'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'mbbill/undotree'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'machakann/vim-highlightedyank'

call plug#end()

" settings

filetype plugin indent on                    " Load plugin and indent files for specific filetypes
set termguicolors                            " Enable 24-bit color
syntax enable                                " Enable syntax highlighting
colorscheme rigel
set nu                                       " Show current line number
set rnu                                      " Show relative line numbers
set expandtab                                " Replace tab character with spaces
set tabstop=2                                " Number for spaces inserted instead of tab
set shiftwidth=2                             " Use 2 spaces for indenting
set softtabstop=2                            " Use 2 spaces for tabbing
set signcolumn=yes                           " Always show signcolumns
set cursorline                               " Highlight current line

" keymaps

let mapleader=" "
nnoremap <leader>vv :e $MYVIMRC<cr>
inoremap jk <Esc>
nnoremap <leader>pv :Ex<cr>
nnoremap <c-p> :GFiles --exclude-standard --cached --others<cr>
nnoremap <leader>pf :Files<cr>
nnoremap <leader>vh :Helptags<cr>
nnoremap <leader>u :UndotreeToggle

let g:highlightedyank_highlight_duration = 250
