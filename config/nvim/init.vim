" Set encoding early
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

function! s:applyConfig()
    call s:basicSettings()
    call s:styleSettings()
    call s:indentSettings()
    call s:filetypeSettings()

    call s:basicMaps()
    call s:mapEscape()
    call s:filetypeMaps()

    call plug#begin()
        call s:plugins()
    call plug#end()

    call s:postPlugins()
    call s:mapWindowNavigation()
endfunction

function! s:basicSettings()
    set updatetime=1000  " Speed up vim's swap sync & when plugins update (improved responsiveness)

    set ignorecase

    set splitright  " So that vertical splits start on the right

    set mouse=a
    set mousemodel=popup_setpos
    if has("unix") && system("uname") == "Darwin\n"
        set ttymouse=xterm2
    endif

    " Completion options
    "   * show menu for more than 1 option
    "   * show menu for only 1 option
    "   * show popup for selected item with more info
    "   * don't auto select an item
    "   * don't auto insert an item
    set completeopt=menu,menuone,noselect,noinsert
    set wildmode=longest,list,full   " better tab complete menu
    set wildignore=*.pyc,*.o,*.obj,*.bak,*.exe,__pycache__/  " tab complete ignores these!
    let g:netrw_list_hide= '^.DS_Store$,.*\.pyc$,.*\.o$,.*\.obj$,.*\.bak$,.*\.exe$,.*\.swp$,.*__pycache__/$'   " Files to ignore in Explorer
    let g:netrw_preview = 1  " Use a vertical split for previewing files from explorer

    " Persistent undo, across exits
    if has('persistent_undo')
        set undofile
    endif
endfunction

function! s:indentSettings()
    " Tab/indent amounts.
    set tabstop=4      " How much a <TAB> is worth (as an actual char in the buffer)
    set expandtab      " When pressing <TAB>, instead insert spaces
    set softtabstop=4  " How many spaces a <TAB> should instead be
    set shiftwidth=4   " How much to indent by with stuff like <<, >>, etc
    set nocindent

    autocmd FileType html setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType javascript,json setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
endfunction

function! s:filetypeSettings()
    autocmd BufRead *.java,*.c,*.h,*.cc setlocal
        \ formatoptions=ctroq cindent comments=sr:/**,mb:*,elx:*/,sr:/*,mb:*,elx:*/,://
endfunction

function! s:styleSettings()
    set ruler          " Shows line,column # at bottom
    set laststatus=2   " Always whow the statusline
    set showcmd        " Display incomplete command
    set showmode

    set nohls
    set showmatch

    set whichwrap+=,h,l   " Wrap arrows
    set backspace=indent,eol,start  " Wrap backspace

    " Color Syntax highlighting
    syntax on
    if has('termguicolors')
        set termguicolors  " True Color support
    endif
    filetype off
    filetype plugin indent on

    " Show trailing whitespace.
    match ColorColumn /\s\+$/

    set nofoldenable    " Disable folding

    set formatoptions=tcql
endfunction

