" some stuff
" set runtimepath^=~/.vim runtimepath+=~/.vim/after
" let &packpath = &runtimepath
" source ~/.vimrc
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

if has('nvim')
  set list
end

set et ts=4 sts=4 sw=4

set scrolloff=5 " scroll cursor with context
set nowrap
set sidescrolloff=6
set noea        " dont autoresize splits
set virtualedit=
set formatoptions+=j
set backspace=indent,eol,start  " backspace remove endls
set autoindent
set textwidth=100

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
if has('nvim')
  set inccommand=split
end

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
end

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
" let &statusline = s:statusline_expr()

" }}}
" ____________________________________________________________________________
" Mappings {{{

" normal regexs
nnoremap / /\v
vnoremap / /\v

" annoying things
nnoremap q: <NOP>
vnoremap q: <NOP>
nnoremap Q <NOP>

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
" noremap <buffer> <silent> k gk
" noremap <buffer> <silent> j gj

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
nnoremap <leader>Y gg"+yG

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

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'rking/ag.vim'

Plug 'terryma/vim-multiple-cursors'
Plug 'preservim/nerdcommenter'

Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

Plug 'google/vim-maktaba'
Plug 'google/vim-glaive'
Plug 'google/vim-codefmt'


Plug 'ntpeters/vim-better-whitespace'

Plug 'machakann/vim-highlightedyank'

Plug 'mhinz/vim-signify'

Plug 'tpope/vim-surround'

Plug 'tpope/vim-vinegar'
let g:netrw_banner=0

Plug 'szw/vim-g'

" Plug 'majutsushi/tagbar'

Plug 'tpope/vim-obsession'

set completeopt=menu,noselect

if has('nvim')
  " built-in lsp
  " LspInstall clangd rust_analyzer vimls sumneko_lua pyright
  Plug 'neovim/nvim-lspconfig'
  Plug 'williamboman/nvim-lsp-installer'
  Plug 'nvim-lua/lsp_extensions.nvim'
  Plug 'kosayoda/nvim-lightbulb'
  Plug 'ray-x/lsp_signature.nvim'
  Plug 'nvim-lua/lsp-status.nvim'

  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'saadparwaiz1/cmp_luasnip'
  " Plug 'tzachar/cmp-tabnine', { 'do': './install.sh' }
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-nvim-lua'

  " telescope
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
  " TSInstall cpp python rust lua vim json
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-treesitter/playground'

  " treesitter

  " Snippets
  Plug 'L3MON4D3/LuaSnip'
  Plug 'rafamadriz/friendly-snippets'
end

