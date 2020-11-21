let mapleader = ","
syntax on

" ____________________________________________________________________________
" Basics {{{

set title
set shortmess+=I " hide launch screen
set laststatus=2 " always show status line
set updatetime=250 "ms
set tags+=tags,cpp_tags;

set ruler
set number
set wildmenu

" 4-spaces
set et ts=4 sts=4 sw=4

" kernel tabs
" set noet ts=8 sw=8

set scrolloff=5 " scroll cursor with context
set noea        " dont autoresize splits
set virtualedit=
set formatoptions+=j
set backspace=indent,eol,start  " backspace remove endls
set autoindent

set backupdir=~/.vim/backup// " store backups in isolated directories
set directory=~/.vim/swap//
set undodir=~/.vim/undo//
set undofile
set undolevels=1000
set undoreload=10000

set hlsearch
set ignorecase
set smartcase   " ignore casing if all lower-case
set incsearch   " show search matches as you type

set fileformat=unix
set fileformats=unix,dos,mac
set formatoptions+=1        " when wrapping paragraphs,
                            " don't end with 1-letter words
set clipboard=unnamedplus
set foldmethod=syntax
set foldlevelstart=99

" terminal settings and colors
set encoding=utf-8
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endi

set mouse=a
if !has('nvim')
  if has("mouse_sgr")
      set ttymouse=sgr
  else
      set ttymouse=xterm2
  end
end

if !has('nvim')
  set noesckeys
end

" cursor shapes + blink     " noblink
if !has('nvim')
  set t_BE=
  set t_Co=256
  let &t_SI.="\e[5 q"         " 6
  let &t_SR.="\e[3 q"         " 4
  let &t_EI.="\e[1 q"         " 2
else
  set guicursor=n-v-c-sm:block,i-ci-ve:ver95-Cursor,r-cr-o:hor20
end

set pastetoggle=<F2>

set wildignore+=*\\artifacts\\*
set wildignore+=*\\build\\*
set wildignore+=*\\meta-openembedded\\*

" jump to the last known position in file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$")
      \ | exe "normal! g'\"" | endif

" highlight line in insert mode
au InsertEnter * set cursorline
au InsertLeave * set nocursorline
au BufLeave * set nocursorline

filetype plugin indent on
au BufRead,BufNewFile messages set filetype=messages
au BufRead,BufNewFile * if expand('%:t') == '' | set filetype=qf | endif

au Syntax * call matchadd('Todo',  '\W\zs\(TODO\|FIXME\|XXX\|BUG\|HACK\)')
au Syntax * call matchadd('Debug', '\W\zs\(NOTE\|INFO\|IDEA\)')

" simple statusline
function! s:statusline_expr()
  let mod = "%{&modified ? '[+] ' : !&modifiable ? '[x] ' : ''}"
  let ro  = "%{&readonly ? '[RO] ' : ''}"
  let ft  = "%{len(&filetype) ? '['.&filetype.'] ' : ''}"
  let fug = "%{exists('g:loaded_fugitive') ? fugitive#statusline() : ''}"
  let sep = ' %= '
  let pos = ' %-12(%l : %c%V%) '
  let pct = ' %P'

  return '%-F '.ro.ft.fug.mod.sep.pos.'%*'.pct
endfunction
let &statusline = s:statusline_expr()

" }}}
" ____________________________________________________________________________
" Mappings {{{

" normal regexs
nnoremap / /\v
vnoremap / /\v

" speed up scrolling of the viewport slightly
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

" <gj,gk> to move between displayed lines
noremap <buffer> <silent> k gk
noremap <buffer> <silent> j gj

" Movement in insert mode
inoremap <C-h> <C-o>h
inoremap <C-l> <C-o>a
" inoremap <C-j> <C-o>j
" inoremap <C-k> <C-o>k

" clear search highlights
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

