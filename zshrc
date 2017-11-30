# Lines configured by zsh-newuser-install
HISTFILE=${HOME}/.histfile
HISTSIZE=1000
SAVEHIST=1000

# type directory name to auto cd there ie /bin instead of /bin
setopt autocd
# do not overwrite history, append
setopt append_history
# gives more options for ls. see ls *(<tab>
setopt extendedglob
# give an error if there is no match for a pattern
setopt nomatch
# report status of background jobs immediately
setopt notify
# spelling corrections
setopt correct
# do not clobber automatically. overwrite with !
setopt noclobber
# Killer: share history between multiple shells
setopt SHARE_HISTORY
# beeping is annoying
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename ${HOME}/.zshrc

autoload -Uz compinit
compinit
# End of lines added by compinstall

# my zshrc
# configure jk to go into normal mode
# plus a couple other useful ones.
bindkey -M viins jk vi-cmd-mode
bindkey -M vicmd -s ",h" "^"
bindkey -M vicmd -s ",l" "$"

#parses .dircolors and makes env var for GNU ls
directory_colors=${HOME}/.dircolors

# and now we will ignore that and source promptline
source ${HOME}/.dotfiles/promptline/promptline.sh
# method for quick change directories. Add this to your ${HOME}/.zshrc, then just
# enter “cd …./dir”
rationalise-dot() {
  if [[ $LBUFFER == *.. ]]; then
    LBUFFER+=/..
  else
    LBUFFER+=.
  fi
}
zle -N rationalise-dot
bindkey . rationalise-dot

#####
# iterm2 functions: common things I like doing with special terminal settings
# for setting color profiles, use it2setcolor. Might want to limit this only to things with iterm. I think I can do that with it2check
#####
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# added by travis gem
[ -f /Users/cpd/.travis/travis.sh ] && source /Users/cpd/.travis/travis.sh

# should this really be here and not in env files?
export PROJECTS_DIR=${HOME}/Projects
# using the PROJECTS_DIR from above, define some variables
export IPYTHON_NOTEBOOK_DIR=$PROJECTS_DIR

#####
# define commands based on CPD_NAME
#####
if [[ $CPD_NAME == 'MBPR' ]]; then
    eval "$(gdircolors ${HOME}/.dircolors)";
    alias ls='gls -hFa --color'
    alias vim='mvim -v --servername VIM -c "colorscheme solarized"'
    alias notebook="jupyter notebook"
    alias pipi='sudo pip install'
    alias pipu='sudo pip install --upgrade'

    # googler is a useful search command
    alias goo='googler'
elif [[ $CPD_NAME == 'MB' ]]; then
    eval "$(gdircolors ${HOME}/.dircolors)";
    alias ls='gls -hFa --color'
    alias vim='mvim -v --servername VIM -c "colorscheme solarized"'
    alias notebook="jupyter notebook"
    alias pipi='pip install'
    alias pipu='pip install --upgrade'
elif [[ $CPD_NAME == 'MBP08' ]]; then
    eval "$(gdircolors ${HOME}/.dircolors)";
    alias ls='gls -hFa --color'
    alias notebook="jupyter notebook"
    alias pipi='pip install'
    alias pipu='pip install --upgrade'
elif [[ $CPD_NAME == 'KILS' ]]; then
    eval "$(dircolors ${HOME}/.dircolors)";
    alias ls='ls -hFaG --color'
    alias vim='vim -c "colorscheme lucius|set background=light"'
    export IPYNOTEBOOKIP=`echo $SSH_CONNECTION | awk '{print $3}'`
    alias notebook="jupyter notebook --ip=${IPYNOTEBOOKIP} --port=8008"
    alias pipi="pip install --user"
    alias pipu="pip install --user --upgrade"

    # overwrite slac to just be simple ssh
    function slac(){ ssh -Y cpd@ki-ls${1}.slac.stanford.edu ; }
    alias bjob="bjobs -w | less"
    alias bjobl="bjobs -l | less"
    alias bjobr="bjobs -wr | less"
    alias bjobrl="bjobs -rl | less"
    alias bjoblr=bjobrl
    alias gopen='gnome-open'
    alias pdf='evince'
    alias devmode4='scl enable devtoolset-4 zsh'  # creates new shell. Exit to exit devmode
    alias devmode='scl enable devtoolset-6 zsh'  # creates new shell. Exit to exit devmode
    function roopsfex() { /nfs/slac/g/ki/ki22/roodman/EUPS_DESDM/eups/packages/Linux64/psfex/3.17.3+0/bin/psfex ${1} -c /nfs/slac/g/ki/ki18/cpd/Projects/WavefrontPSF/code/DeconvolvePSF/cluster/desdm-plus_cpd_16_02_02.psfex -OUTCAT_NAME ${2} ; }
