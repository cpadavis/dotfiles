" https://github.com/sontek/dotfiles/
" ==========================================================
" Dependencies - Libraries/Applications outside of vim
" ==========================================================

" ==========================================================
" Plugins included
" ==========================================================

" ==========================================================
" Shortcuts
" ==========================================================
set nocompatible              " Don't be compatible with vi
let mapleader=","             " change the leader to be a comma vs slash
:noremap ' ,                  " this way we can keep ,'s funcitonality
" :sunmap '                     " select mode
" Seriously, guys. It's not like :W is bound to anything anyway.
command! W :w

" bind jk to esc
imap jk <esc>
" also set it so you need to type jk quickly to get to esc
set ttimeout
set ttimeoutlen=100
set timeoutlen=500

fu! SplitScroll()
    :wincmd v
    :wincmd w
    execute "normal! \<C-d>"
    :set scrollbind
    :wincmd w
    :set scrollbind
endfu

" z= loads up alternatives for spelling but is awful to type
" so let's rebind it
nmap <leader>z z=

" also enable spelling highlighting. I know it breaks my 'syntax' for <leader>s
nmap <leader>sp :set spell!<CR>

nmap <leader>sb :call SplitScroll()<CR>

" set vsplit to double the size of your window
function! VSplit()
    let &columns = 2*&columns
    vsplit
endfunction
nmap <leader>sv :call VSplit()<CR>
function! HSplit(size)
    split
    resize hsize a:size
endfunction
nmap <leader>sh :call HSplit(15)<CR>

" resize back to defaults
nmap <leader>rs :set lines=60 columns=85<CR>
"<CR><C-w>l<C-f>:set scrollbind<CR>

" sudo write this
" cmap W! w !sudo tee % >/dev/null

" Run pep8
let g:pep8_map='<leader>8'

" Toggle the tasklist
" and add other notes
let g:tlTokenList = ["NOTE", "FIXME", "TODO", "XXX", "WARNING", "ERROR"]
map <leader>td <Plug>TaskList

" Make h and l go to beginning and end of line
map <leader>h ^
map <leader>l $

" Reload Vimrc
map <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" I have never actually used this in this manner...
" open/close the quickfix window
" nmap <leader>c :copen<CR>
" nmap <leader>cc :cclose<CR>

" for when we forget to use sudo to open/edit a file
" cmap w!! w !sudo tee % >/dev/null

" ctrl-jklm  changes to that split
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

se ww+=l
se ww+=h

" and lets make these all work in insert mode too ( <C-O> makes next cmd
"  happen as if in command mode )
imap <C-W> <C-O><C-W>


inoremap <C-e> <C-o>$
inoremap <C-a> <C-o>^
inoremap <C-k> <Esc>D<Esc>a
" Open NerdTree
map <leader>n :NERDTreeToggle<CR>


" Load the Gundo window
map <leader>g :GundoToggle<CR>

function! ESlac()
    " :e scp://cpd@ki-ls.slac.stanford.edu//afs/slac.stanford.edu/u/ki/cpd/a:name
    :let name = input("What File? ")
    :exe 'e scp://cpd@ki-ls.slac.stanford.edu/'. name
endfunction
map <Leader>sd :call ESlac()<CR>
" call with e.g. :call ESlac('makedonuts/analyze.py')
function! UpSlac()
    ":!scp %:p cpd@ki-ls.slac.stanford.edu:/afs/slac.stanford.edu/u/ki/cpd/{a:name}
    :let name = input("What Directory? ", "")
    :exe '!scp %:p cpd@ki-ls.slac.stanford.edu:' . name . '/%'
endfunction
" call with e.g. :call UpSlac() and enter 'makedonuts'
map <Leader>ss :call UpSlac()<CR>

" ==========================================================
" Pathogen - Allows us to organize our vim plugins
" ==========================================================
" Load pathogen with docs for all plugins
filetype off
" call pathogen#runtime_append_all_bundles()
filetype plugin indent on
call pathogen#infect()
call pathogen#helptags()

" ==========================================================
" Basic Settings
" ==========================================================
syntax on                     " syntax highlighing
" filetype on                   " try to detect filetypes
filetype plugin indent on     " enable loading indent file for filetype
set number                    " Display line numbers
set numberwidth=1             " using only 1 column (and 1 space) while possible
" set background=dark           " We are using dark background in vim
set title                     " show title in console title bar
set wildmenu                  " Menu completion in command mode on <Tab>
set wildmode=list             " <Tab> cycles between all matching choices.

" don't bell or blink
set noerrorbells
set vb t_vb=

