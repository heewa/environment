" Vim syntax file for Hostd Logs
" Maintainer: Heewa Barfchin <heewa@heewa.net>

if exists("b:current_syntax")
  finish
endif

" Log Entry Header
syn keyword logLevel verbose info contained logEntryHeader
syn keyword logLevel_warning warning contained logEntryHeader
syn keyword logLevel_error error contained logEntryHeader
syn region logEntryHeader start='\[' end='\]' transparent contains=numHex,logLevel,logLevel_error,logLevel_warning

" Foundry and Friends
syn match vixError 'VIX_E_[A-Z_]\+'
syn match vixCommand 'VIX_COMMAND_[A-Z_]\+'
syn match vixFunction 'Vix[A-Z_]\+[A-Za-z_]\+'
syn match vixFunction 'Foundry[A-Z_]\+[A-Za-z_]\+'
syn match vixFunction 'VMXI[A-Z_]\+[A-Za-z_]\+'
syn match vixFunction 'VMHS[A-Z_]\+[A-Za-z_]\+'
syn match vixFunction 'VMAutomation[A-Z_]\+[A-Za-z_]\+'

" VMX
syn keyword msgPost Msg_Post
syn match msgPostErr '\[msg\.[A-Za-z_\.]\+\]'

" Misc
syn match miscWarning '[Ee][Rr][Rr][Oo][Rr]'
syn match miscError 'ASSERT'
syn match miscError '[Aa]ssert'
syn match miscError 'Backtrace\: *$'

let b:current_syntax = "hostd"

hi def link logLevel          Type
hi def link vixFunction       Statement
hi def link vixCommand        Constant
hi def link vixError          Error
hi def link logLevel_error    Error
hi def link miscError         Error
hi def link miscWarning       Warning
hi def link logLevel_warning  Warning
hi def link vix               Constant
hi def link msgPost           Warning
hi def link msgPostErr        Type

hi Warning term=bold ctermfg=Red guifg=Red