elif [[ $CPD_NAME == 'SHERLOCK' ]]; then
    eval "$(dircolors ${HOME}/.dircolors)";
    alias ls='ls -hFaG --color'
    alias vim='vim -c "colorscheme lucius|set background=dark"'
    alias notebook="jupyter notebook"
    alias pipi="pip install --user"
    alias pipu="pip install --user --upgrade"
else
    alias ls='ls -hFaG'
    alias vim='vim -c "colorscheme lucius|set background=light"'
    alias notebook="jupyter notebook"
    alias pipi="pip install --user"
    alias pipu="pip install --user --upgrade"
fi


# every time a directory changes; zsh checks if chpwd is defined and runs it 
function chpwd(){ ls; }

#####
# Aliases
#####
function pdfmerge() { gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -sOutputFile=$@ ; }
alias vims='vim -S Session.vim'
alias dua='du -h | sort -nr'

# latex configs
alias ltex='xelatex -file-line-error -interaction=nonstopmode *.tex'
function CompileLatex()
{
    xelatex -file-line-error -interaction=nonstopmode ${1}.tex
    bibtex8 ${1}.aux
    xelatex -file-line-error -interaction=nonstopmode ${1}.tex
    xelatex -file-line-error -interaction=nonstopmode ${1}.tex
}

# alias slac='ssh -Y cpd@ki-ls.slac.stanford.edu'
function kint(){
    kinit --afslog --renewable cpd@stanford.edu ;
    kinit --afslog --renewable cpd@SLAC.STANFORD.EDU ; }
function nersc(){
    if it2check ; then it2setcolor preset 'Spacedust'; fi
    ssh -Y cpd@cori.nersc.gov }
function stanford(){
    # cardinal = small, interactive, corn = more intense interactive, barley = submit, rye = gpu
    if it2check ; then it2setcolor preset 'AtomOneLight'; fi
    kswitch -p cpd@stanford.edu ;
    kinit --afslog --renewable --renew cpd@stanford.edu ;
    # ssh -KY -o GSSAPIKeyExchange=no cpd@corn${1}.stanford.edu ; }
    ssh -KY cpd@${1=cardinal}${2}.stanford.edu ; }
function sherlock(){
    if it2check ; then it2setcolor preset 'LuciusDark'; fi
    kswitch -p cpd@stanford.edu ;
    kinit --afslog --renewable --renew cpd@stanford.edu ;
    # ssh -KY -o GSSAPIKeyExchange=no cpd@sherlock.stanford.edu ; }
    ssh -KY cpd@login.sherlock.stanford.edu ; }
function slac(){
    if it2check ; then it2setcolor preset 'LuciusLight'; fi
    kswitch -p cpd@SLAC.STANFORD.EDU ;
    kinit --afslog --renewable --renew cpd@SLAC.STANFORD.EDU ;
    # kinit --afslog --renewable cpd@SLAC.STANFORD.EDU ;
    ssh -KY cpd@ki-ls${1}.slac.stanford.edu ; }

alias trivialAccess='echo "You should use easyaccess!"'

function tmuxline()
{
    # changes my promptline configs in case solarized looks like poop
    # SolarizedLight, SolarizedDark, LuciusLight, LuciusDark
    # note: still have to change the vim settings from within vim via
    # <leader>cS and <leader>cs
    tmux source ${HOME}/.dotfiles/tmuxline/tmuxline_${1:=LuciusLight}.conf
    tmux send-keys "source ${HOME}/.dotfiles/promptline/promptline_${1:=LuciusLight}.sh" C-m
}
function promptline()
{
    # changes my promptline configs in case solarized looks like poop
    # SolarizedLight, SolarizedDark, LuciusLight, LuciusDark
    # note: still have to change the vim settings from within vim via
    # <leader>cS and <leader>cs
    source ${HOME}/.dotfiles/promptline/promptline_${1:=LuciusLight}.sh
}

# URL encode something and print it.
function url-encode; {
    echo "${${(j: :)@}//(#b)(?)/%$[[##16]##${match[1]}]}" }

function downslac() { rsync -rav ${@:4} cpd@ki-ls${3:=08}.slac.stanford.edu:${1} ${2} ;}
function upslac() { rsync -rav ${@:4} ${1} cpd@ki-ls${3:=08}.slac.stanford.edu:${2} ;}
function downsherlock() { rsync -rav ${@:3} cpd@sherlock.stanford.edu:${1} ${2} ;}
function upsherlock() { rsync -rav ${@:3} ${1} cpd@sherlock.stanford.edu:${2} ;}
function downnersc() { rsync -rav ${@:3} cpd@cori.nersc.gov:${1} ${2} ;}
function upnersc() { rsync -rav ${@:3} ${1} cpd@cori.nersc.gov:${2} ;}

