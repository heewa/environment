" Vim color file
"
" Author: Tomas Restrepo <tomas@winterdom.com>
"
" Note: Based on the monokai theme for textmate
" by Wimer Hazenberg and its darker variant 
" by Hamish Stuart Macpherson
"

hi clear

"set background=dark
if version > 580
    " no guarantees for version 5.8 and below, but this makes it stop
    " complaining
    hi clear
    if exists("syntax_on")
        syntax reset
    endif
endif
let g:colors_name="heewa"

if exists("g:molokai_original")
    let s:molokai_original = g:molokai_original
else
    let s:molokai_original = 0
endif

" Set console defaults first
hi Comment term=bold ctermfg=cyan
hi Constant term=underline ctermfg=magenta 
hi Special term=bold ctermfg=magenta 
hi Identifier term=underline ctermfg=blue 
hi Statement term=bold ctermfg=red
hi PreProc term=underline ctermfg=green
hi Type term=underline ctermfg=blue
hi Visual term=reverse ctermfg=magenta ctermbg=black
hi Search term=reverse ctermfg=black ctermbg=cyan   
hi Tag term=bold ctermfg=green
hi Error term=reverse ctermfg=15 ctermbg=9  
hi Todo term=standout ctermbg=yellow ctermfg=black  
hi  StatusLine term=bold,reverse cterm=NONE ctermfg=Yellow ctermbg=DarkGray   

hi Boolean         guifg=#AE81FF ctermfg=magenta
hi Character       guifg=#E6DB74 ctermfg=yellow
hi Number          guifg=#AE81FF ctermfg=magenta
hi String          guifg=#E6DB74 ctermfg=yellow
hi Conditional     guifg=#F92672 ctermfg=red      gui=bold
hi Constant        guifg=#AE81FF ctermfg=magenta  gui=bold
hi Cursor          guifg=#000000 guibg=#A8FF05
hi Debug           guifg=#BCA3A3 ctermfg=yellow   gui=bold
hi Define          guifg=#66D9EF ctermfg=blue
hi Delimiter       guifg=#8F8F8F ctermfg=cyan
hi DiffAdd                       guibg=#13354A
hi DiffChange      guifg=#89807D guibg=#4C4745 ctermfg=cyan
hi DiffDelete      guifg=#960050 guibg=#1E0010 ctermfg=red
hi DiffText                      guibg=#4C4745 gui=italic,bold

hi Directory       guifg=#A6E22E ctermfg=green gui=bold
hi Error           guifg=#960050 guibg=#1E0010 ctermfg=red ctermbg=black
hi ErrorMsg        guifg=#F92672 guibg=#232526 gui=bold ctermfg=red ctermbg=black
hi Exception       guifg=#A6E22E ctermfg=green gui=bold
hi Float           guifg=#AE81FF ctermfg=magenta
hi FoldColumn      guifg=#465457 guibg=#000000
hi Folded          guifg=#465457 guibg=#000000
hi Function        guifg=#A6E22E ctermfg=green
hi Identifier      guifg=#FD971F ctermfg=yellow
hi Ignore          guifg=#808080 guibg=bg ctermfg=cyan
hi IncSearch       guifg=#C4BE89 guibg=#000000 ctermfg=yellow

hi Keyword         guifg=#F92672 ctermfg=red     gui=bold
hi Label           guifg=#E6DB74 ctermfg=yellow  gui=none
hi Macro           guifg=#C4BE89 ctermfg=yellow  gui=italic
hi SpecialKey      guifg=#66D9EF ctermfg=blue    gui=italic

hi MatchParen      guifg=#000000 guibg=#FD971F gui=bold ctermfg=black ctermbg=yellow
hi ModeMsg         guifg=#E6DB74 ctermfg=yellow
hi MoreMsg         guifg=#E6DB74 ctermfg=yellow
hi Operator        guifg=#F92672 ctermfg=red

" complete menu
hi Pmenu           guifg=#66D9EF guibg=#000000 ctermfg=blue
hi PmenuSel                      guibg=#808080 ctermbg=cyan
hi PmenuSbar                     guibg=#080808 ctermbg=cyan
hi PmenuThumb      guifg=#66D9EF ctermfg=blue

hi PreCondit       guifg=#A6E22E ctermfg=green gui=bold
hi PreProc         guifg=#A6E22E ctermfg=green
hi Question        guifg=#66D9EF ctermfg=blue
hi Repeat          guifg=#F92672 ctermfg=red   gui=bold
hi Search          guifg=#FFFFFF guibg=#455354
" marks column
hi SignColumn      guifg=#A6E22E guibg=#232526 ctermfg=green
hi SpecialChar     guifg=#F92672 ctermfg=red   gui=bold
hi SpecialComment  guifg=#465457               gui=bold
hi Special         guifg=#66D9EF guibg=bg      gui=italic ctermfg=blue
hi SpecialKey      guifg=#888A85               gui=italic
if has("spell")
    hi SpellBad    guisp=#FF0000 gui=undercurl ctermfg=red
    hi SpellCap    guisp=#7070F0 gui=undercurl ctermfg=blue
    hi SpellLocal  guisp=#70F0F0 gui=undercurl ctermfg=blue
    hi SpellRare   guisp=#FFFFFF gui=undercurl
