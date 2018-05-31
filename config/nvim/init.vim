set laststatus=2   " Always whow the statusline
set nohls

" Tab/indent amounts.
set tabstop=4      " How much a <TAB> is worth (as an actual char in the buffer)
set expandtab      " When pressing <TAB>, instead insert spaces
set softtabstop=4  " How many spaces a <TAB> should instead be
set shiftwidth=4   " How much to indent by with stuff like <<, >>, etc

" Indent treatment.
" Don't use smartindent or cindent, they interfere with plugin indent.`
"set smartindent   " Don't use smartindent, it's bad for non-c languages. Instead, let it use whatever the filetype specifies.
"set cindent        " Maybe use this? Not quite sure yet. Python files don't do well automatically.
filetype plugin indent on

" Indenting for specific file types.
autocmd FileType html setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType javascript setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType python setlocal expandtab shiftwidth=4 softtabstop=4

set showmatch
set ruler          " Shows line,column # at bottom
set showcmd        " Display incomplete command
set whichwrap+=,h,l   " Cursor,backspace keys wrap too
set showmode
set wildmode=longest,list,full   " better tab complete menu
set wildignore=*.pyc,*.o,*.obj,*.bak,*.exe  " tab complete ignores these!
let g:netrw_list_hide= '^.DS_Store$,.*\.pyc$,.*\.o$,.*\.obj$,.*\.bak$,.*\.exe$,.*\.swp$'   " Files to ignore in Explorer
set ignorecase

" Color Syntax highlighting
syntax on
set termguicolors  " True Color support
silent! colorscheme heewa " Only load colorscheme if it exists (ignore errors)
"silent! colorscheme fairyfloss " Only load colorscheme if it exists (ignore errors)

filetype on           " try to detect syntax from filetype
au BufNewFile,BufRead *.handlebars set filetype=htmldjango
set nofoldenable    " disable folding

" Quick explore
nmap - :Explore<CR>

" Go settings
autocmd FileType go map gs <Plug>(go-def-split)
autocmd FileType go map gv <Plug>(go-def-vertical)

" Show trailing whitespace.
match ErrorMsg '\s\+$'

" Building and errors
nmap <F5> :cprev<CR>
nmap <F6> :cnext<CR>

" Search highlighting (off by default)
map <F2> :set hlsearch!<CR> 
imap <F2> <ESC>:set hlsearch!<CR>a 

" Grep for word under cursor (ignoring binary files).
nnoremap <silent> <F3> :grep -I <cword> * <CR> <CR>

" use gi + char to insert char and remain in command mode
map gi i<space><esc>r

" Syntax highlighting and some other stuff for Code files.
autocmd BufRead * set formatoptions=tcql nocindent comments&
autocmd BufRead *.java,*.c,*.h,*.cc set formatoptions=ctroq cindent comments=sr:/**,mb:*,elx:*/,sr:/*,mb:*,elx:*/,://

" Filename as title in screen
autocmd BufEnter * let &titlestring = expand("%:t") 
"let &titlestring = expand("%:t")
if &term == "screen"
  set t_ts=k
  set t_fs=\
endif
if &term == "screen" || &term == "xterm"
  set title
  "set notitle
  set titleold=""
endif

" For cscope
set splitright  " So that vertical splits start on the right

" Toggle highlighing of word under cursor without searching, though it's now
" the search term, so you can use 'n' and 'N' to jump to matches.
nnoremap <F10> :set invhls<CR>:let @/="<C-r><C-w>"<CR>/<BS>

set mouse=a  " MOUSE SUPPORT, FUCK YEA!

