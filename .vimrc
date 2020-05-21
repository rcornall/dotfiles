" let $VIMRUNTIME="/usr/share/vim/vim81"
let mapleader = ","

set t_BE=
set t_Co=256
set encoding=utf-8
" enable true colors
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endi

syntax on

set title

set noesckeys

set noea " dont autoresize splits

set updatetime=250 "ms

set tags+=tags; " look for tags file
" noremap <c-]> 2<c-]> " second tag is implementation, sometimes better

set mouse=a         " enable mouse support
if has("mouse_sgr")
    set ttymouse=sgr
else
    set ttymouse=xterm2
end

set pastetoggle=<F2> " paste toggle

" kernel tabs
" set noexpandtab                              " use tabs, not spaces
" set tabstop=8                                " tab this width of spaces
" set shiftwidth=8                             " indent this width of spaces

" aleos tabs
set expandtab                                " use spaces
set tabstop=4                                " tab this width of spaces
set softtabstop=4                            " tab this width of spaces
set shiftwidth=4                             " indent this width of spaces

set virtualedit=

" set foldmethod=syntax
" NOTE: <gj,gk> to move between displayed lines
noremap <buffer> <silent> k gk
noremap <buffer> <silent> j gj

set formatoptions+=j

set backspace=indent,eol,start   " backspace will remove endls

set autoindent      "

set number          " line numbers

set hlsearch        " highlight search

" set cursorline      " highlight cursorline

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

set shortmess+=I                " hide the launch screen

" normal regexs
nnoremap / /\v
vnoremap / /\v

" scroll cursor with context
set scrolloff=5

" Speed up scrolling of the viewport slightly
nnoremap <C-e> 2<C-e>
nnoremap <C-y> 2<C-y>

" enter=newline
nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>

" split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" buf navigation
nnoremap <Left> :bp<CR>
nnoremap <Right> :bn<CR>

