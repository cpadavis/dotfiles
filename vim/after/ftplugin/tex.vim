" Some TeX settings.

""" General settings
setl shiftwidth=2
setl softtabstop=2
setl tw:79

setl formatoptions+=c
setl formatoptions+=o
setl formatoptions+=r
setl formatoptions+=t
setl formatoptions-=a
setl formatoptions+=q
let &l:flp = '\v\\%(item|prob)%([\[{]\ze.{-}[\]}])?\s*'

setl spell
let g:tex_comment_nospell = 1

""" Abbreviations
" taken from the Vim help, :h abbreviations
function! EatChar(pat)
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunc

iab <buffer> lam lambda<C-R>=EatChar('\s')<CR>


""" Increase font size for tex windows
if has("gui_running")
    setl guifont=Menlo:h14.00
endif
""" :make
compiler tex

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

nnoremap <silent> <leader>ll :call CompileLatex()<CR>
nnoremap <silent> <leader>lo :! open %:r.pdf<CR><CR>
nnoremap <silent> <leader>lf :silent make! %<CR>

map <leader>gq ?^$\\|^\s*\(\\begin\\|\\end\\|\\label\)?1<CR>gq//-1<CR>
" omap lp ?^$\\|^\s*\(\\begin\\|\\end\\|\\label\)?1<CR>//-1<CR>.<CR>
" setl makeprg=xelatex\ \-file\-line\-error\ \-interaction=nonstopmode
" setl makeprg=xelatex\ \-file\-line\-error\ \-interaction=nonstopmode \-output\-driver="/usr/texbin/xdvipdfmx"
" setl makeprg=pdflatex\ \-file\-line\-error\ \-interaction=nonstopmode\ \-\-synctex=1
setl makeprg=pdflatex\ \-file\-line\-error\ \-interaction=nonstopmode\ \-\-synctex=0
setl efm=%f:%l:\ %m

"" if ! ( filereadable('Makefile') || filereadable('makefile') )
""     " nnoremap <buffer> <F4> :make %:r<CR>
""     nnoremap <leader>ll :make %:r<CR>
""     let &mp = 'pdf' . &mp
"" else
""     " nnoremap <buffer> <F4> :make<CR>
""     setl makeprg=pdflatex\ \-file\-line\-error\ \-interaction=nonstopmode
""     set efm=%f:%l:\ %m
""     nnoremap <leader>ll :call CompileLatex()<CR>
"" endif

""" Plugin settings
if exists(':Tabularize')
    AddTabularPattern tex_table /&\|\\\\/
    nnoremap <buffer> <silent> <leader>tt :Tabularize tex_table<CR>
endif

if exists('g:loaded_surround')
    " vim-surround: q for `foo' and Q for ``foo''
    let b:surround_{char2nr('q')} = "`\r'"
    let b:surround_{char2nr('Q')} = "``\r''"
    " for sets
    let b:surround_{char2nr('s')} = "\\{ \r \\}"
endif

""
"" taken from godlygeek's vimrc. Pretty nice way to handle folding.
"" vim:fdm=expr
"" vim:fde=getline(v\:lnum)=~'^""'?'>'.(matchend(getline(v\:lnum),'""*')-2)\:'='
