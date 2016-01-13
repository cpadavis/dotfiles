" ==========================================================
" Dependencies - Libraries/Applications outside of vim
" ==========================================================


" ==========================================================
" Shortcuts to windows that pop up on side
" ==========================================================
" <leader>td - Todo tasklist
" <leader>tb - Tagbar
" <leader>n - nerdtree
" <leader>g - gundo
" <leader>f - ctrlp
" <leader>cc - quickfix
" <leader>cl - location list
" <leader>C - Calendar
" K on word in command mode - help

" ==========================================================
" Plugins but not yet made submodules
" ==========================================================
" previewmarkdown
" swift.vim
" vim-javascript

" ==========================================================
" Plugins included
" ==========================================================
" Tagbar
" ack.vim
" calendar.vim
" ctrlp.vim
" fugitive
" gundo
" jedi-vim
" markdown
" misc
" nerdtree
" netrw.vim
" promptline.vim
" syntastic
" tasklist
" tlib
" tmuxline.vim
" vim-addon-mw-utils
" vim-airline
" vim-bbye
" vim-colors-solarized
" vim-commentary
" vim-obsession
" vimtex
" vimwiki


" ==========================================================
" Shortcuts
" ==========================================================
set nocompatible              " Don't be compatible with vi
let mapleader=","             " change the leader to be a comma vs slash
let maplocalleader=","             " change the leader to be a comma vs slash
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

" redraw on command
nmap <leader>lR :redraw!<CR>

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
nmap <leader>cc :copen<CR>
nmap <leader>cl :lopen<CR>
nmap <leader>cC :cclose<CR>
nmap <leader>cL :lclose<CR>
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

" function! ESlac()
"     " :e scp://cpd@ki-ls.slac.stanford.edu//afs/slac.stanford.edu/u/ki/cpd/a:name
"     :let name = input("What File? ")
"     :exe 'e scp://cpd@ki-ls.slac.stanford.edu/'. name
" endfunction
" map <Leader>sd :call ESlac()<CR>
" " call with e.g. :call ESlac('makedonuts/analyze.py')
" function! UpSlac()
"     ":!scp %:p cpd@ki-ls.slac.stanford.edu:/afs/slac.stanford.edu/u/ki/cpd/{a:name}
"     :let name = input("What Directory? ", "")
"     :exe '!scp %:p cpd@ki-ls.slac.stanford.edu:' . name . '/%'
" endfunction
" " call with e.g. :call UpSlac() and enter 'makedonuts'
" map <Leader>ss :call UpSlac()<CR>

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
set number norelativenumber                  " Display line numbers
" set number relativenumber                  " Display relative line numbers
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
" set noautoread              " Don't automatically re-read changed files.
set autoread " reload file if changed
set noshowmode              " don't show the mode, vim-airline will do that for us
set modeline                " Allow vim options to be embedded in files;
set modelines=5             " they must be within the first or last 5 lines.
set ffs=unix,dos,mac        " Try recognizing dos, unix, and mac line endings.

"""" Messages, Info, Status
set ls=2                    " allways show status line
set laststatus=2            " Always show statusline, even if only 1 window.
set vb t_vb=                " Disable all bells.  I hate ringing/flashing.
set confirm                 " Y-N-C prompt if closing with unsaved changes.
set showcmd                 " Show incomplete normal mode commands as I type.
set report=0                " : commands always print changed line count.
set shortmess+=a            " Use [+]/[RO]/[w] for modified/readonly/written.
set ruler                   " Show some info, even without statuslines.
" note to self: I have no idea what this does
" [line,vertical percent,modified] filename readonly,help,preview flags,
" OS, (how?!), fugitive status line
set statusline=[%l,%v\ %P%M]\ %f\ %r%h%w\ (%{&ff})\ %{fugitive#statusline()}

" displays tabs with :set list & displays when a line runs off-screen
set listchars=tab:>-,trail:-,precedes:<,extends:>
set list

set display+=lastline

""" Searching and Patterns
set ignorecase              " Default to using case insensitive searches,
set smartcase               " unless uppercase letters are used in the regex.
set smarttab                " Handle tabs more intelligently
set hlsearch                " Highlight searches by default.
set incsearch               " Incrementally search while typing a /regex