if has('nvim')

    call plug#begin()

    " For opening files more easily
    Plug 'ctrlpvim/ctrlp.vim'

    " Switching between .c & .h with 'A'
    Plug 'vim-scripts/a.vim'

    " Go development
    Plug 'fatih/vim-go'

    " Nice status line
    Plug 'vim-airline/vim-airline'

    " Git +/-/~ in gutter
    Plug 'airblade/vim-gitgutter'

    " Git commands, like Gblame
    Plug 'tpope/vim-fugitive'

    " Syntax Checkers & Autocompleters
    "Plug 'Valloric/YouCompleteMe'
    Plug 'benekastah/neomake'
    Plug 'majutsushi/tagbar'
    "Plug 'scrooloose/syntastic'
    "Plug 'myint/syntastic-extras'
    Plug 'editorconfig/editorconfig-vim'

    Plug 'ternjs/tern_for_vim'

    " Elixir
    Plug 'elixir-editors/vim-elixir'
    Plug 'slashmili/alchemist.vim'

    Plug 'mxw/vim-jsx'
    Plug 'pangloss/vim-javascript'
    Plug 'othree/javascript-libraries-syntax.vim'
    Plug 'othree/html5-syntax.vim'
    Plug 'digitaltoad/vim-pug'
    Plug 'kchmck/vim-coffee-script'
    "Plug 'kien/rainbow_parentheses.vim'

    " Colors, yay!
    Plug 'tssm/fairyfloss.vim'
    Plug 'romainl/flattened'
    Plug 'morhetz/gruvbox'
    Plug 'flazz/vim-colorschemes'

    " Load local .lvimrc files from root up to current dir
    Plug 'embear/vim-localvimrc'

    " Remember permission for .lvimrc files across sessions if answered with
    " capital Y/N/A
    let g:localvimrc_persistent = 1


    call plug#end()

    " Use flake8 & pep8 for python checking, mainly cuz pylint is annoying
    let g:neomake_python_enabled_makers = ['flake8', 'pep8']

    " Use only eslint for js, cuz jshint doesn't work well for jsx (unless
    " you can figure out how to only target jsx files)
    let g:neomake_javascript_enabled_makers = ['eslint']

    " YouCompleteMe symbol jumping for C files
    autocmd FileType c nnoremap <buffer> <silent> <C-]> :YcmCompleter GoTo<cr>
    " YouCompelteMe - don't ask for confirmation to load python conf file (.ycm_extra_conf.py)
    let g:ycm_confirm_extra_conf = 0
    let g:ycm_autoclose_preview_window_after_insertion = 1

    " Persistent undo, across exits. Only do this in neovim cuz it has better
    " default dir for this.
    if has('persistent_undo')
        " For files in my source repo, keep undo files in a shared location
        set undofile
    endif

    nmap <F8> :TagbarToggle<CR>

    " Don't fuck with GOPATH
    let g:go_autodetect_gopath = 0

    " Run Neomake on save
    autocmd BufWritePost *.go,*.c,*.cpp,*.h,*.py,*.js,*.jsx Neomake

    " Use a patched powerline font for nice symbols
    let g:airline_powerline_fonts = 1

    " Map <esc> to escape from terminal mode
    tnoremap <Esc> <C-\><C-n>

    " Map <alt>+{h,j,k,l} to move splits whether in cmd or terminal mode
    tnoremap <A-h> <C-\><C-n><C-w>h
    tnoremap <A-j> <C-\><C-n><C-w>j
    tnoremap <A-k> <C-\><C-n><C-w>k
    tnoremap <A-l> <C-\><C-n><C-w>l
    nnoremap <A-h> <C-w>h
    nnoremap <A-j> <C-w>j
    nnoremap <A-k> <C-w>k
    nnoremap <A-l> <C-w>l

else " regular old vim

    set nocompatible   " Disable vi-compatibility (needed for fancy plugins)
    set autoindent
    set backspace=2    " Backspace in insert mode
    set wildmenu                     " better tab complete menu

    " Pathogen, for easier plugins.  https://github.com/tpope/vim-pathogen
    " NOTE: need to load these first, before indent stuff, espcially the
    " filetype plugin indent on # line
    " Options for pathogen ~/.bundle plugins:
    "let g:jsx_pragma_required = 0
    " Load Pathogen plugins:
    if has('pathogen')
        execute pathogen#infect()
    endif

    " Jump to first line of pylint error.
    function! FirstPylintError()
        echo 'running pylint...'

        " Run pylint with parsable output, grep for just relevant lines, and
        " get 1st.
        let all_errors = split(system(
            \ 'pylint -E --disable=E1103,E1101 ' .
            \ '--msg-template="{path}:{line}:{msg_id} {msg}" ' .
            \ '--output-format=text ' . expand('%')), '\n')
        call filter(all_errors, 'v:val =~ ''\.py:[0-9]\+''')

        if len(all_errors)
            " Set quickfix buffer for these errors.
            cexpr all_errors

            " Go to line of error.
            "exe matchstr(all_errors[0], '^[0-9]\+', 0, 0)
            exe split(all_errors[0], ':')[1]

            " Also show the error itself, but this time as a msg, so it stays in
            " message history.
            redraw
            echomsg split(all_errors[0], ':')[2] . ' (' . len(all_errors) . ' errors total)'
        else
            redraw
            echo len(all_errors) . ' errors'
        endif
    endfunction
    nmap <silent> <F4> :call FirstPylintError()<CR>

    " Turn of syntastic checking a file on write (slows down writes).
    "let g:syntastic_check_on_wq=0
    " Turn off active syntastic checking by default.
    let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [], 'passive_filetypes': []}
    " Python checking.
    let g:syntastic_python_checkers = ['pylint']
    let g:syntastic_python_pylint_args = '-f parseable -r n -i y -E -d E1103'
    " Symbols for the gutter on errors/warnings.
    let g:syntastic_error_symbol = 'XX'
    let g:syntastic_style_error_symbol = 'sx'
    highlight SyntasticErrorSign ctermfg=white ctermbg=red
    let g:syntastic_warning_symbol = 'ww'
    let g:syntastic_style_warning_symbol = 'sw'
    " Only do things on errors.
    "let g:syntastic_quiet_warnings=1

    " Just, fuck, fuck Pathogen, fuck plugins, fuck everything.
    filetype off
    syntax on
    filetype plugin indent on

endif

" Project-specific settings
autocmd BufNewFile,BufRead ~/src/Polaroid/**/*.js,~/src/Polaroid/**/*.jsx setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
