" remove legacy
set nocompatible

" --------------------------------------------------------------------------------------------------
" Directories and environment meta-setups
" --------------------------------------------------------------------------------------------------

" http://stackoverflow.com/questions/3377298/how-can-i-override-vim-and-vimrc-paths-but-no-others-in-vim
" set default 'runtimepath' (without ~/.vim folders)
let &runtimepath = printf('%s/vimfiles,%s,%s/vimfiles/after', $VIM, $VIMRUNTIME, $VIM)

" what is the name of the directory containing this file?
let s:portable = expand('<sfile>:p:h')
let $VIMHOME = s:portable

" add the directory to 'runtimepath'
let &runtimepath = printf('%s,%s,%s/after', s:portable, &runtimepath, s:portable)

" create portable directories
if isdirectory($VIMHOME . '/.backup') == 0
    call mkdir($VIMHOME . '/.backup')
endif

if isdirectory($VIMHOME . '/.cache') == 0
    call mkdir($VIMHOME . '/.cache')
endif

if isdirectory($VIMHOME . '/.swap') == 0
    call mkdir($VIMHOME . '/.swap')
endif

if isdirectory($VIMHOME . '/.undo') == 0
    call mkdir($VIMHOME . '/.undo')
endif

" set portable file locations
let $MYVIMRC = $VIMHOME . '/vimrc.vim'
let g:unite_data_directory = $VIMHOME . '/.cache'
let g:NERDTreeBookmarksFile = $VIMHOME . '/.NERDTreeBookmarks'

set viminfo+=n$VIMHOME/.viminfo

set backupdir=$VIMHOME/.backup/
set backup

set directory=$VIMHOME/.swap// " two slashes intentional, prevents collisions (:help dir)
set swapfile

if exists('+undofile')
    set undodir=$VIMHOME/.undo// " two slashes intentional, prevents collisions (:help dir)
    set undofile
endif

" ctags
set tags=./tags;/

" vim-plug
call plug#begin($VIMHOME . '/bundle')
Plug 'vim-scripts/a.vim'
Plug  'haya14busa/incsearch.vim'
Plug  'scrooloose/nerdtree'
Plug       'wting/rust.vim'
Plug    'ervandew/supertab'
Plug   'godlygeek/tabular'
Plug  'majutsushi/tagbar'
Plug      'Shougo/unite.vim'
Plug       'bling/vim-bufferline'
Plug    'Lokaltog/vim-easymotion'
Plug    'justinmk/vim-matchparenalways'
Plug       'jistr/vim-nerdtree-tabs'
Plug       'tpope/vim-repeat'
Plug       'tpope/vim-surround'
call plug#end()

" --------------------------------------------------------------------------------------------------
"  Settings
" --------------------------------------------------------------------------------------------------

" this is just mandatory
set hidden

" wrapping
set linebreak
if v:version > 704 || v:version == 704 && has("patch338")
  set breakindent
endif
set textwidth=100
set formatoptions-=t

if exists('+colorcolumn')
    set colorcolumn=+1
end

augroup highlight_long_lines
  autocmd BufEnter * highlight OverLength ctermbg=0 guibg=#d7d7af
  autocmd BufEnter * match OverLength /\%>100v.\+/
augroup END

" status line
set laststatus=2
set showcmd

set statusline=   " clear the statusline for when vimrc is reloaded
set statusline+=%f\                              " file name
set statusline+=%m%r%w                           " flags
set statusline+=%=                               " right align
set statusline+=%{strlen(&ft)?&ft:'none'}\ \|\   " filetype
set statusline+=%{strlen(&fenc)?&fenc:&enc}\ \|\ " encoding
set statusline+=%{&fileformat}                   " file format
set statusline+=\ %5l/%L\ :\ %2v                 " line/column number

" syntax highlighting
set t_Co=16
syntax on
if has("gui_running")
    set background=light
else
    set background=dark " this is flipped on gui for some reason
endif
colorscheme solarized

" keep some distance from the edge of the screen while scrolling
set scrolloff=5

" indent settings
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
filetype plugin indent on
set smarttab
set backspace=indent,eol,start

" override default indent to ignore blank lines
set indentexpr=GetIndent(v:lnum)
function! GetIndent(lnum)
   return indent(prevnonblank(a:lnum - 1))
endfunction

" line numbers
set number
set cursorline

" make vim faster
set ttyfast
set lazyredraw 

" don't time out on mappings, do on key codes
set notimeout
set ttimeout
set timeoutlen=100

" no bells, please
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

" automatically read files
set autoread

" fix backspace
set backspace=2

" fix mouse
set mouse=a

" use UTF-8
set encoding=utf-8

" NERDTree
let g:nerdtree_tabs_open_on_gui_startup = 0
let g:NERDTreeDirArrows=1
let g:NERDChristmasTree=0
let g:NERDTreeIgnore=["\.pyc$", "\.o$"]

