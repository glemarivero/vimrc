set nocompatible              " required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
" add all your plugins here (note older versions of Vundle
" used Bundle instead of Plugin)

" Plugin 'vim-syntastic/syntastic'
Plugin 'nvie/vim-flake8'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'jnurmine/Zenburn'
Plugin 'altercation/vim-colors-solarized'
Plugin 'scrooloose/nerdtree'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tmhedberg/SimpylFold'
Plugin 'mileszs/ack.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'heavenshell/vim-pydocstring'
Bundle 'Valloric/YouCompleteMe'
Plugin 'vimwiki/vimwiki'
Plugin 'ludovicchabant/vim-gutentags'
Plugin 'vim-vdebug/vdebug'
Bundle 'mattn/calendar-vim'

" ...

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
set relativenumber
set number

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Enable folding

set foldmethod=indent
set foldlevel=99
" Enable folding with the spacebar
nnoremap <space> za

set tabstop=4
set softtabstop=4
set shiftwidth=4
"set textwidth=79
set expandtab
set autoindent
set fileformat=unix
au BufNewFile,BufRead *.py:
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4
"    \ set textwidth=79
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix


"define BadWhitespace before using in a match
highlight BadWhitespace ctermbg=red guibg=darkred
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/


set encoding=utf-8
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

"python with virtualenv support
py3 << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    exec(compile(open(activate_this, 'rb').read(), activate_this, 'exec'), dict(__file__=activate_this))
EOF

let python_highlight_all=1
syntax on
set backspace=indent,eol,start
fun! SearchHighlight()
    silent! call matchdelete(b:ring)
    let b:ring = matchadd('ErrorMsg', '\c\%#' . @/, 101)
endfun

fun! SearchNext()
    try
        execute 'normal! ' . 'Nn'[v:searchforward]
    catch /E385:/
        echohl ErrorMsg | echo "E385: search hit BOTTOM without match for: " . @/ | echohl None
    endtry
    call SearchHighlight()
endfun

fun! SearchPrev()
    try
        execute 'normal! ' . 'nN'[v:searchforward]
    catch /E384:/
        echohl ErrorMsg | echo "E384: search hit TOP without match for: " . @/ | echohl None
    endtry
    call SearchHighlight()
endfun

" Highlight entry
nnoremap <silent> n :call SearchNext()<CR>
nnoremap <silent> N :call SearchPrev()<CR>

" Use <C-L> to clear some highlighting
nnoremap <silent> <C-L> :silent! call matchdelete(b:ring)<CR>:nohlsearch<CR>:set nolist nospell<CR><C-L>
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
set clipboard=unnamed
set splitright

" Using ACK plugin as Ag silver_searcher
let g:ackprg = 'ag --vimgrep --smart-case'
cnoreabbrev ag Ack
cnoreabbrev aG Ack
cnoreabbrev Ag Ack
cnoreabbrev AG Ack
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>
function! ExitNormalMode()
    unmap <buffer> <silent> <RightMouse>
    call feedkeys("a")
endfunction

function! EnterNormalMode()
    if &buftype == 'terminal' && mode('') == 't'
        call feedkeys("\<c-w>N")
        call feedkeys("\<c-y>")
        map <buffer> <silent> <RightMouse> :call ExitNormalMode()<CR>
    endif
endfunction

tmap <silent> <ScrollWheelUp> <c-w>:call EnterNormalMode()<CR>
set mouse=a

" Valloric
"let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 0

" NERDCommenter
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1

" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" use Shift TAB to toggle comments
noremap <S-Tab> :call NERDComment(0,"toggle") <CR>
vmap <C-c> "+y
map <C-\> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
nnoremap <C-n> <C-a>:w<cr>
nnoremap <C-p> <C-x>:w<cr>
:map <C-j> ciw<C-r>0<ESC>
" use change inside word instead of change word
" we can still use cW for cw
nnoremap cw ciw
" open NerdTree with Ctrl-n
nnoremap <C-n> :NERDTreeToggle<CR>
nmap =j :%!python -m json.tool<CR>
nmap yr :call system("ssh -p 2222 127.0.0.1 pbcopy", @*)<CR>
vmap yr :call system("ssh -p 2222 127.0.0.1 pbcopy", @*)<CR>
let g:vimwiki_list = [{
	\ 'path': '~/vimwiki',
	\ 'template_path': '~/vimwiki/templates/',
	\ 'template_default': 'default',
	\ 'syntax': 'markdown',
	\ 'ext': '.md',
	\ 'path_html': '~/vimwiki/site_html/',
	\ 'custom_wiki2html': 'vimwiki_markdown',
	\ 'template_ext': '.tpl'}]
noremap <leader>www :VimwikiAll2HTML<CR>
let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root = ['.root_ulta']
let g:gutentags_ctags_exclude = [
      \ '*.git', '*.svg', '*.hg',
      \ '*/tests/*',
      \ 'build',
      \ 'dist',
      \ '*sites/*/files/*',
      \ 'bin',
      \ 'node_modules',
      \ 'bower_components',
      \ 'cache',
      \ 'compiled',
      \ 'docs',
      \ 'example',
      \ 'bundle',
      \ 'vendor',
      \ '*.md',
      \ '*-lock.json',
      \ '*.lock',
      \ '*bundle*.js',
      \ '*build*.js',
      \ '.*rc*',
      \ '*.json',
      \ '*.min.*',
      \ '*.map',
      \ '*.bak',
      \ '*.zip',
      \ '*.pyc',
      \ '*.class',
      \ '*.sln',
      \ '*.Master',
      \ '*.csproj',
      \ '*.tmp',
      \ '*.csproj.user',
      \ '*.cache',
      \ '*.pdb',
      \ 'tags*',
      \ 'cscope.*',
      \ '*.css',
      \ '*.less',
      \ '*.scss',
      \ '*.exe', '*.dll',
      \ '*.mp3', '*.ogg', '*.flac',
      \ '*.swp', '*.swo',
      \ '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png',
      \ '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
      \ '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx',
      \ ]

set statusline+=%{gutentags#statusline()}

nnoremap <leader>c :Calendar<CR>