endif
hi Statement       guifg=#F92672 ctermfg=red   gui=bold
hi StatusLine      guifg=#455354 guibg=fg
hi StatusLineNC    guifg=#808080 guibg=#080808 ctermfg=cyan
hi StorageClass    guifg=#FD971F ctermfg=yellow gui=italic
hi Structure       guifg=#66D9EF ctermfg=blue
hi Tag             guifg=#F92672 ctermfg=red   gui=italic
hi Title           guifg=#ef5939 ctermfg=red
hi Todo            guifg=#FFFFFF guibg=bg      gui=bold

hi Typedef         guifg=#66D9EF ctermfg=blue
hi Type            guifg=#66D9EF ctermfg=blue  gui=none
hi Underlined      guifg=#808080 ctermfg=cyan  gui=underline

hi VertSplit       guifg=#808080 guibg=#080808 gui=bold ctermfg=cyan
hi VisualNOS                     guibg=#403D3D ctermbg=cyan
hi Visual                        guibg=#403D3D ctermbg=cyan
hi WarningMsg      guifg=#FFFFFF guibg=#333333 gui=bold
hi WildMenu        guifg=#66D9EF guibg=#000000 ctermfg=blue

if s:molokai_original == 1
   hi Normal          guifg=#F8F8F2 guibg=#272822
   hi Comment         guifg=#75715E
   hi CursorLine                    guibg=#3E3D32
   hi CursorColumn                  guibg=#3E3D32
   hi LineNr          guifg=#BCBCBC guibg=#3B3A32
   hi NonText         guifg=#BCBCBC guibg=#3B3A32
else
   hi Normal          guifg=#F8F8F2 guibg=#1B1D1E
   hi Comment         guifg=#465457
   hi CursorLine                    guibg=#293739
   hi CursorColumn                  guibg=#293739
   hi LineNr          guifg=#BCBCBC guibg=#232526
   hi NonText         guifg=#BCBCBC guibg=#232526
end

"
" Support for 256-color terminal
"
if &t_Co > 255
   hi Boolean         ctermfg=135
   hi Character       ctermfg=144
   hi Number          ctermfg=135
   hi String          ctermfg=144
   hi Conditional     ctermfg=161               cterm=bold
   hi Constant        ctermfg=135               cterm=bold
   hi Cursor          ctermfg=16  ctermbg=253
   hi Debug           ctermfg=225               cterm=bold
   hi Define          ctermfg=81
   hi Delimiter       ctermfg=241

   hi DiffAdd                     ctermbg=24
   hi DiffChange      ctermfg=181 ctermbg=239
   hi DiffDelete      ctermfg=162 ctermbg=53
   hi DiffText                    ctermbg=102 cterm=bold

   hi Directory       ctermfg=118               cterm=bold
   hi Error           ctermfg=219 ctermbg=89
   hi ErrorMsg        ctermfg=199 ctermbg=16    cterm=bold
   hi Exception       ctermfg=118               cterm=bold
   hi Float           ctermfg=135
   hi FoldColumn      ctermfg=67  ctermbg=16
   hi Folded          ctermfg=67  ctermbg=16
   hi Function        ctermfg=118
   hi Identifier      ctermfg=208
   hi Ignore          ctermfg=244 ctermbg=232
   hi IncSearch       ctermfg=193 ctermbg=16

   hi Keyword         ctermfg=161               cterm=bold
   hi Label           ctermfg=229               cterm=none
   hi Macro           ctermfg=193
   hi SpecialKey      ctermfg=81

   hi MatchParen      ctermfg=16  ctermbg=208 cterm=bold
   hi ModeMsg         ctermfg=229
   hi MoreMsg         ctermfg=229
   hi Operator        ctermfg=161

   " complete menu
   hi Pmenu           ctermfg=81  ctermbg=16
   hi PmenuSel                    ctermbg=244
   hi PmenuSbar                   ctermbg=232
   hi PmenuThumb      ctermfg=81

   hi PreCondit       ctermfg=118               cterm=bold
   hi PreProc         ctermfg=118
   hi Question        ctermfg=81
   hi Repeat          ctermfg=161               cterm=bold
   hi Search          ctermfg=253 ctermbg=66

   " marks column
   hi SignColumn      ctermfg=118 ctermbg=235
   hi SpecialChar     ctermfg=161               cterm=bold
   hi SpecialComment  ctermfg=245               cterm=bold
   hi Special         ctermfg=81  ctermbg=232
   hi SpecialKey      ctermfg=245

   hi Statement       ctermfg=161               cterm=bold
   hi StatusLine      ctermfg=238 ctermbg=253
   hi StatusLineNC    ctermfg=244 ctermbg=232
   hi StorageClass    ctermfg=208
   hi Structure       ctermfg=81
   hi Tag             ctermfg=161
   hi Title           ctermfg=166
   hi Todo            ctermfg=231 ctermbg=232   cterm=bold

   hi Typedef         ctermfg=81
   hi Type            ctermfg=81                cterm=none
   hi Underlined      ctermfg=244               cterm=underline

   hi VertSplit       ctermfg=244 ctermbg=232   cterm=bold
   hi VisualNOS                   ctermbg=238
   hi Visual                      ctermbg=235
   hi WarningMsg      ctermfg=231 ctermbg=238   cterm=bold
   hi WildMenu        ctermfg=81  ctermbg=16

   hi Normal          ctermfg=252 ctermbg=233
   hi Comment         ctermfg=59
   hi CursorLine                  ctermbg=234   cterm=none
   hi CursorColumn                ctermbg=234
   hi LineNr          ctermfg=250 ctermbg=234
   hi NonText         ctermfg=250 ctermbg=234
end
