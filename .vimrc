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
Plugin 'voldikss/vim-floaterm'
Plugin 'pixelneo/vim-python-docstring'
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
Plugin 'vimwiki/vimwiki'
Bundle 'mattn/calendar-vim'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'dyng/ctrlsf.vim'
Plugin 'dense-analysis/ale'
Plugin 'Shougo/neosnippet'
Plugin 'Shougo/neosnippet-snippets'
Plugin 'Shougo/neopairs.vim'
Plugin 'Shougo/denite.nvim'
Plugin 'psf/black'
if $VIRTUAL_ENV != ""
    Plugin 'roxma/vim-hug-neovim-rpc'
    Plugin 'roxma/nvim-yarp'
    Plugin 'deoplete-plugins/deoplete-jedi'
    Plugin 'Shougo/deoplete.nvim'
endif
Plugin 'joshdick/onedark.vim'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'puremourning/vimspector'

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
set mouse=i

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
map <C-j> ciw<C-r>0<ESC>
" use change inside word instead of change word
" we can still use cW for cw
nnoremap cw ciw
nmap =j :%!python -m json.tool<CR>
nmap =jn :%!strip_ipynb<CR>
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

nnoremap <leader>c :Calendar<CR>
set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
nnoremap <leader>g :silent lgrep<Space>
nnoremap <silent> [f :lprevious<CR>
nnoremap <silent> ]f :lnext<CR>

" CtflSF
nmap     <C-F>f <Plug>CtrlSFPrompt
vmap     <C-F>f <Plug>CtrlSFVwordPath
vmap     <C-F>F <Plug>CtrlSFVwordExec
nmap     <C-F>n <Plug>CtrlSFCwordPath
nmap     <C-F>p <Plug>CtrlSFPwordPath
nnoremap <C-F>o :CtrlSFOpen<CR>
nnoremap <C-F>t :CtrlSFToggle<CR>
inoremap <C-F>t <Esc>:CtrlSFToggle<CR>

" Py docstring default mapping
nmap <silent> <C-_> <Plug>(pydocstring)

" copy from vim
nnoremap <C-L> :set relativenumber! number! mouse=i<CR>


let g:ale_python_pyls_config = {
            \   'pylsp': {
            \     'plugins': {
            \       'pycodestyle': {
            \         'enabled': v:true,
            \       },
            \       'pyflakes': {
            \         'enabled': v:true,
            \       },
            \       'pydocstyle': {
            \         'enabled': v:true,
            \       },
            \     },
            \   },
            \}
let g:ale_linters = {
            \   'python': ['flake8', 'pylsp', 'bandit', 'mypy'],
            \}

let g:ale_python_pylsp_executable = "pyls"
" pip install python-language-server
" to change the max-line-length:
" and then in ~/.config/pycodestyle
" [pycodestyle]
" max-line-length = 100
" https://github.com/palantir/python-language-server/issues/329

" let g:ale_linters = { 'python': ['vulture']}
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
nmap  <C-]> :ALEGoToDefinition <CR>
nmap <silent> tt :call GetTerm()  <CR>
nmap <silent> <leader>m :call MinimizeTerm() <CR>
" open NerdTree with nn
nnoremap <silent> <leader>n :NERDTreeToggle<CR>
try
    " Use deoplete.
    let g:deoplete#enable_at_startup = 1
    let g:ale_python_flake8_options = '--ignore=E501'
catch
    pass
endtry
fu RunProgram()
	if &filetype ==# 'python'
		! python3 %
	elseif &filetype ==# 'javascript'
		! node %	
	elseif &filetype ==# 'c'
		! gcc %; ./a.out; rm a.out
	elseif &filetype ==# 'cpp'
		! gcc %; ./a.out; rm a.out
	else
		echom "un supported filetype"
	endif
endfu

fu MinimizeTerm()
    wincmd j
    res 1
    wincmd k
endfu

fu GetTerm()
		terminal
		wincmd x
		res 40
        wincmd j
endfu

fu GetCommitLog()
		wincmd h
		sp
		wincmd j
		GlLog
		q
		wincmd k
		res 40
		wincmd l
endfu

fu Get()
		call GetCommitLog()
		call GetTerm()
endfu

let NERDTreeShowHidden=1
let g:auto_save = 1
let g:ctrlp_show_hidden = 1

filetype plugin indent on
syntax on
colo onedark 
set background=dark
set encoding=UTF-8
func! s:SetBreakpoint()
    cal append('.', repeat(' ', strlen(matchstr(getline('.'), '^\s*'))) . 'import ipdb; ipdb.set_trace()')
endf

func! s:RemoveBreakpoint()
    exe 'silent! g/^\s*import\sipdb\;\?\n*\s*ipdb.set_trace()/d'
endf

func! s:ToggleBreakpoint()
    if getline('.')=~#'^\s*import\sipdb' | cal s:RemoveBreakpoint() | el | cal s:SetBreakpoint() | en
endf
nnoremap <F6> :call <SID>ToggleBreakpoint()<CR>

" Configuration example
let g:floaterm_keymap_toggle = '<leader>t'
let g:floaterm_keymap_kill = '<leader>k'

let g:black_fast = 0
let g:black_linelength = 122
let g:black_skip_string_normalization = 1
let g:black_quiet = 0

# dummy comment