" fix to paster over without yanking
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
" and prevent it from clearing clipboard when using ctrl+z (need xsel)
function! CopyText()
  normal gv"+y
  :call system('xsel -ib', getreg('+'))
endfunction
nmap <leader>y :call CopyText()<CR>
vmap <leader>y :call CopyText()<CR>

" Make Y behave like other capitals
nnoremap Y y$

" Last inserted text
nnoremap g. :normal! `[v`]<cr><left>

" }}}
" ____________________________________________________________________________
" Plugins {{{

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

Plug 'google/vim-maktaba'
Plug 'google/vim-glaive'
Plug 'google/vim-codefmt'

Plug 'flazz/vim-colorschemes'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'ntpeters/vim-better-whitespace'

Plug 'machakann/vim-highlightedyank'

Plug 'mhinz/vim-signify'

Plug 'tpope/vim-surround'

Plug 'tpope/vim-vinegar'
let g:netrw_banner=0

Plug 'szw/vim-g'

Plug 'majutsushi/tagbar'

Plug 'tpope/vim-obsession'

set completeopt=menu,noselect

if has('nvim')
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  source ~/.config/nvim/coc.vim
  " :CocInstall coc-json coc-python coc-snippets coc-clangd coc-cmake coc-vimlsp coc-explorer coc-fzf coc-sh
  set statusline^=%{coc#status()}
  set cmdheight=1

  Plug 'antoinemadec/coc-fzf'
  let g:coc_fzf_preview = ''
  let g:coc_fzf_opts = []

  Plug 'wellle/context.vim'
  let g:context_nvim_no_redraw = 1
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
  let g:deoplete#enable_at_startup = 1
end

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

Plug 'w0ng/vim-hybrid'

" Plug 'SirVer/ultisnips'
" Plug 'honza/vim-snippets'
" let g:UltiSnipsExpandTrigger = "<c-j>"

Plug 'rhysd/git-messenger.vim'

Plug 'tpope/vim-sleuth'

Plug 'leafgarland/typescript-vim'

Plug 'ericcurtin/CurtineIncSw.vim'

Plug 'unblevable/quick-scope'
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_max_chars=150
augroup qs_colors
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary guifg='#2AFF00' gui=underline ctermfg=155 cterm=underline
  autocmd ColorScheme * highlight QuickScopeSecondary guifg='#FF6565' gui=underline ctermfg=81 cterm=underline
augroup END

Plug 'justinmk/vim-sneak'
let g:sneak#label = 1
let g:sneak#prompt = "sneak> "

" Unused:
" Plug 'easymotion/vim-easymotion'
" Plug 'ludovicchabant/vim-gutentags'
" Plug 'lyuts/vim-rtags'

" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
"  let g:airline_powerline_fonts = 1
"  let g:airline_highlighting_cache=1

call plug#end()
call glaive#Install()

" }}}
" ____________________________________________________________________________
" Plugin mappings {{{

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

" regen tags
nnoremap <f12> :!retag<cr>

" run vinegar if no file specified
au vimenter * if @% == "" | execute "normal \<Plug>VinegarUp" | endif

" nerdcommenter bindings and add space after comment delimiters
let g:NERDSpaceDelims = 1
nnoremap <C-_> :call NERDComment(0,"toggle")<CR>
vnoremap <C-_> :call NERDComment(0,"toggle")<CR>

" move through git hunks
nmap <leader>j <plug>(signify-next-hunk)
nmap <leader>k <plug>(signify-prev-hunk)

" notes
nnoremap <leader>v :e ~/.vimrc<cr>
nnoremap <leader>vv :e ~/.vimrc<cr>
nnoremap <leader>vn :e ~/.config/nvim/init.vim<cr>
nnoremap <leader>vz :e ~/.zshrc<cr>
nnoremap <leader>nt :Note todo \| set background=light \| call xolox#colorscheme_switcher#switch_to("PaperColor")<cr>
vnoremap <leader>ns :NoteFromSelectedText  \| set background=light \| call xolox#colorscheme_switcher#switch_to("PaperColor")<cr>
nnoremap <leader>d :set background=dark \| call xolox#colorscheme_switcher#switch_to("seoul256")<cr>
nnoremap <leader>l :set background=light \| call xolox#colorscheme_switcher#switch_to("PaperColor")<cr>

" FZF settings
let g:fzf_layout = { 'down': '40%' }
let $FZF_DEFAULT_COMMAND='ag --ignore tags --ignore build -g ""'

"   call ag and ag under word
nnoremap <leader>a :Find 
nnoremap <c-a> :exe "Find " .expand('<cword>')<CR>

"   call tags and tags under word
nnoremap <leader>t :Tags<CR>
nnoremap <c-t> :exe "Tags " .expand('<cword>') ""<CR>

"   find files
nnoremap <c-p> :Files<CR>
nnoremap <c-g> :GFiles<CR>

"   find all mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

"   insert mode completions
imap <c-x><c-w> <plug>(fzf-complete-word)
imap <c-x><c-d> <plug>(fzf-complete-path)
imap <c-x><c-f> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

"   google search
nnoremap <leader>g :Google 
" nnoremap <c-g> :exe "Google " .expand('<cword>')<CR>

"   :Find  - Start fzf with hidden preview window that can be enabled with "?"
"   :Find! - Start fzf in fullscreen and display the preview window above
command! -bang -nargs=* Find
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%', '?'),
  \                 <bang>0)

