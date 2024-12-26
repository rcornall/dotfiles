let mapleader = ","

" ____________________________________________________________________________
" Basics {{{

syntax on
set title
set shortmess+=I " hide launch screen
set laststatus=2 " always show status line
set updatetime=250 "ms
set tags+=./tags,tags,cpp_tags;

set ruler
set number
set wildmenu
set completeopt=menu,noselect

if has('nvim')
  set list
end

set et ts=4 sts=4 sw=4

set nomodeline

set scrolloff=5 " scroll cursor with context
set nowrap
set sidescrolloff=6
" set noea        " don't autoresize splits
set virtualedit=
set formatoptions+=j
set backspace=indent,eol,start  " backspace remove endls
set textwidth=100
set colorcolumn=100

set backupdir=~/.vim/backup// " store backups in isolated directories
set directory=~/.vim/swap//
set undodir=~/.vim/undo//
set undofile
set undolevels=1000
set undoreload=10000

set hlsearch
set ignorecase
set smartcase   " ignore casing if all lower-case
set autoindent " newer.
set incsearch   " show search matches as you type
if has('nvim')
  set inccommand=split
end

set fileformat=unix
set fileformats=unix,dos,mac
set formatoptions+=1        " when wrapping paragraphs,
                            " don't end with 1-letter words
" set clipboard+=unnamedplus " slow startup time, use autocmd for wsl.
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

if !has('nvim')
  set pastetoggle=<F2>
end

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
au BufRead,BufNewFile messages,*.messages set filetype=messages
au BufRead,BufNewFile * if expand('%:t') == '' | set filetype=qf | endif
au BufRead,BufNewFile *.overlay set filetype=dts
au BufRead,BufNewFile SConscript,SConstruct set filetype=python

au Syntax * call matchadd('Todo',  '\W\zs\(TODO\|FIXME\|XXX\|BUG\|HACK\)')
au Syntax * call matchadd('Debug', '\W\zs\(NOTE\|INFO\|IDEA\)')
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

" enter=newline, but not in quickfix.
nmap <S-Enter> O<Esc>
" nmap <CR> o<Esc>
nnoremap <expr> <CR> &buftype ==# 'quickfix' ? "\<CR>" : 'o<Esc>'

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

" default make
set makeprg=make\ -C\ build\ -j8\ " VERBOSE=1


" WSL clippy:
" let g:clipboard = {
            " \   'name': 'WslClipboard',
            " \   'copy': {
            " \      '+': 'clip.exe',
            " \      '*': 'clip.exe',
            " \    },
            " \   'paste': {
            " \      '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            " \      '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            " \   },
            " \   'cache_enabled': 0,
            " \ }

" }}}
" ____________________________________________________________________________
" Plugins {{{

call plug#begin('~/.vim/plugged')

Plug 'q12321q/neotail'

Plug 'junegunn/goyo.vim'
let g:goyo_width=130
let g:goyo_height=86
let g:goyo_linenr=1

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'terryma/vim-multiple-cursors'
Plug 'preservim/nerdcommenter'

Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

Plug 'google/vim-maktaba'
Plug 'google/vim-glaive'
Plug 'google/vim-codefmt'

Plug 'ntpeters/vim-better-whitespace'

if has('nvim')
autocmd TextYankPost * silent! lua vim.hl.on_yank {higroup='IncSearch', timeout=310}
else
Plug 'machakann/vim-highlightedyank'
end

Plug 'tpope/vim-surround'

Plug 'tpope/vim-vinegar'
let g:netrw_banner=0

Plug 'tpope/vim-obsession'

if has('nvim')
  " use built-in lsp
  Plug 'williamboman/mason.nvim'
  Plug 'williamboman/mason-lspconfig.nvim'
  Plug 'neovim/nvim-lspconfig'

  Plug 'kosayoda/nvim-lightbulb'
  Plug 'ray-x/lsp_signature.nvim'
  Plug 'nvim-lua/lsp-status.nvim'

  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'saadparwaiz1/cmp_luasnip'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-nvim-lua'

  " telescope
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-treesitter/playground'

  " Snippets
  Plug 'L3MON4D3/LuaSnip'
  Plug 'rafamadriz/friendly-snippets'
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
  let g:deoplete#enable_at_startup = 1