function tmuxs
{
    # I like my tmux to be in a certain color scheme. We can ensure that with iterm2
    if it2check ; then it2setcolor preset 'Solarized Light'; fi
    tmux new-session -s tmuxs
}
# tmux sharing
alias tmuxa="tmux -u attach-session -t tmuxs:1"

# kick off other terminals
alias detach='tmux detach -a'

function tmuxk() {
    # Kill defunct sessions first
    old_sessions=($(tmux ls 2>/dev/null | egrep "^[0-9]{14}.*[0-9]+\)$" | cut -f 1 -d:))
    for old_session_id in ${old_sessions[*]}; do
        tmux kill-session -t $old_session_id ;
    done
}

function tmx() {
    #
    # Modified TMUX start script from:
    #     http://forums.gentoo.org/viewtopic-t-836006-start-0.html
    # and then from:
    #     https://mutelight.org/practical-tmux
    #
    # Store it to `${HOME}/bin/tmx` and issue `chmod +x`.
    #

    # Works because bash automatically trims by assigning to variables and by
    # passing arguments
    trim() { echo $1; }

    # if [[ -z "$1" ]]; then
    #     echo "Specify session name as the first argument"
    #     exit
    # fi

    # Only because I often issue `ls` to this script by accident
    if [[ "$1" == "ls" ]]; then
        tmux ls
        exit
    fi

    # I like my tmux to be in a certain color scheme. We can ensure that with iterm2
    if it2check ; then it2setcolor preset 'Solarized Light'; fi

    base_session=tmuxs
    if [[ -z "$TMUX" ]]; then
        # Kill defunct sessions first
        old_sessions=($(tmux ls 2>/dev/null | egrep "^[0-9]{14}.*[0-9]+\)$" | cut -f 1 -d:))
        for old_session_id in $old_sessions; do
            tmux kill-session -t $old_session_id
        done

        echo "Launching copy of base session $base_session ..."
        # Session is is date and time to prevent conflict
        session_id=`date +%Y%m%d%H%M%S`
        # Create a new session (without attaching it) and link to base session
        # to share windows
        tmux new-session -d -t $base_session -s $session_id
        # Create a new window in that session
        #tmux new-window
        # focus session on vim journal window
        tmux select-window -t $session_id:2
        # Attach to the new session
        tmux attach-session -t $session_id
        # When we detach from it, kill the session
        tmux kill-session -t $session_id
    fi
}

function irc() {
    if it2check ; then it2setcolor preset 'Spacedust'; fi
    cd ${HOME}/.irssi
    TERM=screen-256color irssi
}

function vimwiki() {
    if it2check ; then it2setcolor preset 'Solarized Light'; fi
    cd ${HOME}/Projects/vimwiki
    vims
}

function pylab() {
    if it2check ; then it2setcolor preset 'GithubMod'; fi
    ipython --profile=nbserver
}

function jpy() {
    if it2check ; then it2setcolor preset 'GithubMod'; fi
    notebook
}

# play crawl over the internet!
function sshcrawl() {
    # check if the ssh key exists
    if [[ ! -a ${HOME}/.ssh/cao_key ]]; then
        wget -O ${HOME}/.ssh/cao_key http://crawl.akrasiac.org/cao_key
        chmod 400 ${HOME}/.ssh/cao_key
    fi

    if it2check ; then it2setcolor preset 'Tango Dark'; fi

    # ssh command
    ssh -C -i ${HOME}/.ssh/cao_key -l joshua crawl.akrasiac.org
}

function dwarfort() {
    if it2check ; then it2setcolor preset 'Tango Dark'; fi
    ${HOME}/.local/games/df_osx/dwarfort
}
function nethack() {
    if it2check ; then it2setcolor preset 'Tango Dark'; fi
    /usr/local/bin/nethack
}
function crawl() {
    if it2check ; then it2setcolor preset 'Tango Dark'; fi
    /Applications/Games/Dungeon\ Crawl\ Stone\ Soup\ -\ Console.app/Contents/Resources/crawl
}

function ds() { ds9 ${1} -scalemode zscale -cmap grey -cmap invert yes & ;}
function im() { python -c "import matplotlib.pyplot as plt; plt.imshow(plt.imread('${1}')); plt.show()" & ;}

# function that displays names and then shows the plot. Relies on imgcat
function limgcat() {
    for x in "${@}"; do
        echo $x;
        imgcat $x;
    done
}

# a useful command for fetching all git branches in a repo
function fetch(){
    # git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done
    for remote in `git branch -r`; do git branch --track ${remote#origin/} $remote; done
    git fetch --all
    git pull --all
}
# function that does all the requisite testing for jekyll blogging
function blog() {
    if it2check ; then it2setcolor preset 'Spacedust'; fi
    cd ${HOME}/Projects/cpadavis.github.io
    bundle update
    bundle exec jekyll build
    bundle exec jekyll serve
}
