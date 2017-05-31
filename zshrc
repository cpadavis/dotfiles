

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
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
zstyle :compinstall filename ~/.zshrc

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
d=~/.dircolors
if [[ $CPD_NAME == 'MAC' ]]; then
    eval "$(gdircolors $d)";
    alias ls='gls -hFa --color'
elif [[ $CPD_NAME == 'MB' ]]; then
    eval "$(gdircolors $d)";
    alias ls='gls -hFa --color'
elif [[ $CPD_NAME == 'OLDMAC' ]]; then
    eval "$(gdircolors $d)";
    alias ls='gls -hFa --color'
elif [[ $CPD_NAME == 'KILS' ]]; then
    eval "$(dircolors $d)";
    alias ls='ls -hFaG --color'
elif [[ $CPD_NAME == 'SHERLOCK' ]]; then
    eval "$(dircolors $d)";
    alias ls='ls -hFaG --color'
    alias vim='vim -c "colorscheme lucius|set background=dark"'
else
    alias ls='ls -hFaG'
fi

# change prompt colors
# autoload -U colors && colors
# PS1="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "

# and now we will ignore that and source promptline
source ~/.dotfiles/promptline/promptline.sh
# method for quick change directories. Add this to your ~/.zshrc, then just
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

# Aliases
alias pylab='ipython --profile=nbserver'
if [[ $CPD_NAME == 'MAC' ]]; then
    # thanks jupyter for removing profiles
    alias notebook="jupyter notebook"
    alias iconsole='ipython console --existing'
elif [ -z "$SSH_CONNECTION" ]; then
    if [[ $CPD_NAME == 'KILS' ]]; then
        # thanks jupyter for removing profiles
        alias notebook="ipython notebook"
        alias iconsole='ipython console --existing'
    elif [[ $CPD_NAME == 'MB' ]]; then
        # thanks jupyter for removing profiles
        alias notebook="jupyter notebook"
        alias iconsole='ipython console --existing'
    else
        alias notebook="ipython notebook --profile=nbserver"
        alias iconsole='ipython console --profile=nbserver --existing'
    fi
else
    export IPYNOTEBOOKIP=`echo $SSH_CONNECTION | awk '{print $3}'`
    alias notebook="jupyter notebook --ip=${IPYNOTEBOOKIP} --port=8008"
fi

# http://kipac.stanford.edu/collab/computing/docs/afs
function pdfmerge() { gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -sOutputFile=$@ ; }

# check if we have mvim else just stick to vim
if hash mvim 2>/dev/null; then
    # if we have mvim then we also want to set the colorscheme to solarized
    # alias vim='mvim -v --servername VIM -c "colorscheme solarized" -c "set background=dark"'
    alias vim='mvim -v --servername VIM -c "colorscheme solarized"'
else
fi
alias vims='vim -S Session.vim'
alias dua='du -h | sort -nr'
alias ltex='xelatex -file-line-error -interaction=nonstopmode *.tex'

function CompileLatex()
{
    xelatex -file-line-error -interaction=nonstopmode ${1}.tex
    bibtex8 ${1}.aux
    xelatex -file-line-error -interaction=nonstopmode ${1}.tex
    xelatex -file-line-error -interaction=nonstopmode ${1}.tex
}

# alias slac='ssh -Y cpd@ki-ls.slac.stanford.edu'
alias myslac='ssh -Y cpd@ki-rh29.slac.stanford.edu'
alias nersc='ssh -Y cpd@cori.nersc.gov'  # NB: hopper is now shut down
alias edison='ssh -Y cpd@edison.nersc.gov'  # NB: hopper is now shut down
function kint(){
    kinit --afslog --renewable cpd@stanford.edu ;
    kinit --afslog --renewable cpd@SLAC.STANFORD.EDU ;
}
function rye(){
    kswitch -p cpd@stanford.edu ;
    kinit --afslog --renewable --renew cpd@stanford.edu ;
    # ssh -KY -o GSSAPIKeyExchange=no cpd@rye${1}.stanford.edu ; }
    ssh -KY cpd@rye${1}.stanford.edu ; }
function corn(){
    kswitch -p cpd@stanford.edu ;
    kinit --afslog --renewable --renew cpd@stanford.edu ;
    # ssh -KY -o GSSAPIKeyExchange=no cpd@corn${1}.stanford.edu ; }
    ssh -KY cpd@corn${1}.stanford.edu ; }