end

Plug 'ap/vim-buftabline'

Plug 'brooth/far.vim'

Plug 'benmills/vimux'

Plug 'xolox/vim-misc'
Plug 'xolox/vim-notes'

Plug 'kergoth/vim-bitbake'

Plug 'rhysd/git-messenger.vim'

Plug 'tpope/vim-sleuth'

Plug 'ericcurtin/CurtineIncSw.vim'
" Plug 'karb94/neoscroll.nvim'
Plug 'unblevable/quick-scope'
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_max_chars=150
augroup qs_colors
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary guifg='#2AFF00' gui=underline ctermfg=155 cterm=underline
  autocmd ColorScheme * highlight QuickScopeSecondary guifg='#FF6565' gui=underline ctermfg=81 cterm=underline
augroup END

if has('nvim')
  Plug 'lambdalisue/suda.vim'
  command! W execute "SudaWrite"
end

Plug 'xolox/vim-colorscheme-switcher'
Plug 'flazz/vim-colorschemes'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'morhetz/gruvbox'
Plug 'w0ng/vim-hybrid'

Plug 'chriskempson/vim-tomorrow-theme'
Plug 'chriskempson/base16-vim'
Plug 'sts10/vim-pink-moon'
Plug 'junegunn/seoul256.vim'

" colors with lsp support:
if has('nvim')
  " Plug 'sunjon/shade.nvim'
  Plug 'sainnhe/sonokai'
  Plug 'wadackel/vim-dogrun'
  Plug 'folke/tokyonight.nvim'
  Plug 'luisiacc/gruvbox-baby'
  Plug 'rebelot/kanagawa.nvim'
end

Plug 'ap/vim-css-color'

Plug 'mcchrish/zenbones.nvim'
Plug 'rktjmp/lush.nvim'
" let g:zenbones_compat = 1

call plug#end()
call glaive#Install()

if has('nvim')
  lua require'init'
  lua require("luasnip.loaders.from_vscode").lazy_load({ paths = { "/home/rcornall/.my-snippets" } })
end
"
" }}}
" ____________________________________________________________________________
" Plugin mappings {{{

function! StatuslineLsp() abort
  if luaeval('#vim.lsp.get_clients({bufnr=vim.api.nvim_get_current_buf()}) > 0')
    return luaeval("require('lsp-status').status()")
  endif
endfunction

if has('nvim')
  set statusline=%<%{expand('%:~')}\ %h%m%r%=%-14.(%l,%c%V%)\ %P
  " set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
  set statusline+=%{StatuslineLsp()}
end