if has('nvim')
  " Plug 'neoclide/coc.nvim', {'branch': 'release'}
  " " source ~/.config/nvim/coc.vim
  " " :CocInstall coc-json coc-python coc-snippets coc-clangd coc-cmake coc-vimlsp coc-explorer coc-fzf coc-sh coc-rust-analyzer
  " " set statusline^=%{coc#status()}
  " set statusline=%f\ %h%w%m%r%=%{coc#status()}%-14.(%l,%c%V%)\ %P
  " set cmdheight=1

  " Plug 'antoinemadec/coc-fzf'
  " let g:coc_fzf_preview = ''
  " let g:coc_fzf_opts = []

  " Plug 'wellle/context.vim'
  " let g:context_nvim_no_redraw = 1
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
  let g:deoplete#enable_at_startup = 1
end

Plug 'kronos-io/kronos.vim'

Plug 'ap/vim-buftabline'

" Plug 'octol/vim-cpp-enhanced-highlight'
" let g:cpp_class_scope_highlight = 1
" Plug 'jackguo380/vim-lsp-cxx-highlight'

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
" Plug 'psliwka/vim-smoothie'
Plug 'unblevable/quick-scope'
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_max_chars=150
augroup qs_colors
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary guifg='#2AFF00' gui=underline ctermfg=155 cterm=underline
  autocmd ColorScheme * highlight QuickScopeSecondary guifg='#FF6565' gui=underline ctermfg=81 cterm=underline
augroup END

" Plug 'justinmk/vim-sneak'
" let g:sneak#label = 1
" let g:sneak#prompt = "sneak> "

" Unused:
" Plug 'easymotion/vim-easymotion'
" Plug 'ludovicchabant/vim-gutentags'
" Plug 'lyuts/vim-rtags'

" Plug 'flazz/vim-colorschemes'
" Plug 'rafi/awesome-vim-colorschemes'
" Plug 'folke/lsp-colors.nvim'
" Plug 'chriskempson/vim-tomorrow-theme'
Plug 'chriskempson/base16-vim'
Plug 'sts10/vim-pink-moon'
Plug 'junegunn/seoul256.vim'
" modern with lsp support:
if has('nvim')
  " Plug 'sunjon/shade.nvim'
  Plug 'marko-cerovac/material.nvim'
  Plug 'sainnhe/sonokai'
  Plug 'wadackel/vim-dogrun'
  Plug 'folke/tokyonight.nvim'
  Plug 'luisiacc/gruvbox-baby'
  Plug 'rebelot/kanagawa.nvim'
end

Plug 'ap/vim-css-color'

Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

call plug#end()
call glaive#Install()


lua require'lsp'

function! StatuslineLsp() abort
  return luaeval("require('lsp-status').status()")
endfunction
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
set statusline+=%{StatuslineLsp()}

" autocmd BufEnter,BufWinEnter,TabEnter *.rs :lua require'lsp_extensions'.inlay_hints()
autocmd BufEnter,BufWinEnter,TabEnter *.rs :lua require'lsp_extensions'.inlay_hints{ prefix = '» ', highlight = "NonText", enabled = {"TypeHint", "ChainingHint", "ParameterHint"} }

nnoremap <c-p> <cmd>lua require'telescope.builtin'.find_files{find_command = { "rg", "--files", "--no-ignore-parent" }}<cr>
nnoremap <c-a> <cmd>lua require'telescope.builtin'.grep_string{vimgrep_arguments = { "rg", "--no-ignore-parent", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" }, }<cr>

" nnoremap <c-t> :Telescope lsp_workspace_symbols query=.expand('<cword>')<cr>
nnoremap <c-t> :exe "Telescope lsp_workspace_symbols query=".expand('<cword>')<CR>
nnoremap <leader>t <cmd>Telescope lsp_dynamic_workspace_symbols<cr>
command! -nargs=1 Find lua require'telescope.builtin'.grep_string{ vimgrep_arguments = { "rg", "--no-ignore-parent", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" }, shorten_path = true, search =<q-args> }<cr>
nnoremap <leader>a :Find 
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>r <cmd>Telescope lsp_document_symbols<cr>
nnoremap <leader>qf <cmd>Telescope lsp_code_actions<cr>
command! Rename lua vim.lsp.buf.rename()<CR>
" todo fallback to btags. when lsp broken.
" nnoremap <leader>rr <cmd>Telescope lsp_document_symbols<cr>
" nnoremap <leader>t <cmd>Telescope lsp_document_symbols<cr>
function! TelescopeGoToDefinition()
  let ret = execute("Telescope lsp_definitions")
  if ret =~ "no client"
    echo "falling back to gd."
    normal! gd
  endif
endfunction
function! TelescopeGoToGlobalDefinition()
  let ret = execute("Telescope lsp_definitions")
  if ret =~ "no client"
    echo "falling back to gD."
    normal! gD
  endif
endfunction
nnoremap gd :call TelescopeGoToDefinition()<CR>
nnoremap gr <cmd>Telescope lsp_references<cr>


" let g:tokyonight_style = "night"
" colo tokyonight
" colo dogrun
" colo sonokai
" colo material
" colo gruvbox
" colo gruvbox-baby
lua require('kanagawa').setup({ keywordStyle = {}, colors={bg = "#1f1f1c"}})
colo kanagawa
hi Statement cterm=bold gui=bold
" hi Type cterm=bold gui=bold
hi Comment cterm=italic gui=italic
hi PMenuSel cterm=bold guifg=#C8C093 guibg=#363646
hi TabLineSel ctermfg=242 ctermbg=0 guibg=#2D4F67
hi VertSplit guibg=#2D4F67
" colo base16-tomorrow-night-bright
" colo base16-tomorrow-night
" colo base16-zenburn
" colo base16-grayscale-dark
" colo base16-gruvbox-dark-pale
" let g:seoul256_background = 235
" colo seoul256
" hi NormalFloat ctermbg=235 guibg=#333233
" hi Pmenu ctermbg=235 guibg=#333233

if has('nvim')
lua << EOF
local ok, mod = pcall(require, 'shade')
if ok then
  mod.setup({
    overlay_opacity = 73,
    opacity_step = 1,
    keys = {
      brightness_up    = '<C-Up>',
      brightness_down  = '<C-Down>',
      toggle           = '<Leader>s',
    }
  })
end
EOF
end
"
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
function! Switchheader()
  let ret = execute("ClangdSwitchSourceHeader")
  if ret =~ "not supp"
    echo "falling back to curtine.."
    execute("call CurtineIncSw()")
  endif
endfunction
map <F2> :call Switchheader()<CR>

" regen tags
nnoremap <f12> :!retag<cr>

" run vinegar if no file specified
au vimenter * if @% == "" | execute "normal \<Plug>VinegarUp" | endif

" nerdcommenter bindings and add space after comment delimiters
let g:NERDSpaceDelims = 1
"" vim 8 / neovim HEAD runtime: when ft==python, cms:=#\ %s
"   -- when g:NERDSpaceDelims==1, then NERDComment results in double space
let g:NERDCustomDelimiters = {
      \ 'python': { 'left': '#', 'right': '' }
      \ }
nnoremap <C-_> :call nerdcommenter#Comment(0,"toggle")<CR>
vnoremap <C-_> :call nerdcommenter#Comment(0,"toggle")<CR>

" move through git hunks
nmap <leader>j <plug>(signify-next-hunk)
nmap <leader>k <plug>(signify-prev-hunk)

" notes
" nnoremap <leader>vt :e ~/.tmux.conf<cr>
if has('nvim')
  nnoremap <leader>v :e ~/.config/nvim/init.vim<cr>
else
  nnoremap <leader>v :e ~/.vimrc<cr>
end
" nnoremap <leader>vz :e ~/.zshrc<cr>
" nnoremap <leader>nt :Note todo \| set background=light \| call xolox#colorscheme_switcher#switch_to("PaperColor")<cr>
" vnoremap <leader>ns :NoteFromSelectedText  \| set background=light \| call xolox#colorscheme_switcher#switch_to("PaperColor")<cr>
nnoremap <leader>d :set background=dark \| call xolox#colorscheme_switcher#switch_to("seoul256")<cr>
nnoremap <leader>l :set background=light \| call xolox#colorscheme_switcher#switch_to("PaperColor")<cr>

" FZF settings
let g:fzf_layout = { 'down': '60%' }
let $FZF_DEFAULT_COMMAND='ag --ignore tags --ignore build -g ""'
let $FZF_DEFAULT_OPTS='--color "fg:#bbccdd,fg+:#ddeeff,bg:#334455,preview-bg:#223344,border:#778899"'
let $BAT_THEME='gruvbox-dark'

"   call ag and ag under word
" nnoremap <leader>a :Find 
" nnoremap <c-a> :exe "Find " .expand('<cword>')<CR>

"   call tags and tags under word
" nnoremap <leader>t :CocFzfList symbols<CR>
" nnoremap <c-t> :exe "CocFzfList symbols " .expand('<cword>') ""<CR>

"   coc-rename (refactor)
" command! Rename execute "normal \<Plug>(coc-rename)"
" command! FormatCoc execute "normal \<Plug>(coc-format-selected)"
" vmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)


"   find files
" nnoremap <c-p> :Files<CR>
" nnoremap <c-g> :GFiles<CR>

"   find all mappings
" nmap <leader><tab> <plug>(fzf-maps-n)
" xmap <leader><tab> <plug>(fzf-maps-x)
" omap <leader><tab> <plug>(fzf-maps-o)

"   insert mode completions
" imap <c-x><c-w> <plug>(fzf-complete-word)
" imap <c-x><c-d> <plug>(fzf-complete-path)
" imap <c-x><c-f> <plug>(fzf-complete-file-ag)
" imap <c-x><c-l> <plug>(fzf-complete-line)

"   google search
nnoremap <leader>g :Google 
" nnoremap <c-g> :exe "Google " .expand('<cword>')<CR>

"   :Find  - Start fzf with hidden preview window that can be enabled with "?"
"   :Find! - Start fzf in fullscreen and display the preview window above
" call fzf#vim#ag_raw('--color-path "1;31" '.shellescape(<q-args>),
" command! -bang -nargs=* Find
            " \ call fzf#vim#ag(<q-args>,
            " \                 <bang>0 ? fzf#vim#with_preview('up:60%')
            " \                         : fzf#vim#with_preview('right:50%', '?'),
            " \                 <bang>0)

" Unused:
" vimux examples
" nnoremap <leader>z :call VimuxRunCommand("cd ..")<cr>
" command! WriteAndBuild :write | call VimuxRunCommand("cd ~/wd/; ..")
" cnoreabbrev wb WriteAndBuild

" easymotions
" map <Leader> <Plug>(easymotion-prefix)

" }}}
" ____________________________________________________________________________
" Functions {{{

function! s:rename_file()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name | exec ':silent !rm ' . old_name | exec ':bd ' . old_file
        redraw!
    endif
endfunction
command! RenameFile :call s:rename_file()<cr>

command! HideStuff
            \ :set noshowmode |
            \ :set noruler |
            \ :set laststatus=0 |
            \ :set noshowcmd |
            \ :set cmdheight=1 |
            \ :set nonumber |
            \ :set showtabline=0 |

let s:tab_state=0
function! s:toggle_tabs()
  if s:tab_state
    set et ts=4 sw=4 sts=4
    echo("4-spaces")
  else
    set noet ts=8 sw=8 sts=4
    echo("Kernel tabs")
  endif
  let s:tab_state = !s:tab_state
endfunction
command! Tt call s:toggle_tabs()
nnoremap <F4> :Tt<CR>

" function! s:GoToDefinition()
  " if CocAction('jumpDefinition')
    " return v:true
  " endif

  " let ret = execute("silent! normal \<C-]>")
  " if ret =~ "Error" || ret =~ "错误"
    " call searchdecl(expand('<cword>'))
  " endif
" endfunction

" nmap <silent> gd :call <SID>GoToDefinition()<CR>

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

" command! BTags call s:btags()
" nnoremap <leader>r :BTags<CR>

function! s:buflist()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! s:bufopen(e)
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
endfunction

" nnoremap <leader>b :call fzf#run({
" \   'source':  reverse(<sid>buflist()),
" \   'sink':    function('<sid>bufopen'),
" \   'options': '+m',
" \   'down':    len(<sid>buflist()) + 2
" \ })<CR>

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

function! Spawn_note_window() abort
  let path = "~/notes/"
  let file_name = path.strftime("%d-%m-%y.md")
  " Empty buffer
  let buf = nvim_create_buf(v:false, v:true)
  " Get current UI
  let ui = nvim_list_uis()[0]
  " Dimension
  let width = (ui.width/2)
  let height = (ui.height/2)
  " Options for new window
  let opts = {'relative': 'editor',
              \ 'width': width,
              \ 'height': height,
              \ 'col': (ui.width - width)/2,
              \ 'row': (ui.height - height)/2,
              \ 'anchor': 'NW',
              \ 'style': 'minimal',
              \ 'border': 'single',
              \ }
  " Spawn window
  let win = nvim_open_win(buf, 1, opts)
  " Now we can actually open or create the note for the day?
  if filereadable(expand(file_name))
    execute "e ".fnameescape(file_name)
    let column = 80
    execute "set textwidth=".column
    execute "set colorcolumn=".column
    " execute "norm Go"
    " execute "norm G"
    " execute "norm zz"
    " execute "startinsert"
  else
    execute "e ".fnameescape(file_name)
    let column = 80
    execute "set textwidth=".column
    execute "set colorcolumn=".column
    execute "norm Gi# ".strftime("%d-%m-%y")
    execute "norm G2o"
    execute "norm Gi- " 
    " execute "norm zz"
    " execute "startinsert"
  endif
endfunction
nmap <silent> <leader>n :call Spawn_note_window() <CR>

" }}}
" ____________________________________________________________________________
" colors {{{

" Seoul256 dark
" let g:seoul256_background = 234
" colo seoul256
" " Missing in upstream vi-colorschemes for seoul256
" hi NormalFloat ctermbg=235 guibg=#333233
" hi Pmenu ctermbg=235 guibg=#333233

" For transparent bg:
" hi Normal guibg=NONE

" Tomorrow theme
" colo Tomorrow-Night-Bright
" TomorrowNightBright
" colo Tomorrow-Night-Bright
" hi Search guibg=#f0e971 guifg=#333312
" colo base16-tomorrow-night

" Seoul256 light
" let g:seoul256_light_background = 252
" colo seoul256
" set background=light

" Modified seoul
" let g:seoul256_background = 235
" colo seoul256-dawesome
" set background=dark

" Gruvbox Dark
" colo gruvbox

" Hybrid
" colo hybrid

" PaperColor dark
" colo PaperColor

" Light themes
" colo tutticolori
" colo thegoodluck

" Zenburn
" colo zenburn
" hi! DiffDelete ctermfg=210 guifg=#ee877d
" hi! DiffAdd ctermfg=108 guifg=#88b888
" hi! DiffChange ctermfg=228 guifg=#fff176

" Bold statements look better.
" hi Statement cterm=bold gui=bold
" hi Type cterm=bold gui=bold
" hi Comment cterm=italic gui=italic

" }}}
" ____________________________________________________________________________
" TODO
" - clang formatter
" - random color scheme cycler
" - replace coc with nvim native lsp
