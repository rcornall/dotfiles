" local syntax file - set colors on a per-machine basis:
" vim: tw=0 ts=4 sw=4
" Vim color file
" Maintainer:	Ron Aaron <ron@ronware.org>
" Last Change:	2016 Sep 04

hi clear
set background=dark
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "rc"
hi Normal		  guifg=white  guibg=#070a0a
hi Scrollbar	  guifg=darkcyan guibg=cyan
hi Menu			  guifg=black guibg=cyan
hi SpecialKey	  term=bold  cterm=bold  ctermfg=darkred  guifg=#cc0000
hi NonText		  term=bold  cterm=bold  ctermfg=darkred  gui=bold      guifg=grey
hi Directory	  term=bold  cterm=bold  ctermfg=brown  guifg=#cc8000
hi ErrorMsg		  term=standout  cterm=bold  ctermfg=grey  ctermbg=red  guifg=White  guibg=Red
hi Search		  term=reverse  cterm=reverse      guifg=black  guibg=#ffee30
hi MoreMsg		  term=bold  cterm=bold  ctermfg=darkgreen	gui=bold  guifg=SeaGreen
" hi ModeMsg		  term=bold  cterm=bold  gui=bold  guifg=White	guibg=Blue
hi LineNr		  term=underline  cterm=bold  ctermfg=darkcyan	guifg=#747d80 gui=bold
hi Question		  term=standout  cterm=bold  ctermfg=darkgreen	gui=bold  guifg=Green
hi StatusLine	  term=bold,reverse  cterm=bold ctermfg=lightblue ctermbg=white gui=NONE guifg=#e9f7ec guibg=#3d4541
hi StatusLineNC   term=bold	    ctermfg=white ctermbg=lightblue gui=NONE guifg=#8b9181 guibg=#181c1a
hi Title		  term=bold  cterm=bold  ctermfg=darkmagenta  gui=bold	guifg=Magenta
hi Visual		  term=reverse	cterm=reverse  guibg=#3c524c
hi HighlightedyankRegion	  term=reverse	cterm=reverse  guibg=#005278
hi WarningMsg	  term=standout  cterm=bold  ctermfg=darkred guifg=Red
hi Cursor		  gui=NONE guifg=bg	guibg=Green
hi Comment		  term=bold  cterm=bold ctermfg=cyan gui=italic guifg=#7690db
hi Constant		  term=underline  cterm=bold ctermfg=magenta  guifg=#ffa0a0
hi Special		  term=bold  cterm=bold ctermfg=red  guifg=#ffde91
hi Identifier	  term=underline   ctermfg=brown  guifg=#b8eaff
hi Statement	  term=bold  cterm=bold ctermfg=yellow	gui=bold  guifg=#d9d07e
hi PreProc		  term=underline  ctermfg=darkmagenta   guifg=#cc78cc
hi Type			  term=underline  cterm=bold ctermfg=lightgreen  gui=bold  guifg=#8cd1b2
hi Error		  term=reverse	ctermfg=darkcyan  ctermbg=black  guifg=Red	guibg=Black
hi Todo			  term=standout  ctermfg=black	ctermbg=darkcyan  guifg=Blue  guibg=#ff6ed4
hi CursorLine	  term=underline  guibg=#212121 cterm=underline
hi CursorColumn	  term=underline  guibg=#555555 cterm=underline
hi MatchParen	  term=reverse  ctermfg=blue guibg=#0048c4
hi TabLine		  term=bold,reverse  cterm=bold ctermfg=lightblue ctermbg=white gui=italic guifg=grey guibg=black
hi TabLineFill	  term=bold,reverse  cterm=bold ctermfg=lightblue ctermbg=white gui=italic guifg=grey guibg=black
hi TabLineSel	  term=reverse	ctermfg=white ctermbg=lightblue gui=bold guifg=#e9f7ec guibg=#1c2925
hi Underlined	  term=underline cterm=bold,underline ctermfg=lightblue guifg=lightblue gui=bold,underline
hi Ignore		  ctermfg=black ctermbg=black guifg=black guibg=black
hi EndOfBuffer	  term=bold  cterm=bold  ctermfg=darkred guifg=#cc0000 gui=bold
hi String		  guifg=#c2f564
hi link IncSearch		Visual
hi link Character		Constant
hi link Number			Constant
hi link Boolean			Constant
hi link Float			Number
hi link Function		Identifier
hi link Conditional		Statement
hi link Repeat			Statement
hi link Label			Statement
hi link Operator		Statement
hi link Keyword			Statement
hi link Exception		Statement
hi link Include			PreProc
hi link Define			PreProc
hi link Macro			PreProc
hi link PreCondit		PreProc
hi link StorageClass	Type
hi link Structure		Type
hi link Typedef			Type
hi link Tag				Special
hi link SpecialChar		Special
hi link Delimiter		Special
hi link SpecialComment	Special
hi link Debug			Special
hi Pmenu ctermbg=black guibg=grey
hi PmenuSel ctermbg=black gui=italic guifg=grey guibg=black
hi NormalFloat ctermbg=235 guibg=#1d2120

hi VertSplit gui=NONE guifg=black guibg=#181c1a
hi SignColumn gui=NONE guifg=black guibg=#181c1a

hi TelescopeSelection guibg=#3c524c

hi DiffAdd guibg=DarkGreen
hi DiffDelete guibg=DarkRed
hi DiffChange guibg=#a36b0b


" hi NormalColor guifg=Black guibg=Green ctermbg=46 ctermfg=0
" hi InsertColor ctermbg=51 ctermfg=0 guifg=Black guibg=Cyan
" hi ReplaceColor ctermbg=165 ctermfg=0 guifg=Black guibg=maroon1
" hi VisualColor ctermbg=202 ctermfg=0 guifg=Black guibg=Orange
" set statusline+=%#NormalColor#%{(mode()=='n')?'\ \ NORMAL\ ':''}
" set statusline+=%#InsertColor#%{(mode()=='i')?'\ \ INSERT\ ':''}
" set statusline+=%#ReplaceColor#%{(mode()=='R')?'\ \ REPLACE\ ':''}
" set statusline+=%#VisualColor#%{(mode()=='v')?'\ \ VISUAL\ ':''}
hi ModeMsg	cterm=bold gui=bold guifg=#ff9e3b
