" markdown filetype file

if exists("did\_load\_filetypes")
   finish
endif

au BufRead,BufNewFile nginx.conf set ft=nginx

augroup markdown
   au! BufRead,BufNewFile hostd.log   setfiletype hostd
   au! BufRead,BufNewFile hostd-*.log setfiletype hostd
   au! BufRead,BufNewFile vmware.log setfiletype hostd
   au! BufRead,BufNewFile vmware-*.log setfiletype hostd
   au! BufRead,BufNewFile vix-*.log setfiletype hostd
   au! BufRead,BufNewFile README.md       setfiletype mkd
   au! BufRead,BufNewFile *.mkd       setfiletype mkd
   au! BufRead,BufNewFile *.mkd.txt   setfiletype mkd
   au! BufRead,BufNewFile ProgressUpdates/*.txt   setfiletype mkd
augroup END