function sherlock(){
    kswitch -p cpd@stanford.edu ;
    kinit --afslog --renewable --renew cpd@stanford.edu ;
    # ssh -KY -o GSSAPIKeyExchange=no cpd@sherlock.stanford.edu ; }
    ssh -KY cpd@sherlock.stanford.edu ; }
function slac(){
    kswitch -p cpd@SLAC.STANFORD.EDU ;
    kinit --afslog --renewable --renew cpd@SLAC.STANFORD.EDU ;
    # kinit --afslog --renewable cpd@SLAC.STANFORD.EDU ;
    ssh -KY cpd@ki-ls${1}.slac.stanford.edu ; }

alias trivialAccess='echo "You should use easyaccess!"'
# alias trivialAccess='trivialAccess \-u cpd \-p cpd70chips -d dessci'

function tmuxline()
{
    # changes my promptline configs in case solarized looks like poop
    # SolarizedLight, SolarizedDark, LuciusLight, LuciusDark
    # note: still have to change the vim settings from within vim via
    # <leader>cS and <leader>cs
    tmux source ~/.dotfiles/tmuxline/tmuxline_${1:=LuciusLight}.conf
    tmux send-keys "source ~/.dotfiles/promptline/promptline_${1:=LuciusLight}.sh" C-m
}
function promptline()
{
    # changes my promptline configs in case solarized looks like poop
    # SolarizedLight, SolarizedDark, LuciusLight, LuciusDark
    # note: still have to change the vim settings from within vim via
    # <leader>cS and <leader>cs
    source ~/.dotfiles/promptline/promptline_${1:=LuciusLight}.sh
}

# URL encode something and print it.
function url-encode; {

                echo "${${(j: :)@}//(#b)(?)/%$[[##16]##${match[1]}]}"
                }

# Search google for the given keywords.
# export VIEW=/usr/bin/elinks
function google; { elinks "http://www.google.com/search?q=`url-encode "${(j: :)@}"`" ;}
function wiki; { elinks "http://www.wikipedia.org/search?q=`url-encode "${(j: :)@}"`" ;}
# googler is a useful search command
alias goo='googler'

export PROJECTS_DIR=~/Projects

# the cd is to change the color scheme
alias irssi='TERM=screen-256color irssi'

# some key difs between my mac and kils
if [[ $CPD_NAME == 'MAC' ]]; then
    PERL_MB_OPT="--install_base \"/Users/cpd/perl5\""; export PERL_MB_OPT;
    PERL_MM_OPT="INSTALL_BASE=/Users/cpd/perl5"; export PERL_MM_OPT;

    # alias mypython='/Library/Frameworks/EPD64.framework/Versions/Current/bin/python'
    # alias pipi='sudo -E /Library/Frameworks/EPD64.framework/Versions/Current/bin/pip install'
    # alias pipu='sudo -E /Library/Frameworks/EPD64.framework/Versions/Current/bin/pip install --upgrade'
    alias pipi='pip install'
    alias pipu='pip install --upgrade'
    function desdb() { scriptname=$1; shift; python /usr/local/bin/${scriptname} "$@"; }
    # DESDB Functions (* indicates prepend desdb command):
    # des-fits2table*
    # des-query*
    # des-red-expnames*
    # des-sync-coadd
    # des-sync-red
    # get-coadd-info-by-release*
    # get-coadd-info-by-run*
    # get-coadd-srclist*
    # get-coadd-srcruns-by-release*
    # get-coadd-srcruns-by-run*
    # get-red-info-by-release*
    # get-release-filelist*
    # get-release-runs*
    export CPD=/Users/cpd/

    function slac(){
        kinit --afslog --renewable --renew cpd@SLAC.STANFORD.EDU
        ssh -KY cpd@ki-ls${1}.slac.stanford.edu ;
        # if [ -z "$TMUX" ]; then
        #     kinit --afslog --renewable --renew cpd@SLAC.STANFORD.EDU
        #     ssh -KY cpd@ki-ls${1}.slac.stanford.edu ;
        # else
        #     tmux send-keys "tmux attach" C-m ;
        #     tmux send-keys "kinit --afslog --renewable cpd@SLAC.STANFORD.EDU" C-m ;
        #     tmux send-keys ${INNOC_SLAC} C-m ;
        #     ssh -KY cpd@ki-ls${1}.slac.stanford.edu ;
        # fi
    }