"""" Display
syntax enable
set mouse=a
" vital for mouse working in terminal
set ttymouse=xterm2
if has("gui_running")
    colorscheme solarized
    set background=light
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
    set lines=60
    set columns=85

    endif
else
    " set t_Co=256
    " set term=xterm-256color
    set term=screen-256color
    " se t_co=256
    " let g:solarized_termcolors=256
    colorscheme solarized "default
    set background=light
    "set nocursorline
    set colorcolumn=80
    set cursorline
    "set lines=60 columns=85
endif
set encoding=utf-8
set termencoding=utf-8

" commands for changing the colors around
function! ChangeColorScheme()
    if exists("g:colors_name")
        if g:colors_name == 'lucius'
            if g:lucius_style == 'dark'
                LuciusLight
            elseif g:lucius_style == 'light'
                LuciusDark
            endif
        elseif g:colors_name == 'solarized'
            let &background = ( &background == "dark"? "light" : "dark" )
        else
            let &background = ( &background == "dark"? "light" : "dark" )
        endif
    else
        " escape
        colorscheme solarized
        set background=light
    endif
endfunction
function! SwitchLucius()
    if exists("g:colors_name")
        if g:colors_name == 'solarized'
            colorscheme lucius
            LuciusLight
            AirlineTheme lucius
        elseif g:colors_name == 'lucius'
            colorscheme solarized
            set background=light
            AirlineTheme solarized
            "call togglebg#map("<F5>")
        else
            " escape!
            colorscheme solarized
            set background=light
        endif
    else
        colorscheme solarized
        set background=light
    endif
endfunction
map <F5> :call ChangeColorScheme()<CR>
map <S-F5> :call SwitchLucius()<CR>
nnoremap <leader>cS :call SwitchLucius()<CR>
nnoremap <leader>cs :call ChangeColorScheme()<CR>

" Paste from clipboard
map <leader>p "+p
" yank to clipboard
map <leader>y "+y

" Quit window on <leader>q
" Actually, no. leader q closes an active split screen
" nnoremap <leader>q :q<CR>
nnoremap <leader>qq :bd<CR>
nnoremap <leader>qw <c-w>q
" vim-bbye plugin
nnoremap <leader>qb :Bdelete<CR>
" quit!
nnoremap <leader>qQ :q<CR>
nnoremap <leader>qa :qa<CR>

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

" some buffer options
set hidden " don't have to save between buffer switches
nmap gb :bnext<CR>
nmap gB :bprevious<CR>
nmap <leader>bl :ls<CR>

" setglobal relativenumber

autocmd WinEnter,FocusGained * :setlocal number relativenumber
autocmd WinLeave,FocusLost   * :setlocal number norelativenumber

autocmd InsertEnter * :setlocal number norelativenumber
autocmd InsertLeave * :setlocal number relativenumber

" ==========================================================
" tagbar -- lets you see your functions. super useful!
" ==========================================================
nmap <leader>tb :Tagbar<CR>

" ==========================================================
" Ack shortcut to encourage me to use it!
" ==========================================================
nmap <leader>A :Ack

" ==========================================================
" Obsess shortcut to encourage me to use it!
" ==========================================================
nmap <leader>O :Obsess

" ==========================================================
" previewmarkdown command that I copied from the internet
" it parses document and presents it as markdown in browser
" ==========================================================
nmap <leader>md :call PreviewMarkdown()<CR>

" ==========================================================
" vimwiki
" ==========================================================
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

" ==========================================================
" Syntastic
" ==========================================================
" set syntastic to active
" let g:syntastic_mode_map = { 'mode': 'passive'}
let g:syntastic_mode_map = { 'mode': 'active'}
" also set syntastic to muffle style stuff unless I explicitly want it
let g:syntastic_quiet_messages= {'type': 'style', 'level': 'warnings'}
" let's use flake8.
" pylint is a little annoying in its ability to handle numpy
let g:syntastic_python_checkers=['flake8'] " , 'pylint']
" aggregate errors

" show warnings and errors
let g:syntastic_error_symbol = 'E>'
let g:syntastic_style_error_symbol = 'S>'
let g:syntastic_warning_symbol = 'W>'
let g:syntastic_style_warning_symbol = 's>'
" run syntastic tests
function! SynCheckStyle()
    let g:syntastic_quiet_messages= {} " 'type': 'style'} 'level': 'warnings'}
    call SyntasticCheck()
endfunction
function! SynCheckNoStyle()
    let g:syntastic_quiet_messages= {'type': 'style', 'level': 'warnings'}
    call SyntasticCheck()
endfunction
"nmap <Leader>sc :SyntasticCheck<CR>
nmap <Leader>sc :call SynCheckStyle()<CR>
nmap <Leader>sC :call SynCheckNoStyle()<CR>
nmap <Leader>se :Errors<CR>
nmap <Leader>st :SyntasticToggleMode<CR>
nmap <Leader>si :SyntasticInfo<CR>


" ==========================================================
" Calendar stuff
" ==========================================================
let g:calendar_google_calendar = 1
let g:calendar_google_task = 0
nmap <leader>C :tab Calendar<CR>


" ==========================================================
" Fugitive
" ==========================================================
nnoremap <leader>Gs :Gstatus<CR>
nnoremap <leader>Go :Gread<CR>
nnoremap <leader>Gc :Gcommit -a<CR>
nnoremap <leader>Gd :Gdiff<CR>
nnoremap <leader>Gb :Gblame<CR>
nnoremap <leader>GB :Gbrowse<CR>
nnoremap <leader>Gp :Git! push<CR>
nnoremap <leader>GP :Git! pull<CR>


" ==========================================================
" vim airline
" ==========================================================
" note that this overrides statusline customized above!
let g:airline_left_sep = ' '
let g:airline_left_alt_sep = '|'
let g:airline_right_sep = ' '
let g:airline_right_alt_sep = '|'

" move filetype from section_x to section_y; remove the encoding since I never
" actually use that
let g:airline_section_x='%{airline#util#wrap(airline#extensions#tagbar#currenttag(),0)}'
let g:airline_section_y='%{airline#util#wrap(airline#parts#filetype(),0)}'
" add buffer number in front of percentage
let g:airline_section_z='%3n : %p%% %{g:airline_symbols.linenr}%#__accent_bold#%4l%#__restore__#:%3v'

let g:airline#extensions#branch#enabled=1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#tagbar#enabled = 1

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#right_sep = ' '
let g:airline#extensions#tabline#right_alt_sep = '|'
" show buffer number
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#tab_nr_type = 2 " splits and tab number
let g:airline#extensions#tabline#show_tab_type = 1
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
" ==========================================================
" tmuxline
" ==========================================================
" :TmuxlineSnapshot ~/.dotfiles/tmuxline.conf
let g:tmuxline_powerline_separators = 0
let g:tmuxline_theme = 'airline'
let g:tmuxline_preset = 'powerline'
let g:airline#extensions#tmuxline#enabled = 0

" ==========================================================
" promptline
" ==========================================================
" " :PromptlineSnapshot ~/.dotfiles/promptline.sh
let g:promptline_theme = 'airline'
let g:promptline_powerline_symbols = 0
" sections (a, b, c, x, y, z, warn) are optional
let g:promptline_preset = {
        \'a' : [ promptline#slices#user() ],
        \'b' : [ promptline#slices#cwd() ],
        \'x' : [ promptline#slices#jobs() ],
        \'y' : [ promptline#slices#git_status(), promptline#slices#vcs_branch() ],
        \'z' : [ promptline#slices#host({ 'only_if_ssh': 1 }) ],
        \'warn' : [ promptline#slices#last_exit_code() ]}
" !rm ~/.dotfiles/promptline.sh
" PromptlineSnapshot ~/.dotfiles/promptline.sh

" ==========================================================
" CtrlP
" http://kien.github.io/ctrlp.vim/
" ==========================================================
set runtimepath^=~/.vim/bundle/ctrlp.vim
" f for find
nmap <leader>f :CtrlPMixed<CR>
nmap <leader>F :CtrlPBuffer<CR>

" ==========================================================
" Remap help to a new tab instead of horizontal split
" ==========================================================
cnoreabbrev <expr> h getcmdtype() == ":" && getcmdline() == 'h' ? 'tab help' : 'h'


" ==========================================================
" Compete options
" ==========================================================
set completeopt=menu,preview,menuone,longest
" set complete=.,w,b,u,t " -=i if things get slow
set pumheight=6             " Keep a small completion window
" load complete menu to C-space. This doesn't work?
inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-Space>
" also from leader leader or ,,
inoremap <leader>, <C-x><C-o>

" ==========================================================
" Jedi
" ==========================================================
let g:jedi#auto_initialization = 1
let g:jedi#auto_vim_configuration = 1
let g:jedi#use_splits_not_buffers = "top"
let g:jedi#popup_on_dot = 0

" some bindings
let g:jedi#goto_command = "<leader>jg"
let g:jedi#goto_assignments_command = ""
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>jn"
let g:jedi#completions_command = "<leader>jc"
let g:jedi#rename_command = "<leader>jr"


" ===========================================================
" Handy Latex Bindings and vimtex
" ============================================================
function! CompileLatex()
    :silent make! %
    :silent !bibtex8 %:r
    :silent make! %
    :silent make! %
    "silent Clean
    :silent ! rm %:r.blg
    :silent ! rm %:r.aux
    :silent ! rm %:r.bbl
    :silent ! rm %:r.bcf
    :silent ! rm %:r.out
    :silent ! rm %:r.run.xml
    :silent ! rm %:r-blx.bib
    :silent ! rm %:r.tdo
    :silent ! rm %:r.toc

    " :silent ! rm %:r.log
endfunction

nnoremap <silent> <leader>lL :call CompileLatex()<CR>
nnoremap <silent> <leader>lO :! open %:r.pdf<CR><CR>
nnoremap <silent> <leader>lF :silent make! %<CR>
nnoremap <leader>gq ?^$\\|^\s*\(\\begin\\|\\end\\|\\label\)?1<CR>gq//-1<CR>

let g:vimtex_enabled = 1
let g:tex_flavor = 'latex'
let g:vimtex_quickfix_open_on_warning = 0

" ===========================================================
" FileType specific changes
" ============================================================
" Mako/HTML
autocmd BufNewFile,BufRead *.mako,*.mak,*.jinja2 setlocal ft=html
autocmd FileType html,xhtml,xml,css setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2

" Javascript
au BufRead *.js setl makeprg=jslint\ %

" Latex
au BufRead *.tex setlocal spell

" Python
" au BufRead *.py compiler nose
" au FileType python setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4 smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with
" au BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m


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
