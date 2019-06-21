" Use <C-c> as <Esc> in normal mode, mainly so it doesn't complain that that's
" not how you exit vim, so I can use it in all modes the same
nnoremap <C-c> <Esc>

" Also use <Tab> as <Esc>
nnoremap <Tab> <Esc>
vnoremap <Tab> <Esc>gV
onoremap <Tab> <Esc>
"cnoremap <Tab> <C-C><Esc>
inoremap <Tab> <Esc>`^
inoremap <Leader><Tab> <Tab>

" Unbind <Esc> in a few modes, to force myself to change
"nnoremap <Esc> <Nop>
vnoremap <Esc> <Nop>
inoremap <Esc> <Nop>

" Map <esc> to escape from terminal mode
if has('nvim')
    tnoremap <Esc> <C-\><C-n>
endif

" Map <alt>+{h,j,k,l} to move splits whether in cmd or terminal mode
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
if has('nvim')
    tnoremap <A-h> <C-\><C-n><C-w>h
    tnoremap <A-j> <C-\><C-n><C-w>j
    tnoremap <A-k> <C-\><C-n><C-w>k
    tnoremap <A-l> <C-\><C-n><C-w>l
endif

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
set wildignore=*.pyc,*.o,*.obj,*.bak,*.exe,__pycache__/  " tab complete ignores these!
let g:netrw_list_hide= '^.DS_Store$,.*\.pyc$,.*\.o$,.*\.obj$,.*\.bak$,.*\.exe$,.*\.swp$,.*__pycache__/$'   " Files to ignore in Explorer
let g:netrw_preview = 1  " Use a vertical split for previewing files from explorer
set ignorecase

" Color Syntax highlighting
syntax on
if has('nvim')
    set termguicolors  " True Color support
endif
silent! colorscheme heewa " Only load colorscheme if it exists (ignore errors)
"silent! colorscheme fairyfloss " Only load colorscheme if it exists (ignore errors)

filetype on           " try to detect syntax from filetype
set nofoldenable    " disable folding

" Quick explore
nnoremap - :Explore<CR>

" Search for last yanked text
nnoremap <silent> <nowait> <Leader>* /\<<C-r>0\><CR>

" Go settings
autocmd FileType go noremap gs <Plug>(go-def-split)
autocmd FileType go noremap gv <Plug>(go-def-vertical)

" Show trailing whitespace.
match ColorColumn /\s\+$/

" Building and errors
nnoremap <F5> :cprev<CR>
nnoremap <F6> :cnext<CR>

" Search highlighting (off by default)
nnoremap <F2> :set hlsearch!<CR>

" Syntax highlighting and some other stuff for Code files.
autocmd BufRead * set formatoptions=tcql nocindent comments&
autocmd BufRead *.java,*.c,*.h,*.cc set formatoptions=ctroq cindent comments=sr:/**,mb:*,elx:*/,sr:/*,mb:*,elx:*/,://

" For cscope
set splitright  " So that vertical splits start on the right

set mouse=a  " MOUSE SUPPORT, FUCK YEA!

if has('nvim')

    " Persistent undo, across exits. Only do this in neovim cuz it has better
    " default dir for this.
    if has('persistent_undo')
        " For files in my source repo, keep undo files in a shared location
        set undofile
    endif

else " regular old vim

"    set nocompatible   " Disable vi-compatibility (needed for fancy plugins)
"    set autoindent
"    set backspace=2    " Backspace in insert mode
"    set wildmenu                     " better tab complete menu

endif

call plug#begin()

    " For opening files more easily
    Plug 'ctrlpvim/ctrlp.vim'

    " Fuzzy File Finder integration
    Plug '/usr/local/opt/fzf'

    " Switching between .c & .h with 'A'
    Plug 'vim-scripts/a.vim'

    " Go development
    Plug 'fatih/vim-go'

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

    " Formatting
    Plug 'sbdchd/neoformat'
    let g:neoformat_only_msg_on_error = 1

    " NOTE: disabling cuz can't make work at Twine
    "Plug 'ternjs/tern_for_vim'

    Plug 'maxmellon/vim-jsx-pretty'
    Plug 'benjie/local-npm-bin.vim'
    Plug 'pangloss/vim-javascript'
    Plug 'othree/javascript-libraries-syntax.vim'
    Plug 'othree/html5-syntax.vim'
    Plug 'digitaltoad/vim-pug'
    Plug 'kchmck/vim-coffee-script'
    Plug 'tpope/vim-surround'
    "Plug 'kien/rainbow_parentheses.vim'

    " Colors, yay!
    Plug 'tssm/fairyfloss.vim'
    Plug 'romainl/flattened'
    Plug 'morhetz/gruvbox'
    Plug 'flazz/vim-colorschemes'

    " Load local .lvimrc files from root up to current dir
    Plug 'embear/vim-localvimrc'

    " Split resizing
    Plug 'wellle/visual-split.vim'

    " Nice status line
    Plug 'vim-airline/vim-airline'
    let g:airline#extensions#tagbar#flags = 'f' " Full tag info
    Plug 'vim-airline/vim-airline-themes'
    let g:airline_theme='bubblegum'

    " Load the icons plugin last, so it picks up other plugins to know what
    " settings to use
    Plug 'ryanoasis/vim-devicons'

    " Remember permission for .lvimrc files across sessions if answered with
    " capital Y/N/A
    let g:localvimrc_persistent = 1

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

    nnoremap <F8> :TagbarToggle<CR>

    " Don't fuck with GOPATH
    let g:go_autodetect_gopath = 0

    " Run Neomake on save
    autocmd BufWritePost *.go,*.c,*.cpp,*.h,*.py,*.js,*.jsx Neomake

    " Use a patched powerline font for nice symbols
    let g:airline_powerline_fonts = 1

call plug#end()

augroup twine
  autocmd!

  autocmd BufNewFile,BufRead ~/src/Twine/**/*.py let b:neomake_python_enabled_makers = ['pylint']
  autocmd BufNewFile,BufRead ~/src/Twine/**/*.py let g:neoformat_enabled_python = ['black']
  autocmd BufWritePre ~/src/Twine/**/*.py undojoin | Neoformat

  autocmd BufNewFile,BufRead ~/src/Twine/**/*.js,~/src/Twine/**/*.jsx let b:neomake_javascript_enabled_makers = ['eslint']
  autocmd BufNewFile,BufRead ~/src/Twine/**/*.js,~/src/Twine/**/*.jsx let g:neoformat_enabled_python = ['prettier']
  autocmd BufWritePre ~/src/Twine/**/*.js,~/src/Twine/**/*.jsx undojoin | Neoformat
augroup END