" Unused:
" vimux examples
" nnoremap <leader>z :call VimuxRunCommand("cd ..")<cr>
" command! WriteAndBuild :write | call VimuxRunCommand("cd ~/wd/; ..")
" cnoreabbrev wb WriteAndBuild

" ycm
" let g:ycm_server_python_interpreter = '/usr/bin/python'
" let g:ycm_show_diagnostics_ui = 0
" nnoremap <C-]> :YcmCompleter GoToDefinitionElseDeclaration<CR>

" easymotions
" map <Leader> <Plug>(easymotion-prefix)

" }}}
" ____________________________________________________________________________
" Functions {{{

function! s:GoToDefinition()
  if CocAction('jumpDefinition')
    return v:true
  endif

  let ret = execute("silent! normal \<C-]>")
  if ret =~ "Error" || ret =~ "错误"
    call searchdecl(expand('<cword>'))
  endif
endfunction

nmap <silent> gd :call <SID>GoToDefinition()<CR>

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

" }}}
" ____________________________________________________________________________
" colors {{{

" Seoul256 dark
let g:seoul256_background = 234
colo seoul256
 " Missing in upstream vi-colorschemes for seoul256
hi NormalFloat ctermbg=235 guibg=#333233

" bold statements look better
hi Statement cterm=bold
hi Type cterm=bold

" For transparent bg:
" hi Normal guibg=NONE

" Unused:
" Tomorrow theme
" colo Tomorrow-Night-Bright
" let g:airline_theme='tomorrow'

" Seoul256 light
" let g:seoul256_light_background = 252
" colo seoul256
" set background=light

" Modified seoul
" let g:seoul256_background = 235
" colo seoul256-dawesome
" set background=dark
" let g:airline_theme='alduin'
" let g:airline_theme='base16_shell'

" Gruvbox Dark
" colo gruvbox
" let g:airline_theme='gruvbox'

" Hybrid
" colo hybrid

" PaperColor dark
" colo PaperColor
" let g:airline_theme='tomorrow'

" Light themes
" colo tutticolori
" colo thegoodluck

" Zenburn
" let g:zenburn_high_Contrast = 1
" let g:zenburn_alternate_Visual = 1
" colo zenburn
" hi GitGutterDeleteDefault guifg=#8f6161

" }}}
" ____________________________________________________________________________
" TODO
" - clang formatter
" - random color scheme cycler
