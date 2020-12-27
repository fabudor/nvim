call plug#begin('$XDG_CONFIG_HOME/nvim/plugged')
Plug 'neovim/nvim-lspconfig'
Plug 'tjdevries/lsp_extensions.nvim'
Plug 'nvim-lua/completion-nvim'

Plug 'rust-lang/rust.vim'
Plug 'scrooloose/nerdtree'
Plug 'gruvbox-community/gruvbox'
Plug 'sainnhe/gruvbox-material'
Plug 'jremmen/vim-ripgrep'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
call plug#end()

colorscheme gruvbox
filetype on
filetype plugin on
filetype indent on
syntax on                        " switch on syntax highlighting.

let mapleader = ","

set background=dark
set completeopt=menuone,noinsert,noselect
set shortmess+=c

" Make sure that unsaved buffers that are to be put in the background are
" allowed to go in there (ie. the "must save first" error doesn't come up)
set nobackup                     " do not store backup or temporary files
set nowritebackup
set noswapfile
set encoding=utf-8               " Set the file encoding to utf8
set fileencoding=utf-8
set undodir=~/vimfiles/undodir
set undofile

set laststatus=2                 " Always show a statusline
set colorcolumn=80               " set a colored column on this position
set showtabline=0                " We certainly don't want to have tabs in VIM

" For gui
set termguicolors
set guifont=Consolas:h15
" Increase and decrease font size

set tabstop=3                    " Tabstops are 3 spaces
set shiftwidth=3
set softtabstop=3
set expandtab                    " replace tab with spaces
set smartindent                  " used to be autoindent
set smartcase                    " use case insensitive search until capital in search pattern
set wrapscan                     " set the search scan to wrap lines
set vb                           " set visual bell -- i hate that damned beeping
set sc                           " set show command (easier to learn vim)
" tell VIM to always put a status line in, even if there is only one window
set showmode                     " show the current mode
set mousehide                    " hide the mouse pointer while typing
set guioptions=acg               " set the gui options the way I like
set virtualedit=all              " set virtual edit so the cursor can go anywhere
set hidden                       " if hidden is not set, TextEdit might fail.
set backspace=indent,eol,start
set ignorecase                   " ignore case in search patterns
set number                       " Show the line numbers
set list                         " Set the invisible characters
set listchars+=tab:␉␠
set listchars+=eol:⏎
set listchars+=trail:␠
set listchars+=nbsp:⎵
set nofoldenable                 " Do not fold
set scrolloff=2                  " When the page starts to scroll, keep the cursor n lines from the top and bottom
set wildmenu                     " Make the command-line completion better
set complete=.,w,b,t             " Insert mode completion. Same as default except that I remove the 'u' option
set showfulltag                  " When completing by tag, show the whole tag, not just the function name
set textwidth=80                 " Set the textwidth to be 80 chars
set fillchars = ""               " get rid of the silly characters in separators
set diffopt+=iwhite              " Add ignorance of whitespace to diff
set hlsearch                     " Enable search highlighting
set incsearch                    " Incrementally match the search shows the matched patterns while typing
set clipboard=unnamed            " Use the systems clipboard
set autoread
set cmdheight=2                  " Give more space for displaying messages.
set updatetime=300


" let g:diagnostic_virtual_text_prefix = 'T'
" let g:diagnostic_enable_virtual_text = 1
" let g:completion_confirm_key = "\<C-y>"
" let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
" "let g:completion_enable_snippet = 'UltiSnips'
" let g:completion_matching_smart_case = 1
" let g:completion_trigger_on_delete = 1
" let g:neomake_open_list = 2

" Rust formatter
let g:rustfmt_autosave = 1
let g:rustfmt_fail_silently = 1


lua <<EOF
-- nvim_lsp object
local nvim_lsp = require'lspconfig'

-- function to attach completion when setting up lsp
local on_attach = function(client)
    require'completion'.on_attach(client)
end

-- Enable rust_analyzer
nvim_lsp.rust_analyzer.setup({ on_attach=on_attach })

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  }
)
EOF

" Trigger completion with <Tab>
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ completion#trigger_completion()

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" Code navigation shortcuts
nnoremap <silent> <leader>gf  <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <leader>gi  <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>

" Show diagnostic popup on cursor hold
autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()

" Goto previous/next diagnostic warning/error
nnoremap <silent> g[ <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> g] <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
\ lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = "Comment" }



au FocusGained * :checktime

nnoremap <silent> <leader>s :let &guifont = substitute(&guifont, ':h\(\d\+\)', '\=":h" . (submatch(1) - 1)', '')<CR>
nnoremap <silent> <leader>b :let &guifont = substitute(&guifont, ':h\(\d\+\)', '\=":h" . (submatch(1) + 1)', '')<CR>

" map to escape and space to set the cursor on the right position
inoremap JK <Esc><space>
inoremap jk <Esc><space>
vnoremap JK <Esc><space>
vnoremap jk <Esc><space>

nnoremap <space><space> :bnext<CR>        " Go to the next buffer
nnoremap <silent> <leader>n :nohls<CR>    " Turn off that stupid highlight search
nnoremap <leader>t :NERDTreeToggle<cr>    " Toggle the NERDTree
nnoremap <leader>w :set invwrap<cr>       " toggle nowrap
nnoremap <leader>u ddkP                   " Set bubble up
nnoremap <leader>d ddjP                   " Set bubble down
nnoremap dl _dd                           " delete line without yank in register

nnoremap <C-h> <C-w>h                     " Go to the window on the left
nnoremap <C-j> <C-w>j                     " Go to the window below
nnoremap <C-k> <C-w>k                     " Go to the window above
nnoremap <C-l> <C-w>l                     " Go to the window on the right

nnoremap <leader>p :vertical resize +5<CR>
nnoremap <leader>m :vertical resize -5<CR>

nnoremap <C-p> :GFiles<CR>
nnoremap <C-f> :Rg 

nnoremap <leader>h :%!xxd<CR>             " show the content of the buffer in hexadecimal
nnoremap <leader>H :%!xxd -r<CR>          " convert from hexadecimal to ASCII

" fetch my latest vimrc
nnoremap <leader>ev :e $XDG_CONFIG_HOME/nvim/init.vim<CR>
" Reload the _vimrc file every time it's saved
au! BufWritePost $XDG_CONFIG_HOME/nvim/init.vim source $XDG_CONFIG_HOME/nvim/init.vim

nnoremap <C-F10> :Git pull origin master<CR>"" reload the vimrc once it's saved
" commit the vimrc local and push it to github
nnoremap <C-F11> :Git commit --all -m"commit"<CR>:Git push<CR>

nnoremap <leader>n :cn<CR>

" Abbreviations
iabbrev @@ douwe.faber@xyleminc.com


