if has("multi_byte")
    if &termencoding == ""
        if $LANG =~ '\.UTF-8'
            set termencoding=utf-8
        else
            let &termencoding = &encoding
        endif
    endif
    set encoding=utf-8
endif

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
if has('nvim')
    nnoremap <M-h> <C-w>h
    nnoremap <M-j> <C-w>j
    nnoremap <M-k> <C-w>k
    nnoremap <M-l> <C-w>l
    tnoremap <M-h> <C-\><C-n><C-w>h
    tnoremap <M-j> <C-\><C-n><C-w>j
    tnoremap <M-k> <C-\><C-n><C-w>k
    tnoremap <M-l> <C-\><C-n><C-w>l
else
    nnoremap <Esc>h <C-w>h
    nnoremap <Esc>j <C-w>j
    nnoremap <Esc>k <C-w>k
    nnoremap <Esc>l <C-w>l
endif

" delete without yanking
nnoremap <leader>d "_d
vnoremap <leader>d "_d

" replace selected text with default register without yanking
vnoremap <leader>p "_dP

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
autocmd FileType javascript,json setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4

set showmatch
set ruler          " Shows line,column # at bottom
set showcmd        " Display incomplete command
set whichwrap+=,h,l   " Wrap arrows
set backspace=indent,eol,start  " Wrap backspace
set showmode
set wildmode=longest,list,full   " better tab complete menu
set wildignore=*.pyc,*.o,*.obj,*.bak,*.exe,__pycache__/  " tab complete ignores these!
let g:netrw_list_hide= '^.DS_Store$,.*\.pyc$,.*\.o$,.*\.obj$,.*\.bak$,.*\.exe$,.*\.swp$,.*__pycache__/$'   " Files to ignore in Explorer
let g:netrw_preview = 1  " Use a vertical split for previewing files from explorer
set ignorecase

" Color Syntax highlighting
syntax on
if has('termguicolors')
    set termguicolors  " True Color support
endif

filetype on           " try to detect syntax from filetype
set nofoldenable    " disable folding

" Quick explore
nnoremap - :Explore<CR>

" Search for last yanked text
nnoremap <silent> <nowait> <Leader>* /\<<C-r>0\><CR>
nnoremap <Leader><Leader>* :vimgrep /\<<C-r><C-w>\>/ **

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

    " Go development
    if has('nvim')
        Plug 'fatih/vim-go'
        let g:go_autodetect_gopath = 0 " Don't fuck with GOPATH
    endif

    " Git +/-/~ in gutter
    Plug 'airblade/vim-gitgutter'

    " Git commands, like Gblame
    Plug 'tpope/vim-fugitive'

    "Plug 'Valloric/YouCompleteMe'

    Plug 'majutsushi/tagbar'
    nnoremap <F8> :TagbarToggle<CR>

    Plug 'editorconfig/editorconfig-vim'

    Plug 'benekastah/neomake'
    let g:neomake_python_enabled_makers = ['flake8']
    let g:neomake_javascript_enabled_makers = ['eslint']
    autocmd BufWritePost *.go,*.c,*.cpp,*.h,*.py,*.js,*.jsx Neomake

    Plug 'sbdchd/neoformat'
    let g:neoformat_only_msg_on_error = 1
    let g:neoformat_enabled_python = ['black']
    let g:neoformat_enabled_javascript = ['prettier-eslint', 'prettier']

    " Autoformatting
    augroup fmtheewa
      autocmd!
      autocmd BufWritePre ~/src/Heewa/**/*.py undojoin | Neoformat
      autocmd BufWritePre ~/src/Heewa/**/*.js,~/src/Heewa/**/*.jsx undojoin | Neoformat
    augroup END

    augroup twine
      autocmd!

      autocmd BufNewFile,BufRead ~/src/Twine/**/*.py let b:neomake_python_enabled_makers = ['pylint']
      autocmd BufNewFile,BufRead ~/src/Twine/**/*.py let g:neoformat_enabled_python = ['black']
      autocmd BufWritePre ~/src/Twine/**/*.py undojoin | Neoformat

      autocmd BufNewFile,BufRead ~/src/Twine/**/*.js,~/src/Twine/**/*.jsx let b:neomake_javascript_enabled_makers = ['eslint']
      autocmd BufNewFile,BufRead ~/src/Twine/**/*.js,~/src/Twine/**/*.jsx let g:neoformat_enabled_python = ['prettier']
      autocmd BufWritePre ~/src/Twine/**/*.js,~/src/Twine/**/*.jsx undojoin | Neoformat
    augroup END

    " NOTE: disabling cuz can't make work at Twine
    "Plug 'ternjs/tern_for_vim'

    " Javascript
    Plug 'maxmellon/vim-jsx-pretty'
    Plug 'benjie/local-npm-bin.vim'
    Plug 'pangloss/vim-javascript'
    Plug 'othree/javascript-libraries-syntax.vim'
    Plug 'othree/html5-syntax.vim'
    Plug 'digitaltoad/vim-pug'
    Plug 'kchmck/vim-coffee-script'
    Plug 'tpope/vim-surround'

    " Colors, yay!
    Plug 'tssm/fairyfloss.vim'
    Plug 'romainl/flattened'
    Plug 'morhetz/gruvbox'
    Plug 'icymind/NeoSolarized'
    Plug 'flazz/vim-colorschemes'
    Plug 'chriskempson/base16-vim'

    " Load local .lvimrc files from root up to current dir
    Plug 'embear/vim-localvimrc'
    let g:localvimrc_persistent = 1 " Remember permission for .lvimrc files across sessions

    " Split resizing
    Plug 'wellle/visual-split.vim'

    " Something about fixing some vim-in-tmux issue
    Plug 'tmux-plugins/vim-tmux-focus-events'

    " Tmux/Vim split navigation
    Plug 'christoomey/vim-tmux-navigator'
    let g:tmux_navigator_no_mappings = 1
    if has('nvim')
        nnoremap <silent> <M-h> :TmuxNavigateLeft<cr>
        nnoremap <silent> <M-j> :TmuxNavigateDown<cr>
        nnoremap <silent> <M-k> :TmuxNavigateUp<cr>
        nnoremap <silent> <M-l> :TmuxNavigateRight<cr>
    else
        nnoremap <silent> <Esc>h :TmuxNavigateLeft<cr>
        nnoremap <silent> <Esc>j :TmuxNavigateDown<cr>
        nnoremap <silent> <Esc>k :TmuxNavigateUp<cr>
        nnoremap <silent> <Esc>l :TmuxNavigateRight<cr>
    endif

    " Nice status line
    Plug 'vim-airline/vim-airline'
    let g:airline#extensions#tagbar#flags = 'f' " Full tag info
    Plug 'vim-airline/vim-airline-themes'
    let g:airline_theme='bubblegum'
    let g:airline_powerline_fonts = 1 " Use a patched powerline font for nice symbols

    " Load the icons plugin last, so it picks up other plugins to know what
    " settings to use
    Plug 'ryanoasis/vim-devicons'
call plug#end()

" Some options need to be placed after plug#end() so the plugins are loaded
" when they're called

"colorscheme heewa
let g:gruvbox_contrast_dark = 'hard' | colorscheme gruvbox
"colorscheme base16-chalk
"colorscheme fairyfloss
"colorscheme solarized
"colorscheme flattened_dark
"let g:neosolarized_contrast = 'high' | let g:neosolarized_visibility = 'high' | colorscheme NeoSolarized
