let need_to_install_plugins = 0
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    let need_to_install_plugins = 1
endif

function! SourceIfExists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'tomasr/molokai'
let g:molokai_original = 1
let g:rehash256 = 1
Plug 'tpope/vim-sensible'
Plug 'Vigemus/nvimux', { 'branch': 'master' }
Plug 'kassio/neoterm'
Plug 'janko/vim-test'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-speeddating', { 'for': [ 'org', 'dotoo', 'rec', 'md' ] }
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/syntastic'
Plug 'christoomey/vim-tmux-navigator'
Plug 'vim-airline/vim-airline', { 'tag': '*' }
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'markstory/vim-zoomwin'
" Asynchronous Lint Engine
Plug 'dense-analysis/ale'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'edkolev/tmuxline.vim'
Plug 'preservim/tagbar'
Plug 'dhruvasagar/vim-dotoo'
Plug 'lepture/vim-jinja'
Plug 'm-kat/aws-vim'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

colorscheme molokai

if need_to_install_plugins == 1
    echo "Installing plugins..."
    silent! PlugInstall --sync
    silent! UpdateRemotePlugins
    source $MYVIMRC
    echo "Done!"
    q
endif

if empty(glob('~/.vim/plugged/tmuxline.vim/tmux.conf')) && !empty($TMUX_PANE)
    echo "Setting up tmuxline"
    silent! Tmuxline airline
    silent! TmuxlineSnapshot "$HOME/.vim/plugged/tmuxline.vim/tmux.conf"
    echo "Done!"
endif

let mapleader = ","

filetype plugin indent on
set ttyfast
set termguicolors
"set background=dark
set hidden
set laststatus=2 " Always display the statusline in all windows
set showtabline=2 " Always display the tabline, even if there is only one tab
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ale#enabled = 1
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)
set clipboard^=unnamed,unnamedplus
set relativenumber
set number
set mouse=a
set keymodel=startsel,stopsel
set updatetime=500
set modeline
set modelines=5

" No backups
set nobackup
set nowritebackup
set nowb
set noswapfile
" give us nice EOL (end of line) characters
set list
set listchars=tab:▸\ ,eol:¬
" Keep lots of history/undo
set undolevels=1000
" Files to ignore
" Python
set wildignore+=*.pyc,*.pyo,*/__pycache__/*
" Temp files
set wildignore+=*.swp,~*
" Archives
set wildignore+=*.zip,*.tar,*.gz
" code folding
set foldmethod=indent
set foldlevel=99
" Setup netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 0
let g:netrw_altv = 1
let g:netrw_winsize = 25

" Freed <C-l> in Netrw to allow tmux-navigation to work
nmap <leader><leader><leader><leader><leader><leader>l <Plug>NetrwRefresh

" reload config
nnoremap <Leader>vr :source $MYVIMRC<CR>

" map save file
" Note that remapping C-s requires flow control to be disabled
" (e.g. in .bashrc or .zshrc)
nnoremap <C-s> <esc>:w<CR>
inoremap <C-s> <esc>:w<CR>a
vnoremap <C-s> <Esc>:w<CR>

" copy, cut and paste
vmap <C-c> "+y
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <ESC>"+pa

" tags
map <leader>t :TagbarToggle<CR>

" Sends default register to terminal TTY using OSC 52 escape sequence
" https://github.com/leeren/dotfiles
let g:tty=system('readlink -f /proc/'.getpid().'/fd/0')
function! Osc52Yank()
    let buffer=system('base64 -w0', @0)
    let buffer=substitute(buffer, "\n$", "", "")
    let buffer='\e]52;c;'.buffer.'\x07'
    silent exe "!echo -ne ".shellescape(buffer).
        \ " > ".shellescape(g:tty)
endfunction
" Automatically call OSC52 function on yank to sync register with host clipboard
augroup Yank
  autocmd!
  autocmd TextYankPost * if v:event.operator ==# 'y' | call Osc52Yank() | endif
augroup END

autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype go setlocal tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype yaml setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
" ts - show existing tab with 4 spaces width
" sw - when indenting with '>', use 4 spaces width
" sts - control <tab> and <bs> keys to match tabstop

" Control all other files
set shiftwidth=4

noremap <C-a>z :ZoomToggle<CR>
noremap <leader>_ :split $PWD<CR>
noremap <leader><bar> :vsplit $PWD<CR>

" vim-test
let test#strategy = {
  \ 'nearest': 'neovim',
  \ 'file':    'dispatch',
  \ 'suite':   'basic',
\}
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>

" disable autoindent when pasting text
" source: https://coderwall.com/p/if9mda/automatically-set-paste-mode-in-vim-when-pasting-in-insert-mode
function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

call SourceIfExists("$HOME/.vimrc.local")
