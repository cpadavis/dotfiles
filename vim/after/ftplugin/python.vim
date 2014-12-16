" Python

""" General settings
setl expandtab
setl shiftwidth=4
setl softtabstop=4
setl cinwords=if,elif,else,for,while,try,except,finally,def,class,with

setl tw=79
setl formatoptions+=c
setl formatoptions-=t
" setl formatoptions+=a
setl formatoptions+=r

" setl comments=b:#,sb:\"\"\"\ ,m:\",ex:\"\"\"

setl makeprg=python\ %
setl omnifunc=pythoncomplete#Complete
setl efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

" run py.test's
nmap <silent><Leader>tf <Esc>:Pytest file<CR>
nmap <silent><Leader>tc <Esc>:Pytest class<CR>
nmap <silent><Leader>tm <Esc>:Pytest method<CR>
nmap <silent><Leader>tn <Esc>:Pytest next<CR>
nmap <silent><Leader>tp <Esc>:Pytest previous<CR>
nmap <silent><Leader>te <Esc>:Pytest error<CR>

" Run django tests
map <leader>dt :set makeprg=python\ manage.py\ test\|:call MakeGreen()<CR>