nnoremap <c-p> <cmd>lua require'telescope.builtin'.find_files{find_command = { "rg", "--files", "--no-ignore-parent" }}<cr>
nnoremap <c-P> <cmd>lua require'telescope.builtin'.find_files{find_command = { "rg", "--files", "--hidden",  "--no-ignore-parent" }}<cr>
nnoremap <c-a> <cmd>lua require'telescope.builtin'.grep_string{vimgrep_arguments = { "rg", "--no-ignore-parent", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" }, }<cr>
nnoremap <c-t> <cmd>lua require'telescope.builtin'.lsp_workspace_symbols{query=vim.fn.expand "<cword>", fname_width=50, symbol_width=20}<cr>
nnoremap <leader>t <cmd>Telescope lsp_dynamic_workspace_symbols<cr>
command! -nargs=1 Find lua require'telescope.builtin'.grep_string{ shorten_path = true, search =<q-args> }<cr>
nnoremap <leader>a :Find 
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>qf <cmd>lua vim.lsp.buf.code_action()<cr>
command! Rename lua vim.lsp.buf.rename()<CR>

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
nnoremap gr <cmd>lua require'telescope.builtin'.lsp_references{fname_width=89}<cr>


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
nmap <leader>j <plug>(GitGutterNextHunk)
nmap <leader>k <plug>(GitGutterPrevHunk)

" notes
" nnoremap <leader>vt :e ~/.tmux.conf<cr>
if has('nvim')
  nnoremap <leader>v :e ~/.config/nvim/init.vim<cr>
  nnoremap <leader>vv :e ~/.config/nvim/init.vim<cr>
  nnoremap <leader>vn :e ~/.config/nvim/lua/init.lua<cr>
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
" }}}
" ____________________________________________________________________________
" Functions {{{

function! s:close_hidden_bufs()
  let i = 0
  let n = bufnr('$')
  while i < n
    let i = i + 1
    if bufloaded(i) && bufwinnr(i) < 0
      exe 'bd ' . i
    endif
  endwhile
endfun

command! CloseBufs :call s:close_hidden_bufs()<cr>
command! BD :call s:close_hidden_bufs()<cr>

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

" Switch spaces -> kernel tabs
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

" Buffer tags without LSP.
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

" with no lsp, fallback to old custom b(uffer) tags.
" TODO this can be done in on_attach...
function! Btags()
  let ret = execute("lua require'telescope.builtin'.lsp_document_symbols{symbol_width=50}")
  if ret =~ "no client"
    echo "falling back to btags."
    execute("call s:btags()")
  endif
endfunction
nnoremap <leader>r :call Btags()<cr>

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
  " Check if the file is already open in a floating window
  for win in nvim_list_wins()
    let win_config = nvim_win_get_config(win)
    if has_key(win_config, 'relative') && win_config.relative == 'editor'
      let buf = nvim_win_get_buf(win)
      let buf_name = bufname(buf)
      if buf_name == file_name
        " Focus on the existing floating window
        call nvim_set_current_win(win)
        return
      endif
    endif
  endfor

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
    execute "norm G"
    execute "norm zz"
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

" Seoul256 light
" let g:seoul256_light_background = 252
" colo seoul256
" colo seoulbones " good light as well.
" set background=light

" For transparent bg:
" hi Normal guibg=NONE

" Tomorrow theme
colo Tomorrow-Night-Bright
hi Search guibg=#f0e971 guifg=#333312
highlight link @keyword Define
" colo base16-tomorrow-night

" Gruvbox
" colo gruvbox-baby

" Hybrid
" colo hybrid

" PaperColor dark
" colo PaperColor

" Light themes
" set background=light
" colo tutticolori
" colo thegoodluck
" colo zenwritten
" colo seoulbones
" colo base16-classic-light
" set background=light

" Zenburn
" colo zenburn
" hi! DiffDelete ctermfg=210 guifg=#ee877d
" hi! DiffAdd ctermfg=108 guifg=#88b888
" hi! DiffChange ctermfg=228 guifg=#fff176

" let g:tokyonight_style = "night"
" colo tokyonight
" colo dogrun
" colo sonokai
" colo material


" colo base16-tomorrow-night
" colo base16-zenburn
" colo base16-grayscale-dark
" let g:seoul256_background = 235
" colo seoul256
" hi NormalFloat ctermbg=235 guibg=#333233
" hi Pmenu ctermbg=235 guibg=#333233

" kana
" lua require('kanagawa').setup({ keywordStyle = {}, colors={palette = {sumiInk3 = "#1f1f1c"}}})
" colo kanagawa
" hi Statement cterm=bold gui=bold
" hi Comment cterm=italic gui=italic


" zero scheme needs pmenu set..
" highlight Pmenu ctermbg=gray guibg=gray

colo rc
hi Statement cterm=bold gui=bold
hi Comment cterm=italic gui=italic
" hi Type cterm=bold gui=bold

" nnoremap <leader>c :e ~/.config/nvim/colors/rc.vim<cr>
" }}}
" ____________________________________________________________________________

command! ConvertDosToUnix
            \ :e ++ff=dos |
            \ :set ff=unix |

au Syntax * call matchadd('Todo',  '\(TODO\|FIXME\|XXX\|BUG\|HACK\)')
au Syntax * call matchadd('Debug', '\(NOTE\|INFO\|IDEA\)')

hi Todo term=standout ctermfg=0 ctermbg=6 guifg=#000000 guibg=#c0c000
hi! link Title Define

hi def link Done Comment
autocmd BufWinEnter *.md call matchadd('Done', '^.*DONE')
autocmd BufWinEnter *.md call matchadd('Todo', '^.*TODO')

