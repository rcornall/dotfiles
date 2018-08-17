set t_BE=
set t_Co=256 " vim airline needs more colors
set encoding=utf-8

let mapleader = "," " remap leader

set updatetime=250 "ms

set tags+=tags;$HOME " ctags look for tags file

set mouse=a         " enable mouse support
set pastetoggle=<F2> " paste toggle

set nocompatible    " fixes vundle issues on vim 8.0

" kernel tabs
" set noexpandtab                              " use tabs, not spaces
" set tabstop=8                                " tab this width of spaces
" set shiftwidth=8                             " indent this width of spaces

" aleos tabs
set expandtab                                " use spaces
set tabstop=4                                " tab this width of spaces
set shiftwidth=4                             " indent this width of spaces

set backspace=indent,eol,start   " backspace will remove endls

set autoindent      "

set number          " line numbers

set hlsearch        " highlight search

set laststatus=2

set ruler

set wildmenu

set backupdir=~/.vim/backup// " store swps in diff directories
set directory=~/.vim/swap//
set undodir=~/.vim/undo//
set undofile
set undolevels=1000
set undoreload=10000

set showmode        " always show what mode we're currently editing in
set laststatus=2    " always show status line

set ignorecase                  " ignore case when searching
set smartcase                   " ignore case if search pattern is all lowercase,
                                "    case-sensitive otherwise
set incsearch                   " show search matches as you type
set fileformat=unix
set fileformats=unix,dos,mac
set formatoptions+=1            " When wrapping paragraphs, don't end lines
                                "    with 1-letter words
set shortmess+=I                " hide the launch screen
set clipboard=unnamedplus       " yank goes into clipboard

" work-around to copy selected text to system clipboard
" and prevent it from clearing clipboard when using ctrl+z (depends on xsel)
function! CopyText()
  normal gv"+y
  :call system('xsel -ib', getreg('+'))
endfunction
nmap <leader>y :call CopyText()<CR>
vmap <leader>y :call CopyText()<CR>

" normal regexs
nnoremap / /\v
vnoremap / /\v

" Speed up scrolling of the viewport slightly
nnoremap <C-e> 2<C-e>
nnoremap <C-y> 2<C-y>
set shortmess+=I                " hide the launch screen
" enter=newline
nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>

syntax on

filetype plugin indent on
" Set the filetype based on the file's extension, overriding any
" " 'filetype' that has already been set
au BufRead,BufNewFile *.bb set filetype=sh
au BufRead,BufNewFile *.bbappend set filetype=sh
au BufRead,BufNewFile *.inc set filetype=sh
au BufRead,BufNewFile *.rule set filetype=lua
au BufRead,BufNewFile *.map set filetype=lua
au BufNewFile,BufRead * if expand('%:t') !~ '\.' | set filetype=sh | endif
au BufNewFile,BufRead * if expand('%:t') == '' | set filetype=qf | endif
au BufNewFile,BufRead * if expand('%:t') == '.vimrc' | set filetype=vim | endif

" PLUGINS SETTINGS AND COLOR SCHEMES
" plug plugin manager
call plug#begin('~/.vim/plugged')

Plug 'google/vim-maktaba'
Plug 'google/vim-glaive'
Plug 'google/vim-codefmt'

Plug 'flazz/vim-colorschemes'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Add fzf
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'ntpeters/vim-better-whitespace'

Plug 'machakann/vim-highlightedyank'

Plug 'mhinz/vim-signify'

" vim-surround
Plug 'tpope/vim-surround'

" google search
Plug 'szw/vim-g'

" tagbar
Plug 'majutsushi/tagbar'

" Initialize plugin system
call plug#end()
call glaive#Install()

" for pathogen plugins
execute pathogen#infect()

" make double-<Esc> clear search highlights
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

highlight LineNr ctermfg=darkgrey  cterm=bold

syn on se title

" " autocmd vimenter * NERDTree "run nerdtree on start
" let g:ctrlp_dont_split = 'nerdtree'

" set runtimepath^=~/.vim/bundle/ctrlp.vim "something for ctrl-p plugin
" let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
" " AG instead of vims glob -> MAKES ctrl-P ~10X faster
" if executable('ag')
  " let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
" else
  " echo "-----------NEED TO INSTALL AG-----------"