" Ignore these files when completing
set wildignore+=*.o,*.obj,.git,*.pyc
set wildignore+=eggs/**
set wildignore+=*.egg-info/**


" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>

" Disable the colorcolumn when switching modes.  Make sure this is the
" first autocmd for the filetype here
"autocmd FileType * setlocal colorcolumn=0

""" Insert completion
" don't select first item, follow typing in autocomplete
set completeopt=menu,preview
set complete-=i
set pumheight=6             " Keep a small completion window

"""
" did you know <c-a> and <c-x> increment numbers?
" with octal, 0s in front of numbers indicate octal instead of base10. disable
" that!
set nrformats-=octal

""" Moving Around/Editing
set cursorline              " have a line indicate the cursor location
set ruler                   " show the cursor position all the time
set nostartofline           " Avoid moving cursor to BOL when jumping around
set virtualedit=block       " Let cursor move past the last char in <C-v> mode
set scrolloff=3             " Keep 3 context lines above and below the cursor
set sidescrolloff=5         " keep 5 context columns to right and left of cursor
set backspace=2             " Allow backspacing over autoindent, EOL, and BOL
set showmatch               " Briefly jump to a paren once it's balanced
" set nowrap                  " don't wrap text
set wrap
set linebreak               " don't wrap textin the middle of a word
set autoindent              " always set autoindenting on
" set smartindent             " use smart indent if there is no indent file
" set tabstop=4               " <tab> inserts 4 spaces
set shiftwidth=4            " but an indent level is 2 spaces wide.
set softtabstop=4           " <BS> over an autoindent deletes both spaces.
set expandtab               " Use spaces, not tabs, for autoindent/tab key.
set shiftround              " rounds indent to a multiple of shiftwidth
set matchpairs+=<:>         " show matching <> (html mainly) as well
set foldmethod=indent       " allow us to fold on indents
set foldlevel=99            " don't fold by default

" don't outdent hashes
" inoremap # #

" close preview window automatically when we move around
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

"""" Reading/Writing
set noautowrite             " Never write a file unless I request it.
set noautowriteall          " NEVER.
set noautoread              " Don't automatically re-read changed files.
set modeline                " Allow vim options to be embedded in files;
set modelines=5             " they must be within the first or last 5 lines.
set ffs=unix,dos,mac        " Try recognizing dos, unix, and mac line endings.

"""" Messages, Info, Status
set ls=2                    " allways show status line
set vb t_vb=                " Disable all bells.  I hate ringing/flashing.
set confirm                 " Y-N-C prompt if closing with unsaved changes.
set showcmd                 " Show incomplete normal mode commands as I type.
set report=0                " : commands always print changed line count.
set shortmess+=a            " Use [+]/[RO]/[w] for modified/readonly/written.
set ruler                   " Show some info, even without statuslines.
set laststatus=2            " Always show statusline, even if only 1 window.
set statusline=[%l,%v\ %P%M]\ %f\ %r%h%w\ (%{&ff})\ %{fugitive#statusline()}

" displays tabs with :set list & displays when a line runs off-screen
set listchars=tab:>-,trail:-,precedes:<,extends:>
set list

set display+=lastline
set autoread " reload file if changed

""" Searching and Patterns
set ignorecase              " Default to using case insensitive searches,
set smartcase               " unless uppercase letters are used in the regex.
set smarttab                " Handle tabs more intelligently
set hlsearch                " Highlight searches by default.
set incsearch               " Incrementally search while typing a /regex

"""" Display
syntax enable
set mouse=a
if has("gui_running")
    colorscheme solarized
    set background=light
    set lines=60 columns=85
    set cursorline
    if has("gui_macvim")
        """ Full screen options
        set fuoptions=maxvert,maxhorz,background:Normal
        set colorcolumn=80
        "elseif os == 'Linux'
        set guifont=Menlo:h12.00
    else
        set guifont=DejaVu\ Sans\ Mono\ 10.00
        " Remove menu bar
        set guioptions-=m
        " Remove toolbar
        set guioptions-=T

    endif
else
    set t_Co=256
    set term=xterm-256color
    " se t_co=256
    " let g:solarized_termcolors=256
    colorscheme solarized "default
    set background=light
    "set nocursorline
    " set colorcolumn=80
    set cursorline
    "set lines=60 columns=85
endif
set encoding=utf-8
set termencoding=utf-8

" commands for changing the colors around
function! SwitchLucius()
    if g:colors_name == 'lucius'
        if g:lucius_style == 'dark'
            LuciusLight
        elseif g:lucius_style == 'light'
            LuciusDark
        endif
    elseif g:colors_name == 'solarized'
        let &background = ( &background == "dark"? "light" : "dark" )
    endif
endfunction
function! ChangeColorScheme()
    if g:colors_name == 'solarized'
        colorscheme lucius
        LuciusLight
    elseif g:colors_name == 'lucius'
        colorscheme solarized
        set background=light
        "call togglebg#map("<F5>")
    endif
endfunction
map <F5> :call SwitchLucius()<CR>
nnoremap <leader>cS :call SwitchLucius()<CR>
nnoremap <leader>cs :call ChangeColorScheme()<CR>

" Paste from clipboard
map <leader>p "+p

" Quit window on <leader>q
" Actually, no. leader q closes an active split screen
" nnoremap <leader>q :q<CR>
nnoremap <leader>q :bd<CR>
"<c-w>q

" hide matches on <leader>space
nnoremap <leader><space> :nohlsearch<cr>

" Remove trailing whitespace
function! RemoveWS()
    let l:save_reg = @/
    %s/\s\+$//e
    let @/ = l:save_reg
endfunction
nnoremap <leader>S :call RemoveWS()<CR>

" Select the item in the list with enter
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" rope. NOTE: if installing to new computer, go to ropevim directory and
" python setup.py install it!
" nmap <leader>j :RopeGotoDefinition<CR>
" one day I will get ropevim installed!

" tagbar
" nmap <leader>l :Tagbar<CR>
" this one is also broken on mac

" vimwiki
let vimwiki_nested_syntaxes = {'python': 'python', 'c': 'c', 'tex': 'tex', 'sql': 'sql'}
let wiki = {}
let wiki.path = '~/Dropbox/vimwiki/'
let wiki.nested_syntaxes = vimwiki_nested_syntaxes
let wiki.syntax = 'default'
"'markdown'
"let wiki.ext = '.wiki'

" cluster-z wiki
let wiki_clusterz = {}
let wiki_clusterz.path = '$CLUSTERZ_DIR/vimwiki/'
let wiki_clusterz.nested_syntaxes = vimwiki_nested_syntaxes
let wiki_clusterz.syntax = 'default'

" protected-ish
let wiki_personal = {}
let wiki_personal.path = '~/Documents/vimwiki/'
let wiki_personal.nested_syntaxes = vimwiki_nested_syntaxes
let wiki_personal.syntax = 'default'

let g:vimwiki_list = [wiki, wiki_clusterz, wiki_personal]

" vimwiki keybindings

" nmap <Leader>wf <Plug>VimwikiFollowLink
" nmap <Leader>we <Plug>VimwikiSplitLink
" nmap <Leader>wv <Plug>VimwikiVSplitLink
nmap <Leader>wf <Plug>VimwikiTabnewLink

" snipmate
imap <leader><tab> <Plug>snipmateShow

" set syntastic to passive
let g:syntastic_mode_map = { 'mode': 'passive'}
" let's use flake8. we can switch to pylint with leader sl
let g:syntastic_python_checkers=['pep8']
" show warnings and errors
let g:syntastic_quiet_messages= {'level': 'warnings'}
" run syntastic tests
nmap <Leader>sc :SyntasticCheck<CR>
nmap <Leader>se :Errors<CR>
nmap <Leader>st :SyntasticToggleMode<CR>
nmap <Leader>si :SyntasticInfo<CR>
" control whether you want to see both warnings and errors or only errors
nmap <Leader>sl :let g:syntastic_python_checkers=['pylint']<CR> :SyntasticCheck<CR>
nmap <Leader>sf :let g:syntastic_python_checkers=['flake8']<CR> :SyntasticCheck<CR>
nmap <Leader>s8 :let g:syntastic_python_checkers=['pep8']<CR> :SyntasticCheck<CR>


" ==========================================================
" Calendar stuff
" ==========================================================
let g:calendar_google_calendar = 1
let g:calendar_google_task = 0
nmap <leader>ca :tab Calendar<CR>


" ==========================================================
" vim airplane
" ==========================================================

" ==========================================================
" CtrlP
" http://kien.github.io/ctrlp.vim/
" ==========================================================
set runtimepath^=~/.vim/bundle/ctrlp.vim
" f for find
nmap <leader>f :CtrlPMixed<CR>

" ==========================================================
" Remap help to a new tab instead of horizontal split
" ==========================================================
cnoreabbrev <expr> h getcmdtype() == ":" && getcmdline() == 'h' ? 'tab help' : 'h'

" ==========================================================
" Javascript
" ==========================================================
au BufRead *.js setl makeprg=jslint\ %

" Use tab to scroll through autocomplete menus
" autocmd VimEnter * imap <expr> <Tab> pumvisible() ? "<C-N>" : "<Tab>"
" autocmd VimEnter * imap <expr> <S-Tab> pumvisible() ? "<C-P>" : "<S-Tab>"

let g:acp_completeoptPreview=1

" ===========================================================
" FileType specific changes
" ============================================================
" Mako/HTML
autocmd BufNewFile,BufRead *.mako,*.mak,*.jinja2 setlocal ft=html
autocmd FileType html,xhtml,xml,css setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2

" Python
" au BufRead *.py compiler nose
" au FileType python setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4 smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with
" au BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

" run Flake8 check every time you write to a Python file
" autocmd BufWritePost *.py call Flake8()

" Add the virtualenv's site-packages to vim path
" py << EOF
" import os.path
" import sys
" import vim
" if 'VIRTUAL_ENV' in os.environ:
"     project_base_dir = os.environ['VIRTUAL_ENV']
"     sys.path.insert(0, project_base_dir)
"     activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
"     execfile(activate_this, dict(__file__=activate_this))
" EOF
" 
" " Load up virtualenv's vimrc if it exists
" if filereadable($VIRTUAL_ENV . '/.vimrc')
"     source $VIRTUAL_ENV/.vimrc
" endif