function! s:mapEscape()
    " Use <C-c> as <Esc> in normal mode, mainly so it doesn't complain that that's
    " not how you exit vim, so I can use it in all modes the same
    nnoremap <C-c> <Esc>

    " Also use <Tab> as <Esc>
    nnoremap <Tab> <Esc>
    vnoremap <Tab> <Esc>gV
    onoremap <Tab> <Esc>
    "cnoremap <Tab> <C-C><Esc>
    inoremap <Tab> <Esc>`^

    " Map <esc> to escape from terminal mode
    tnoremap <Esc> <C-\><C-n>
    tnoremap <C-\><Esc> <Esc>

    " Unbind <Esc> in a few modes, to force myself to change
    "nnoremap <Esc> <Nop>
    "vnoremap <Esc> <Nop>
    "inoremap <Esc> <Nop>

    " Map <esc> to escape from terminal mode
    if has('nvim')
        tnoremap <Esc> <C-\><C-n>
    endif
endfunction

function! s:basicMaps()
    let g:mapleader = ' '

    " delete without yanking
    nnoremap <leader>d "_d
    vnoremap <leader>d "_d

    " replace selected text with default register without yanking
    vnoremap <leader>p "_dP

    " substitute word under cursor
    nnoremap <leader>s :%s/\C\<<C-r><C-w>\>/
    vnoremap <leader>s :s/\C\<<C-r><C-w>\>/

    " substitute yanked word
    nnoremap <leader>sy :%s/\C\<<C-r>0\>/
    vnoremap <leader>sy :s/\C\<<C-r>0\>/

    " Search for last yanked text
    nnoremap <silent> <nowait> <Leader>* /\C\<<C-r>0\><CR>
    nnoremap <Leader><Leader>* :vimgrep /\C\<<C-r><C-w>\>/ **

    nnoremap <leader>h :call SwapSplits('h')<CR>
    nnoremap <leader>j :call SwapSplits('j')<CR>
    nnoremap <leader>k :call SwapSplits('k')<CR>
    nnoremap <leader>l :call SwapSplits('l')<CR>

    " Quick explore
    nnoremap - :Explore<CR>

    " Location list navigation
    nnoremap <F3> :lprev<CR>
    nnoremap <F4> :lnext<CR>

    " Error list navigation
    nnoremap <F5> :cprev<CR>
    nnoremap <F6> :cnext<CR>

    " Search highlighting
    set nohlsearch
    nnoremap <F2> :set hlsearch<CR>*``

    " Insert date
    noremap <silent> <Leader>id "=strftime('%Y-%m-%d')<CR>p
    command! InsertDate :normal <Leader>id<CR>
endfunction

function! s:filetypeMaps()
    autocmd FileType go noremap gsd <Plug>(go-def-split)
    autocmd FileType go noremap gvd <Plug>(go-def-vertical)
endfunction

" Map <alt>+{h,j,k,l} to move splits in most modes
function! s:mapWindowNavigation()
    for [l:motion, l:dir] in items({'j': 'Down', 'h': 'Left', 'l': 'Right', 'k': 'Up'})
        for l:mode in ['v', 'i', 't', 'o', 'n']
            let l:from = has('nvim') ? '<M-'.l:motion.'>' : '<Esc>'.l:motion

            if has('nvim')
                let l:escape = match('oi', l:mode) != -1 ? '<Esc>' : ''
            else
                let l:escape = l:mode == 'n' ? '' : '<C-\><C-n>'
            endif

            "if exists('g:loaded_tmux_navigator') && g:loaded_tmux_navigator
            let l:to = (has('nvim') ? '<Cmd>' : ':').'TmuxNavigate'.l:dir.'<CR>'
            "else
            "    let l:to = '<C-w>'.l:motion
            "endif

            exe l:mode.'noremap <silent>' l:from l:escape.l:to
        endfor
    endfor
endfunction

function! s:postPlugins()
    " Regardless of colorscheme, let vim know we're using a dark background
    set background=dark
    colorscheme base16-tomorrow-night
endfunction

function! s:plugins()
    " Go development
    if has('nvim')
        Plug 'fatih/vim-go'
        let g:go_autodetect_gopath = 0 " Don't fuck with GOPATH
    endif

    " Git +/-/~ in gutter
    "Plug 'airblade/vim-gitgutter'
    Plug 'mhinz/vim-signify'

    " Git commands, like Gblame
    Plug 'tpope/vim-fugitive'

    Plug 'liuchengxu/vim-which-key', {'on': ['WhichKey', 'WhichKey!']}
    nnoremap <silent> <Leader> :WhichKey '<Leader>'<CR>
    set timeoutlen=500

    Plug 'mbbill/undotree'
    nnoremap <Leader>u <Cmd>UndotreeToggle<CR>

    Plug 'vim-scripts/matchit.zip'

    Plug 'tpope/vim-vinegar'

    "Plug 'Valloric/YouCompleteMe'

    " Disabled: slow startup
    "Plug 'majutsushi/tagbar'
    "nnoremap <F8> :TagbarToggle<CR>

    " Vim Unit Testing
    Plug 'junegunn/vader.vim'

    Plug 'editorconfig/editorconfig-vim'

    Plug 'benekastah/neomake'
    let g:neomake_python_enabled_makers = ['flake8', 'pyflakes']
    let g:neomake_javascript_enabled_makers = ['eslint']

    Plug 'sbdchd/neoformat'
    let g:neoformat_only_msg_on_error = 1
    let g:neoformat_enabled_python = ['black']
    let g:neoformat_enabled_javascript = ['prettier-eslint', 'prettier']

    " Autoformatting
    augroup heewa
      autocmd!
      autocmd BufWritePre ~/src/Heewa/**/*.py undojoin | Neoformat
      autocmd BufWritePre ~/src/Heewa/**/*.js,~/src/Heewa/**/*.jsx undojoin | Neoformat
      autocmd BufWritePost ~/src/Heewa/**/*.js,~/src/Heewa/**/*.jsx *.go,*.c,*.cpp,*.h,*.py,*.js,*.jsx Neomake
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
    Plug 'reedes/vim-colors-pencil'

    " Load local .lvimrc files from root up to current dir
    Plug 'embear/vim-localvimrc'
    let g:localvimrc_persistent = 1 " Remember permission for .lvimrc files across sessions

    " Split resizing
    Plug 'wellle/visual-split.vim'

    " Something about fixing some vim-in-tmux issue
    Plug 'tmux-plugins/vim-tmux-focus-events'

    " Tmux/Vim split navigation
    Plug 'https://github.com/heewa/vim-tmux-navigator.git', {'branch': 'add-no-wrap-option'}
    let g:tmux_navigator_no_mappings = 1
    let g:tmux_navigator_no_wrap = 1

    " Nice status line
    Plug 'vim-airline/vim-airline'
    let g:airline#extensions#tagbar#flags = 'f' " Full tag info
    Plug 'vim-airline/vim-airline-themes'
    let g:airline_theme='bubblegum'
    let g:airline_powerline_fonts = 1 " Use a patched powerline font for nice symbols
    if !exists('g:airline_symbols')
      let g:airline_symbols = {}
    endif
    let g:airline_symbols.linenr = '' " Skip unecessary decoration
    let g:airline_symbols.maxlinenr = '' " Skip unecessary decoration
    let g:airline#extensions#branch#displayed_head_limit = 10 " Truncate long branch names
    let g:airline#extensions#branch#format = 2 " Shorten branch paths
    let g:airline_mode_map = {
        \ '__' : '-',
        \ 'c'  : 'CMD',
        \ 'i'  : 'I',
        \ 'ic' : 'I:C',
        \ 'ix' : 'I:X',
        \ 'multi' : 'MULTI',
        \ 'n'  : 'N',
        \ 'ni' : 'N:I',
        \ 'no' : 'N:OP',
        \ 'R'  : 'REPLACE',
        \ 'Rv' : 'REPLACE:V',
        \ 's'  : 'SELECT',
        \ 'S'  : 'S:LINE',
        \ '' : 'S:BLOCK',
        \ 't'  : 'TERM',
        \ 'v'  : 'V',
        \ 'V'  : 'V:L',
        \ '' : 'V:B',
        \ }

    Plug 'heewa/vim-blist'

    " Load the icons plugin last, so it picks up other plugins to know what
    " settings to use
    Plug 'ryanoasis/vim-devicons'
endfunction

"
" Helpers and custom funcs
"

function! SwapSplits(dir)
    " Remeber current (source) buffer
    let srcBuf = winbufnr(0)

    " Move to dest window
    exe 'wincmd ' . a:dir

    " Remeber dest  window & buffer
    let dstBuf = winbufnr(0)

    " Open src buffer in dst window
    exe srcBuf . 'buf'

    " Move back to src window, and open dst buffer there
    exe 'wincmd p'
    exe dstBuf . 'buf'

    " Move back to dst window, so we end up in final location
    exe 'wincmd p'
endfunction

function! s:sourceIfExists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction

"
" After defining everything, run it all
"

call s:applyConfig()