" endif
set wildignore+=*\\BUILD\\*
set wildignore+=*\\BUILD.MACAN\\*
set wildignore+=*\\BUILD.GX\\*
set wildignore+=*\\BUILD.CAYENNE\\*
set wildignore+=*\\artifacts\\*
set wildignore+=*\\artifacts\\*
set wildignore+=*\\build\\*
set wildignore+=*\\meta-openembedded\\*
" let g:ctrlp_custom_ignore+=build

" nerdcommenter
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
nnoremap <C-_> :call NERDComment(0,"toggle")<CR>
vnoremap <C-_> :call NERDComment(0,"toggle")<CR>

" let g:neocomplete#enable_at_startup = 1

let g:ycm_server_python_interpreter = '/usr/bin/python'
let g:ycm_show_diagnostics_ui = 0


nnoremap <C-]> :YcmCompleter GoToDefinitionElseDeclaration<CR>
function! s:Saving_scroll(cmd)
  let save_scroll = &scroll
  execute 'normal! ' . a:cmd
  let &scroll = save_scroll
endfunction
" nnoremap <C-J> :call <SID>Saving_scroll("1<C-V><C-D>")<CR>
" vnoremap <C-J> <Esc>:call <SID>Saving_scroll("gv1<C-V><C-D>")<CR>
" nnoremap <C-K> :call <SID>Saving_scroll("1<C-V><C-U>")<CR>
" vnoremap <C-K> <Esc>:call <SID>Saving_scroll("gv1<C-V><C-U>")<CR>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>


let g:airline_powerline_fonts = 1

" easymotions
map <Leader> <Plug>(easymotion-prefix)

" fzf settings
" " Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)
let $FZF_DEFAULT_COMMAND='ag -g ""'

" remap some easier search commands
"   call ag and ag under word
nnoremap <leader>a :Find 
nnoremap <c-a> :exe "Find " .expand('<cword>')<CR>

"   call tags and tags under word
nnoremap <leader>t :Tags<CR>
nnoremap <C-t> :exe "Tags " .expand('<cword>')<CR>

nnoremap <c-p> :Files<CR>
" nnoremap <silent> <leader>m :GFiles<CR>
"
" remap google search
nnoremap <leader>g :Google 

"   :Find  - Start fzf with hidden preview window that can be enabled with "?"
"   key
"   :Find! - Start fzf in fullscreen and display the preview window above
command! -bang -nargs=* Find
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%', '?'),
  \                 <bang>0)

  " \                         : fzf#vim#with_preview('right:50%:hidden', '?'),

if has("autocmd")
  " Highlight TODO, FIXME, NOTE, etc.
  if v:version > 701
    autocmd Syntax * call matchadd('Todo',  '\W\zs\(TODO\|FIXME\|CHANGED\|XXX\|BUG\|HACK\)')
    autocmd Syntax * call matchadd('Debug', '\W\zs\(NOTE\|INFO\|IDEA\)')
  endif
endif

" colorscheme Tomorrow-Night-Bright
colorscheme PaperColor
set background=dark
let g:airline_theme='dark'
" call AirlineTheme badcat





function! s:align_lists(lists)
  let maxes = {}
  for list in a:lists
    let i = 0
    while i < len(list)
      let maxes[i] = max([get(maxes, i, 0), len(list[i])])
      let i += 1
    endwhile
  endfor
  for list in a:lists
    call map(list, "printf('%-'.maxes[v:key].'s', v:val)")
  endfor
  return a:lists
endfunction

function! s:btags_source()
  let lines = map(split(system(printf(
    \ 'ctags -f - --sort=no --excmd=number %s',
    \ expand('%:S'))), "\n"), 'split(v:val, "\t")')
  if v:shell_error
    throw 'failed to extract tags'
  endif
  return map(s:align_lists(lines), 'join(v:val, "\t")')
endfunction

function! s:btags_sink(line)
  execute split(a:line, "\t")[2]
endfunction

function! s:btags()
  try
    call fzf#run({
    \ 'source':  s:btags_source(),
    \ 'options': '+m -d "\t" --with-nth 1,4.. -n 1 --tiebreak=index',
    \ 'down':    '40%',
    \ 'sink':    function('s:btags_sink')})
  catch
    echohl WarningMsg
    echom v:exception
    echohl None
  endtry
endfunction

command! BTags call s:btags()
nnoremap <leader>r :BTags<CR>



function! s:buflist()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! s:bufopen(e)
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
endfunction

nnoremap <leader>b :call fzf#run({
\   'source':  reverse(<sid>buflist()),
\   'sink':    function('<sid>bufopen'),
\   'options': '+m',
\   'down':    len(<sid>buflist()) + 2
\ })<CR>