" Jump to the last position in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" No Blink
" let &t_SI.="\e[6 q"
" let &t_SR.="\e[4 q"
" let &t_EI.="\e[2 q"
" Blink
let &t_SI.="\e[5 q"
let &t_SR.="\e[3 q"
let &t_EI.="\e[1 q"


filetype plugin indent on
au BufRead,BufNewFile config set filetype=config
au BufRead,BufNewFile messages set filetype=messages
au BufRead,BufNewFile * if expand('%:t') == '' | set filetype=qf | endif
au BufRead,BufNewFile * if expand('%:t') == '.vimrc' | set filetype=vim | endif

set wildignore+=*\\artifacts\\*
set wildignore+=*\\build\\*
set wildignore+=*\\meta-openembedded\\*

if has("autocmd")
  " Highlight TODO, FIXME, NOTE, etc.
  if v:version > 701
    autocmd Syntax * call matchadd('Todo',  '\W\zs\(TODO\|FIXME\|CHANGED\|XXX\|BUG\|HACK\)')
    autocmd Syntax * call matchadd('Debug', '\W\zs\(NOTE\|INFO\|IDEA\)')
  endif
endif

" fix to paster over without yanking...
" https://stackoverflow.com/a/4446608
function! RestoreRegister()
    let @" = s:restore_reg
    if &clipboard == "unnamed"
        let @* = s:restore_reg
    elseif &clipboard == "unnamedplus"
        let @+ = s:restore_reg
    endif
    return ''
endfunction
function! s:Repl()
    let s:restore_reg = @"
    return "p@=RestoreRegister()\<cr>"
endfunction
vnoremap <silent> <expr> p <sid>Repl()
vnoremap <silent> <expr> P <sid>Repl()
" work-around to copy selected text to system clipboard
" and prevent it from clearing clipboard when using ctrl+z (depends on xsel)
function! CopyText()
  normal gv"+y
  :call system('xsel -ib', getreg('+'))
endfunction
nmap <leader>y :call CopyText()<CR>
vmap <leader>y :call CopyText()<CR>

" PLUGS
call plug#begin('~/.vim/plugged')

Plug 'junegunn/goyo.vim'
let g:goyo_width=130
let g:goyo_height=86
let g:goyo_linenr=1

Plug 'rking/ag.vim'

Plug 'terryma/vim-multiple-cursors'
Plug 'scrooloose/nerdcommenter'

Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Plug 'easymotion/vim-easymotion'

Plug 'google/vim-maktaba'
Plug 'google/vim-glaive'
Plug 'google/vim-codefmt'

Plug 'flazz/vim-colorschemes'
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
" let g:airline_powerline_fonts = 1
" let g:airline_highlighting_cache=1

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'ntpeters/vim-better-whitespace'

Plug 'machakann/vim-highlightedyank'

Plug 'mhinz/vim-signify'

Plug 'tpope/vim-surround'

Plug 'tpope/vim-vinegar'
let g:netrw_banner = 0

" neovim stuff
"   Plug 'Shougo/defx.nvim'
"   Plug 'roxma/nvim-yarp'
"   Plug 'roxma/vim-hug-neovim-rpc'

Plug 'szw/vim-g'

Plug 'majutsushi/tagbar'

Plug 'tpope/vim-obsession'

" Plug 'Shougo/neocomplete.vim' --deprecated
Plug 'Shougo/deoplete.nvim'
" Plug 'Shougo/deoplete-clangx'
Plug 'roxma/nvim-yarp'
" Plug 'roxma/vim-hug-neovim-rpc'
" let g:deoplete#enable_at_startup = 1

Plug 'kronos-io/kronos.vim'

Plug 'ap/vim-buftabline'

Plug 'octol/vim-cpp-enhanced-highlight'
let g:cpp_class_scope_highlight = 1

Plug 'morhetz/gruvbox'

Plug 'brooth/far.vim'

Plug 'benmills/vimux'

Plug 'xolox/vim-misc'
Plug 'xolox/vim-notes'
Plug 'xolox/vim-colorscheme-switcher'

Plug 'kergoth/vim-bitbake'

" Plug 'ludovicchabant/vim-gutentags'

Plug 'w0ng/vim-hybrid'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
let g:UltiSnipsExpandTrigger = "<c-j>"

Plug 'rhysd/git-messenger.vim'
Plug 'tpope/vim-sleuth'
Plug 'leafgarland/typescript-vim'

" Plug 'lyuts/vim-rtags'
" source ~/.vim/gtags.vim

" Initialize plugin system
call plug#end()
call glaive#Install()


" PLUGIN & FUNCTION MAPPINGS
Glaive codefmt plugin[mappings]
" Formats current line only
nnoremap <silent> <leader>ff :FormatLines<CR>
" Formats visual selection
vnoremap <silent> <leader>ff :FormatLines<CR>
" Formats entire file
nnoremap <silent> <leader>fl :FormatCode<CR>

" workaround to get gutter to stay in goyo
function! MyGoyo()
    :GitGutterDisable
    :Goyo
    :GitGutterEnable
endfunction
nnoremap <F1> :call MyGoyo()<CR>

" switch to hpp/cpp
command! -nargs=? -bar -bang Switch call CurtineIncSw()
map <F2> :call CurtineIncSw()<CR>


"" nnoremap <leader>z :call VimuxRunCommand("cd ..")<cr>
" command! WriteAndBuild :write | call VimuxRunCommand("cd ~/wd/unity; source meta-distro/init-build-env; MACHINE=test bitbake packages")
" cnoreabbrev wb WriteAndBuild

" gen tags
nnoremap <f12> :!retag<cr>

" clear search highlights
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

" run vinegar if no file specified
autocmd vimenter * if @% == "" | execute "normal \<Plug>VinegarUp" | endif

" nerdcommenter
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
nnoremap <C-_> :call NERDComment(0,"toggle")<CR>
vnoremap <C-_> :call NERDComment(0,"toggle")<CR>

" neocomplete
let g:neocomplete#enable_at_startup = 1
let g:neocomplcache_disable_auto_complete = 1
inoremap <expr><Tab>        pumvisible() ? "\<C-n>" : "\<Tab>"

" ycm
" let g:ycm_server_python_interpreter = '/usr/bin/python'
" let g:ycm_show_diagnostics_ui = 0
" nnoremap <C-]> :YcmCompleter GoToDefinitionElseDeclaration<CR>

" easymotions
" map <Leader> <Plug>(easymotion-prefix)

" notes
nnoremap <leader>v :e ~/.vimrc<cr>
nnoremap <leader>nt :Note todo \| set background=light \| call xolox#colorscheme_switcher#switch_to("PaperColor")<cr>
vnoremap <leader>ns :NoteFromSelectedText  \| set background=light \| call xolox#colorscheme_switcher#switch_to("PaperColor")<cr>
nnoremap <leader>d :set background=dark \| call xolox#colorscheme_switcher#switch_to("gruvbox")<cr>
nnoremap <leader>l :set background=light \| call xolox#colorscheme_switcher#switch_to("PaperColor")<cr>

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
let $FZF_DEFAULT_COMMAND='ag --ignore tags --ignore build -g ""'

" remap some easier search commands
"   call ag and ag under word
nnoremap <leader>a :Find 
nnoremap <c-a> :exe "Find " .expand('<cword>')<CR>

"   call tags and tags under word
nnoremap <leader>t :Tags<CR>
nnoremap <C-t> :exe "Tags " .expand('<cword>') ""<CR>

nnoremap <c-p> :Files<CR>
" nnoremap <silent> <leader>m :GFiles<CR>
"
" remap google search
nnoremap <leader>g :Google 

"   :Find  - Start fzf with hidden preview window that can be enabled with "?"
"   :Find! - Start fzf in fullscreen and display the preview window above
command! -bang -nargs=* Find
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%', '?'),
  \                 <bang>0)


" FUNCTIONS
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
    \ '/usr/bin/ctags -f - --sort=no --excmd=number %s',
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

function! s:todo() abort
  let entries = []
  for cmd in ['git grep -niI -e TODO -e FIXME -e XXX 2> /dev/null',
            \ 'grep -rniI -e TODO -e FIXME -e XXX * 2> /dev/null']
    let lines = split(system(cmd), '\n')
    if v:shell_error != 0 | continue | endif
    for line in lines
      let [fname, lno, text] = matchlist(line, '^\([^:]*\):\([^:]*\):\(.*\)')[1:3]
      call add(entries, { 'filename': fname, 'lnum': lno, 'text': text })
    endfor
    break
  endfor

  if !empty(entries)
    call setqflist(entries)
    copen
  endif
endfunction
command! Todo call s:todo()


" THEMES
" Tomorrow theme
" colo Tomorrow-Night-Bright
" let g:airline_theme='tomorrow'

" Seoul256 light
" let g:seoul256_light_background = 252
" colo seoul256
" let g:airline_theme='tomorrow'
" set background=light

" Seoul256 dark
let g:seoul256_background = 233
colo seoul256
set background=dark
" let g:airline_theme='alduin'
" let g:airline_theme='base16_shell'

" Modified seoul
" let g:seoul256_background = 235
" colo seoul256-dawesome
" set background=dark
" let g:airline_theme='alduin'
" let g:airline_theme='base16_shell'

" gruvbox dark theme
" colo gruvbox
" set background=dark
" let g:airline_theme='gruvbox'
" let g:airline_theme='tomorrow'

" colo hybrid
" set background=dark

" PaperColor dark
" let g:airline_theme='tomorrow'
" set background=dark
" colo PaperColor
"
"" let g:airline_theme='tomorrow'

" colo tutticolori
"
" let g:zenburn_high_Contrast = 1
" let g:zenburn_alternate_Visual = 1
" colo zenburn
" hi GitGutterDeleteDefault guifg=#8f6161

hi Statement cterm=bold
hi Type cterm=bold

" set cursorline
au InsertEnter * set cursorline
au InsertLeave * set nocursorline
au BufLeave * set nocursorline

" let g:airline_section_b = '%-0.16{airline#util#wrap(airline#extensions#hunks#get_hunks(),100)}%-0.16{airline#util#wrap(airline#extensions#branch#get_head(),80)}'
" let g:airline#extensions#tagbar#enabled = 0
" let g:airline_section_d = '%{getcwd()}'
" let g:airline_left_sep='>'
"
" needs to be at end.. fixes weird insert issue
set nocompatible