elif [[ $CPD_NAME == 'KILS' ]]; then


    function slac(){ ssh -Y cpd@ki-ls${1}.slac.stanford.edu ; }
    alias bjob="bjobs -w | less"
    alias bjobl="bjobs -l | less"
    # alias bjobr='bjobs | awk '\''{if($3 != "PEND") print ;}'\'' | less'
    alias bjobr="bjobs -wr | less"
    alias bjobrl="bjobs -rl | less"
    alias bjoblr=bjobrl
    # alias pipi="pip install --index-url=http://pypi.python.org/simple/ --trusted-host pypi.python.org --user"
    # alias pipu="pip install --index-url=http://pypi.python.org/simple/ --trusted-host pypi.python.org --user --upgrade"
    alias pipi="pip install"
    alias pipu="pip install --upgrade"
    function im() { python -c "import matplotlib.pyplot as plt; plt.imshow(plt.imread('${1}')); plt.show()" & ;}
    alias gopen='gnome-open'
    alias pdf='evince'
    function roopsfex() { /nfs/slac/g/ki/ki22/roodman/EUPS_DESDM/eups/packages/Linux64/psfex/3.17.3+0/bin/psfex ${1} -c /nfs/slac/g/ki/ki18/cpd/Projects/WavefrontPSF/code/DeconvolvePSF/cluster/desdm-plus_cpd_16_02_02.psfex -OUTCAT_NAME ${2} ; }

elif [[ $CPD_NAME == 'MB' ]]; then
    export PROJECTS_DIR=~/Projects
    alias pipi="pip install"
    alias pipu="pip install --upgrade"

else

    export PROJECTS_DIR=~/Projects
    alias pipi="pip install --user"
    alias pipu="pip install --user --upgrade"
fi

alias thisroot=". bin/thisroot.sh"

function slacvim(){ mvim scp://cpd@ki-ls${2}.slac.stanford.edu//afs/slac.stanford.edu/u/ki/cpd/${1} ;}

function qtconsole() { ipython qtconsole ${1} ;}
function slacbook() {

        host=$1
        kernel=$2
        profile=nbserver

        tempfile=`mktemp /tmp/ipyssh-XXXXXXXXXX`

        ssh cpd@ki-ls${host}.slac.stanford.edu "cat ~/.config/ipython/profile_$profile/security/$kernel" >! $tempfile

        ipython qtconsole --ssh cpd@ki-ls${host}.slac.stanford.edu --existing $tempfile

        rm -f $tempfile
    }

function ds() { ds9 ${1} -scalemode zscale -cmap grey -cmap invert yes & ;}



# function upslac() { scp -r ${1} cpd@ki-ls${3}.slac.stanford.edu:${2} ;}
# function downslac() { scp -r cpd@ki-ls${3}.slac.stanford.edu:${1} ${2} ;}
# function downsherlock() { scp -r cpd@sherlock.stanford.edu:${1} ${2} ;}
# function upnersc() { scp -r ${1} cpd@carver.nersc.gov:/global/homes/c/cpd/${2} ;}
# universally better:
function downslac() { rsync -rav ${@:4} cpd@ki-ls${3:=08}.slac.stanford.edu:${1} ${2} ;}
function upslac() { rsync -rav ${@:4} ${1} cpd@ki-ls${3:=08}.slac.stanford.edu:${2} ;}
function downsherlock() { rsync -rav ${@:3} cpd@sherlock.stanford.edu:${1} ${2} ;}
function upsherlock() { rsync -rav ${@:3} ${1} cpd@sherlock.stanford.edu:${2} ;}
function downnersc() { rsync -rav ${@:3} cpd@cori.nersc.gov:${1} ${2} ;}
function upnersc() { rsync -rav ${@:3} ${1} cpd@cori.nersc.gov:${2} ;}

# every time a directory changes; zsh checks if chpwd is defined and runs it
function chpwd(){ ls; }

# markdown macro

function tmuxs
{
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
    # Store it to `~/bin/tmx` and issue `chmod +x`.
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

# using the PROJECTS_DIR from above, define some variables
export IPYTHON_NOTEBOOK_DIR=$PROJECTS_DIR

# play crawl over the internet!
function crawl() {
    # check if the ssh key exists
    if [[ ! -a ~/.ssh/cao_key ]]; then
        wget -O ~/.ssh/cao_key http://crawl.akrasiac.org/cao_key
        chmod 400 ~/.ssh/cao_key
    fi

    # ssh command
    ssh -C -i ~/.ssh/cao_key -l joshua crawl.akrasiac.org
}

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# added by travis gem
[ -f /Users/cpd/.travis/travis.sh ] && source /Users/cpd/.travis/travis.sh