" Unite
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])

" EasyMotion
let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion

" search
set ignorecase
set smartcase
set incsearch
set hlsearch
set wrapscan
let g:incsearch#magic = '\v'

" autocomplete
set completeopt+=longest

" don't autocomplete these kind of files
set wildignore+=*.swp,*.pyc,*.o,*.pyo

" keep clipboard contents on vim exit
if has('unix')
    autocmd VimLeave * call system('xclip -selection clipboard', getreg('+'))
endif

" skin gvim
if has("gui_running")
    " font
    if has('win32')
        set guifont=Consolas:h11
    else
        set guifont=Monaco\ 10
    endif

    " hide cruft
    set guioptions+=mtTbrlRL
    set guioptions-=mtTbrlRL

    " no dialogs please
    set guioptions+=c

    " better cursor
    set guicursor=n-v-c:block-Cursor-blinkon0,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor,r-cr:hor20-Cursor,sm:block-Cursor-blinkwait175-blinkoff150-blinkon175

    " make gvim remember pos
    let g:screen_size_restore_pos = 1
    source $VIMHOME/winsize_persistent.vim
endif

" --------------------------------------------------------------------------------------------------
"  Mappings
" --------------------------------------------------------------------------------------------------

" easier indenting of code
vnoremap < <gv
vnoremap > >gv

" split navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" better j/k with long lines
nnoremap j gj
nnoremap k gk

" incsearch
map  / <Plug>(incsearch-forward)
map  ? <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" who the hell uses Ex mode? remap to paragraph reformat
vmap Q gw
nmap Q gwap

" search for visual selected text
vnoremap <silent> * :<C-U>
    \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
    \gvy/<C-R><C-R>=substitute(
    \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
    \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
    \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
    \gvy?<C-R><C-R>=substitute(
    \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
    \gV:call setreg('"', old_reg, old_regtype)<CR>

" change the mapleader from \ to space
let mapleader=' '

" quick clear highlighting
map <silent> <leader>l :nohlsearch<CR>

" open current file in explorer
if has('win32')
    nmap <silent> <leader>ee :silent execute "!start explorer /select," . shellescape(expand("%:p"))<CR>
endif

" quick copy/paste to/from system clipboard
map <leader>p "+p
map <leader>P "+P
map <leader>y "+y

" quick swap implementation/header
map <leader>a :A<CR>

" cd to the directory containing the file in the buffer
nmap <silent> <leader>cd :lcd %:h<CR>

" easily edit vimrc and reload
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" close buffer
nmap <leader>x :bd<CR>

" Unite, NERDTree
nmap <silent> <C-p> :Unite -start-insert file_rec<CR>
nmap <silent> <leader>n :NERDTreeTabsToggle<CR>
nmap <silent> <leader>N :NERDTreeFind<CR>

" easymotion
map <Leader>m <Plug>(easymotion-prefix)
map <Leader><Leader> <Plug>(easymotion-s)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" quick replace occurences
let g:should_inject_replace_occurences = 0
function! MoveToNext()
    if g:should_inject_replace_occurences
        call feedkeys("n")
        call repeat#set("\<Plug>ReplaceOccurences")
    endif

    let g:should_inject_replace_occurences = 0
endfunction

augroup auto_move_to_next
    autocmd! InsertLeave * :call MoveToNext()
augroup END

nmap <silent> <Plug>ReplaceOccurences :call ReplaceOccurence()<CR>
nmap <silent> <Leader>r :let @/ = '\<'.expand('<cword>').'\>'<CR>
    \:set hlsearch<CR>:let g:should_inject_replace_occurences=1<CR>cgn
vmap <silent> <Leader>r :<C-U>
    \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
    \gvy:let @/ = substitute(
    \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR>:set hlsearch<CR>:let g:should_inject_replace_occurences=1<CR>
    \gV:call setreg('"', old_reg, old_regtype)<CR>cgn

function! ReplaceOccurence()
    " check if we are on top of an occurence
    let l:winview = winsaveview()
    let l:save_reg = getreg('"')
    let l:save_regmode = getregtype('"')
    let [l:lnum_cur, l:col_cur] = getpos(".")[1:2] 
    normal! ygn
    let [l:lnum1, l:col1] = getpos("'[")[1:2]
    let [l:lnum2, l:col2] = getpos("']")[1:2]
    call setreg('"', l:save_reg, l:save_regmode)
    call winrestview(winview)
    
    " if we are on top of an occurence, replace it
    if l:lnum_cur >= l:lnum1 && l:lnum_cur <= l:lnum2 && l:col_cur >= l:col1 && l:col_cur <= l:col2
        exe "normal! cgn\<c-a>\<esc>"
    endif
    
    call feedkeys("n")
    call repeat#set("\<Plug>ReplaceOccurences")
endfunction
