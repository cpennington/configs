" Load vim-plug
if empty(glob("~/.config/nvim/autoload/plug.vim"))
    execute '!curl -fLo ~/.config/nvim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif

" Add list of plugins
call plug#begin('~/.config/nvim/plugged')

Plug 'benekastah/neomake'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'chriskempson/base16-vim'
Plug 'rking/ag.vim', { 'on': 'Ag' }
Plug 'pearofducks/ansible-vim', { 'for': 'ansible' }
Plug 'neovimhaskell/haskell-vim', { 'for': 'haskell' }
Plug 'vim-scripts/SQLUtilities'
Plug 'vim-scripts/Align'
Plug 'tmhedberg/SimpylFold', { 'for': 'python' }
Plug 'vim-scripts/indentpython.vim', { 'for': 'python' }
Plug 'Valloric/YouCompleteMe'
Plug 'tpope/vim-fugitive'
Plug 'lambdatoast/elm.vim', { 'for': 'elm' }
Plug 'vim-airline/vim-airline'

call plug#end()

" Enable folding
set foldmethod=indent
set foldlevel=99
nnoremap <leader><space> za

let g:SimpylFold_docstring_preview=1

autocmd BufWinEnter *.py setlocal foldexpr=SimpylFold(v:lnum) foldmethod=expr
autocmd BufWinLeave *.py setlocal foldexpr< foldmethod<

" Colors
set background=dark
let base16colorspace=256
colorscheme base16-brewer

" Use Space as <leader> to make it easier to get to
let mapleader = "\<Space>"

" Configure CtrlP
nnoremap <leader>p :CtrlP<CR>
nnoremap <leader>bb :CtrlPBuffer<CR>
let g:ctrlp_working_path_mode = 'ra'

" Set up ag
let g:ag_working_path_mode="r"
nnoremap <leader>/ :Ag<space>

" Buffer navigation

nnoremap <leader>bn :bn<CR>
nnoremap <leader>bp :bp<CR>
nnoremap <leader>bd :bd<CR>

nnoremap <leader><space> :


" Neomake
let g:neomake_dockerfile_make_maker = {
    \ 'exe': 'echo',
    \ 'args': ['docker.build.%:p:h:t']
    \ }

let g:neomake_python_enabled_makers = ['pylint', 'pep8']

autocmd! BufWritePost * Neomake

" YAML settings
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2

" PHP settings
autocmd FileType php setlocal shiftwidth=2 tabstop=2

" Ruby settings
autocmd FileType rb setlocal shiftwidth=2 tabstop=2

" Autocompletion Settings
"
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

" Make Yank and Paste use the system clipboard
set clipboard+=unnamedplus

" Make invisible characters visible
set listchars=tab:→·,trail:·,nbsp:¤,precedes:«,extends:»,eol:$ " specify which characters to use.  If you don't have unicode support in your terminal, adjust these accordingly
set list     " turn on display of listchars

" Turn on line numbers
:set number

" Legacy
set backup backupdir=~/.config/nvim/backup
set directory=~/.config/nvim/tmp

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
filetype plugin indent on
set mouse=a
set wildmode=longest,list,full
set wildmenu
set showcmd
set hlsearch
set ignorecase
set smartcase
set laststatus=2
set backspace=indent,eol,start
set wildignore+=*.class,*.pyc

" custom mappings
nmap <leader>nt :NERDTreeToggle<CR>
nmap <leader>e :Errors<CR>

au BufRead *-sup.*-mode set ft=mail

au BufRead,BufNewFile *.json setfiletype json
au BufRead,BufNewFile *.mako setfiletype mak

" Set color columns
set textwidth=0
set colorcolumn=80,180
