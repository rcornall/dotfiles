" minimal vimrc for windows journal note taking at work.

let mapleader=","
syntax on

set backspace=indent,eol,start
set laststatus=2
set ruler
set number
set wildmenu
set scrolloff=5
set sidescrolloff=5
set hlsearch
set ignorecase
set smartcase
set smartindent
set incsearch
" set ts=4 sw=4 sts=4

set nowrap

set textwidth=120

"set clipboard=unnamedplus
set mouse=a
set nobackup
set undofile
set undodir=C:\Users\RCornall\.vim\.undo\\
set viewdir=C:\Users\RCornall\.vim\.view\\
set noswapfile
" nnoremap / /\v
" vnoremap / /\v
nnoremap q: <NOP>
vnoremap q: <NOP>
nnoremap Q <NOP>
nnoremap <C-e> 2<C-e>
nnoremap <C-y> 2<C-y>

nmap <CR> o<Esc>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-k> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

nnoremap Y y$

set guifont=Courier_New:h11:cANSI:qDRAFT
colorscheme pablo

nnoremap <leader>v :e ~/.vimrc<cr>
nnoremap <leader>j :e ~\Documents\journal.md<cr>

" syn match   myTodo   contained   "\<\(TODO\|FIXME\):" " needs autobuf..
" hi def link myTodo Todo
au Syntax * call matchadd('Todo',  '\(TODO\|FIXME\|XXX\|BUG\|HACK\)')
au Syntax * call matchadd('Debug', '\(NOTE\|INFO\|IDEA\)')
 
" syn keyword   cTodo   TODO FIXME XXX
" highlight cTODO ctermbg=red ctermfg=yellow term=bold,italic guifg=#000000 guibg=#e6df1e

" hi def Done link
hi def link Done Comment
autocmd BufWinEnter *.md call matchadd('Done', '^.*DONE') "  | call matchadd('Cats', '^.*cat.*$')

augroup remember_folds
  autocmd!
  autocmd BufWinLeave *.md mkview
  autocmd BufWinEnter *.md silent! loadview
augroup END

" macro for next date entry.
let _d=strftime("## %b %e %Y")
let @a='?ToDo''skkk:put =_dkddoO- '

" grep for TODOs that aren't DONE.
nnoremap <leader>t :vimgrep /\C^\(.*TODO\)\&\(.*DONE\)\@!/ % \| copen<cr>

" macro to insert a new entry to the todolist..
let @n='/ToDo''sjyyG?+-------------Pwkyf.jvf.p0wwwl'

" mark done
let @d='$12hRDONE       0wwwj'
" mark in progress
let @p='$12hRIN PROGRESS0wwwj'

nnoremap <leader>a @a
nnoremap <leader>n @n
nnoremap <leader>d @d
nnoremap <leader>p @p

" open a new details note for the entry on cursor.
command! Note
	\ execute 'normal 0f:wv$F F F F b"*y' |
	\ let $_file=getreg("*") |
	\ let $_file = substitute(getreg('*'), '\s', '-', 'g') |
	\ let $_file = substitute($_file, '[.,]', '', 'g') |
	\ let $_file .= '.md' |
	\ let $_file = '~\Documents\journal-todo-details\' . $_file |
	\ if filereadable(expand($_file)) | exe 'split +' $_file | else | split + $_file | execute 'normal i# ' | exe 'normal "*po- ' | endif

" custom highlight groups
hi InProgress ctermbg=8 term=NONE cterm=NONE guifg=NONE guibg=NONE
autocmd BufWinEnter *.md call matchadd('InProgress', '^.*IN PROGRESS')

hi SizeSmall ctermfg=Green guifg=Green
hi SizeMedium ctermfg=Yellow guifg=Yellow
hi SizeLarge ctermfg=Red guifg=Red

hi DifficultyEasy ctermfg=Green guifg=Green
hi DifficultyMedium ctermfg=Yellow guifg=Yellow
hi DifficultyHard ctermfg=Red guifg=Red

au Syntax * call matchadd('SizeSmall', '(small-')
au Syntax * call matchadd('SizeMedium', '(medium-')
au Syntax * call matchadd('SizeLarge', '(large-')

au Syntax * call matchadd('DifficultyEasy', '-easy)')
au Syntax * call matchadd('DifficultyMedium', '-medium)')
au Syntax * call matchadd('DifficultyHard', '-hard)')
au Syntax * call matchadd('DifficultyHard', '-hard)')

" move up or down entry lines, and adjust the entry number.
nnoremap <leader>K ddkP0jhk0w
nnoremap <leader>J ddp0khj0w

