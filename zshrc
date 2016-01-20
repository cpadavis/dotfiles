

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory extendedglob nomatch notify
unsetopt autocd beep
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
else
    eval "$(dircolors -b $d)";
    alias ls='ls -hFa --color'
fi

# change prompt colors
# autoload -U colors && colors
# PS1="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "

# and now we will ignore that and source promptline
source ~/.dotfiles/promptline.sh

# method for quick change directories. Add this to your ~/.zshrc, then just
# enter “cd …./dir”
rationalise-dot() {
  if [[ $LBUFFER = *.. ]]; then
    LBUFFER+=/..
  else
    LBUFFER+=.
  fi
}
zle -N rationalise-dot
bindkey . rationalise-dot

# Aliases
alias pylab='ipython --profile=nbserver'
if [ -z "$SSH_CONNECTION" ]; then
    if [ $CPD_NAME = 'MAC' ]; then
        # thanks jupyter for removing profiles
        alias notebook="ipython notebook"
        alias iconsole='ipython console --existing'
    elif [ $CPD_NAME = 'KILS' ]; then
        # thanks jupyter for removing profiles
        alias notebook="ipython notebook"
        alias iconsole='ipython console --existing'
    else
        alias notebook="ipython notebook --profile=nbserver"
        alias iconsole='ipython console --profile=nbserver --existing'
    fi
else
    export IPYNOTEBOOKIP=`echo $SSH_CONNECTION | awk '{print $3}'`
    if [ $CPD_NAME = 'KILS' ]; then
        alias notebook="ipython notebook --ip=${IPYNOTEBOOKIP} --port=8008"
        alias iconsole='ipython console --existing'
    else
        alias notebook="ipython notebook --profile=nbserver --ip=${IPYNOTEBOOKIP} --port=8008"
        alias iconsole='ipython console --profile=nbserver --existing'
    fi
fi

# http://kipac.stanford.edu/collab/computing/docs/afs
alias kint='/usr/local/bin/kinit --afslog --renewable'
alias kren='/usr/local/bin/kinit --afslog --renew'

# kick off other terminals
alias detach='tmux detach -a'

function pdfmerge() { gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -sOutputFile=$@ ; }

# check if we have mvim else just stick to vim
if hash mvim 2>/dev/null; then
    alias vim='mvim -v --servername VIM'
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

# tmux sharing

#alias tmuxs="tmux new-session -s tmuxs"

alias tmuxa="tmux attach-session -t tmuxs:1"
alias tmuxk="tmux kill-session -t tmuxs"
# alias slac='ssh -Y cpd@ki-ls.slac.stanford.edu'
alias myslac='ssh -Y cpd@ki-rh29.slac.stanford.edu'
alias nersc='ssh -Y cpd@cori.nersc.gov'  # NB: hopper is now shut down
# function slac(){ ssh -Y cpd@ki-ls${1:=08}.slac.stanford.edu ;}
function slac(){ ssh -Y cpd@ki-ls${1}.slac.stanford.edu ;}
# function slacany(){ ssh -Y cpd@ki-ls.slac.stanford.edu ;}
# function rye(){ ssh -Y -o GSSAPIKeyExchange=no cpd@rye${1:=01}.stanford.edu ;}
function rye(){ ssh -Y -o GSSAPIKeyExchange=no cpd@rye${1}.stanford.edu ;}
function corn(){ ssh -Y -o GSSAPIKeyExchange=no cpd@corn${1}.stanford.edu ;}
alias sherlock='kinit cpd@stanford.edu; ssh -X cpd@sherlock.stanford.edu'

alias trivialAccess='echo "You should use easyaccess!"'
# alias trivialAccess='trivialAccess \-u cpd \-p cpd70chips -d dessci'

function tmuxline()
{
    # changes my promptline configs in case solarized looks like poop
    # SolarizedLight, SolarizedDark, LuciusLight, LuciusDark
    # note: still have to change the vim settings from within vim via
    # <leader>cS and <leader>cs
    tmux source ~/.dotfiles/tmuxline_${1:=LuciusLight}.conf
    tmux send-keys "source ~/.dotfiles/promptline_${1:=LuciusLight}.sh" C-m
}
function promptline()
{
    # changes my promptline configs in case solarized looks like poop
    # SolarizedLight, SolarizedDark, LuciusLight, LuciusDark
    # note: still have to change the vim settings from within vim via
    # <leader>cS and <leader>cs
    source ~/.dotfiles/promptline_${1:=LuciusLight}.sh
}

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
    export PROJECTS_DIR=/Users/cpd/Projects


    function tmuxv
    {
        tmux send-keys -t ${1:=tmuxs:2} "vim -n ~/Dropbox/vimwiki/index.wiki" C-m
        tmux send-keys -t ${1:=tmuxs:2} ":e ~/Dropbox/vimwiki/Github.io\ Blog.wiki" C-m
        tmux send-keys -t ${1:=tmuxs:2} ":e ~/Dropbox/vimwiki/Whisker.wiki" C-m
        tmux send-keys -t ${1:=tmuxs:2} ":e ~/Dropbox/vimwiki/SWAP.wiki" C-m
        tmux send-keys -t ${1:=tmuxs:2} ":e ~/Dropbox/vimwiki/pixel\ area\ distortions.wiki" C-m
        tmux send-keys -t ${1:=tmuxs:2} ":e ~/Dropbox/vimwiki/strongcnn.wiki" C-m
        tmux send-keys -t ${1:=tmuxs:2} ":e ~/Dropbox/vimwiki/LearnPSF.wiki" C-m
        tmux send-keys -t ${1:=tmuxs:2} ":e ~/Projects/cluster-z/vimwiki/index.wiki" C-m
        tmux send-keys -t ${1:=tmuxs:2} ":set swapfile" C-m
        tmux send-keys -t ${1:=tmuxs:2} ":b1" C-m
    }
    function tmuxi
    {
        tmux send-keys -t ${1:=tmuxs} "kinit cpd@SLAC.STANFORD.EDU" C-m
        tmux send-keys -t ${1:=tmuxs} ${INNOC_SLAC} C-m
        tmux send-keys -t ${1:=tmuxs} "kinit cpd@stanford.edu" C-m
        tmux send-keys -t ${1:=tmuxs} ${INNOC_SHERLOCK} C-m
        # tmux send-keys -t ${1:=tmuxs} "kinit cpd@hopper.nersc.gov" C-m
        # tmux send-keys -t ${1:=tmuxs} ${INNOC_NERSC} C-m
    }

    function tmuxss
    {
        tmux new-session -s tmuxs
    }
    function tmuxs
    {
        tmux start-server
        tmux new-session -d -s tmuxs -n misc

        # send commands to windows
        # tmux send-keys -t tmuxs:1 "TERM=screen-256color irssi" C-m
        # tmux split-window -v -t tmuxs:1
        # tmux select-pane -t 1
        # tmux send-keys -t tmuxs:1 "ttytter" #C-m
        # tmux split-window -t tmuxs:1
        tmux send-keys -t tmuxs:1 "notebook" C-m
        tmux split-window -h -t tmuxs:1
        tmux send-keys -t tmuxs:1 "easyaccess" #C-m

        # open up vim windows
        tmux new-window -t tmuxs:2 -n vim
        tmux send-keys -t tmuxs:2 "cd /Users/cpd/Dropbox/vimwiki/" C-m
        tmux send-keys -t tmuxs:2 "vim -S Session.vim" C-m

        # # ssh
        # tmux new-window -t tmuxs:3 -n ssh
        # tmux send-keys -t tmuxs:3 "tmuxi tmuxs:3" C-m

        # blog
        tmux new-window -t tmuxs:3 -n blog
        tmux send-keys -t tmuxs:3 "cd /Users/cpd/Projects/cpadavis.github.io" C-m
        tmux send-keys -t tmuxs:3 "cd content" C-m
        tmux send-keys -t tmuxs:3 "vim -S Session.vim" C-m

        # LearnPSF
        tmux new-window -t tmuxs:4 -n LearnPSF
        tmux send-keys -t tmuxs:4 "cd /Users/cpd/Projects/LearnPSF" C-m

        # clusterz
        tmux new-window -t tmuxs:5 -n cluster-z
        tmux send-keys -t tmuxs:5 "cd /Users/cpd/Projects/cluster-z/code/clusterz" C-m
        tmux send-keys -t tmuxs:5 "vim -S Session.vim" C-m
        tmux split-window -h -t tmuxs:5
        tmux send-keys -t tmuxs:5.1 "cd /Users/cpd/Projects/cluster-z/doc" C-m
        tmux send-keys -t tmuxs:5.1 "vim -S Session.vim" C-m

        # wavefrontpsf
        tmux new-window -t tmuxs:6 -n WavefrontPSF
        tmux send-keys -t tmuxs:6 "cd /Users/cpd/Projects/WavefrontPSF/code/" C-m
        tmux send-keys -t tmuxs:6 "vim -S Session.vim" C-m
        tmux split-window -h -t tmuxs:6
        tmux send-keys -t tmuxs:6.1 "cd /Users/cpd/Projects/WavefrontPSF/docs/WavefrontPSF/" C-m
        tmux send-keys -t tmuxs:6.1 "vim -S Session.vim" C-m

        # swap
        tmux new-window -t tmuxs:7 -n SWAP
        tmux send-keys -t tmuxs:7 "cd /Users/cpd/Projects/SpaceWarps/analysis" C-m
        tmux send-keys -t tmuxs:7 "vim -S Session.vim" C-m
        tmux split-window -h -t tmuxs:7
        tmux send-keys -t tmuxs:7.1 "cd /Users/cpd/Projects/SpaceWarps/doc" C-m
        tmux send-keys -t tmuxs:7.1 "vim -S Session.vim" C-m

        # weak_sauce
        tmux new-window -t tmuxs:8 -n weak_sauce
        tmux send-keys -t tmuxs:8 "cd /Users/cpd/Projects/weak_sauce/code/weak_sauce" C-m
        tmux send-keys -t tmuxs:8 "vim -S Session.vim" C-m
        tmux split-window -h -t tmuxs:8
        tmux send-keys -t tmuxs:8.1 "cd /Users/cpd/Projects/weak_sauce/doc" C-m
        tmux send-keys -t tmuxs:8.1 "vim -S Session.vim" C-m
        # strongcnn
        tmux new-window -t tmuxs:9 -n strongcnn
        tmux send-keys -t tmuxs:9 "cd /Users/cpd/Projects/strongcnn" C-m
        tmux send-keys -t tmuxs:9 "vim -S Session.vim" C-m
        tmux split-window -h -t tmuxs:9
        tmux send-keys -t tmuxs:9.1 "cd /Users/cpd/Projects/strongcnn/doc/Paper" C-m
        tmux send-keys -t tmuxs:9.1 "vim -S Session.vim" C-m

        # osprey
        tmux new-window -t tmuxs:10 -n osprey
        tmux send-keys -t tmuxs:10 "cd /Users/cpd/Projects/osprey/osprey" C-m
        tmux send-keys -t tmuxs:10 "vim -S Session.vim" C-m
        tmux split-window -h -t tmuxs:10
        tmux send-keys -t tmuxs:10.1 "cd /Users/cpd/Projects/osprey" C-m

        # nerd-a-music
        tmux new-window -t tmuxs:11 -n nerd-a-music
        tmux send-keys -t tmuxs:11 "cd /Users/cpd/Projects/nerd-a-music" C-m

        # marmpy
        tmux new-window -t tmuxs:12 -n marmpy
        tmux send-keys -t tmuxs:12 "cd /Users/cpd/Projects/marmpy/pysrc" C-m
        tmux send-keys -t tmuxs:12 "vim -S Session.vim" C-m
        tmux split-window -h -t tmuxs:12
        tmux send-keys -t tmuxs:12.1 "cd /Users/cpd/Projects/marmpy/doc" C-m
        tmux send-keys -t tmuxs:12.1 "vim -S Session.vim" C-m

        # thesis proposal and oral slides
        tmux new-window -t tmuxs:13 -n thesis
        tmux send-keys -t tmuxs:13 "cd /Users/cpd/dropbox/derp-ninja/Articles/cpd2016JanThesisProposal" C-m
        tmux send-keys -t tmuxs:13 "vim -S Session.vim" C-m

        # go to the vim journal window
        tmux select-window -t tmuxs:2
        tmux attach-session -t tmuxs
        # When we detach from it, kill the session
        tmux kill-session -t tmuxs
    }
elif [[ $CPD_NAME == 'KILS' ]]; then

    export PROJECTS_DIR=/nfs/slac/g/ki/ki18/cpd/Projects/

    alias bjob="bjobs -w | less"
    alias bjobl="bjobs -l | less"
    # alias bjobr='bjobs | awk '\''{if($3 != "PEND") print ;}'\'' | less'
    alias bjobr="bjobs -wr | less"
    alias bjobrl="bjobs -rl | less"
    alias bjoblr=bjobrl
    alias pipi="pip install --index-url=http://pypi.python.org/simple/ --trusted-host pypi.python.org --user"
    alias pipu="pip install --index-url=http://pypi.python.org/simple/ --trusted-host pypi.python.org --user --upgrade"
    function tmuxs
    {
        tmux start-server
        tmux new-session -d -s tmuxs -n notebook
        tmux new-window -t tmuxs:2 -n workadirk

        tmux send-keys -t tmuxs:1 "notebook" C-m
        tmux split-window -v -t tmuxs:1
        tmux select-pane -t 1
        tmux send-keys -t tmuxs:1 "cd $SWAP/mongo/; mongod --dbpath ." C-m

        tmux select-window -t tmuxs:2
        tmux attach-session -t tmuxs
    }
    function im() { python -c "import matplotlib.pyplot as plt; plt.imshow(plt.imread('${1}')); plt.show()" & ;}
    alias gopen='gnome-open'
    alias pdf='evince'
    function roopsfex() { /nfs/slac/g/ki/ki22/roodman/DESDM/eups/packages/Linux64/psfex/3.17.0+0/bin/psfex ${1} -c /u/ec/roodman/Astrophysics/PSF/desdm-plus.psfex -OUTCAT_NAME ${2} ; }

else

    export PROJECTS_DIR=~/Projects

    alias pipi="pip install --user"
    alias pipu="pip install --user --upgrade"
    function tmuxs
    {
        tmux start-server
        tmux new-session -d -s tmuxs -n workadir

        tmux attach-session -t tmuxs
    }
fi

alias thisroot=". bin/thisroot.sh"

alias gitypo='checksave; git commit -am "typoes and minor bugs"; git push origin master'
function check() {
#    SERVERNAME= ;
#    grep -n "TODO" **/* | mvim -p --servername ${SERVERNAME} - ;
#    git diff HEAD | mvim -p --servername ${SERVERNAME} - ;
#    pylintE | mvim -p --servername ${SERVERNAME} - ;
#    lacheckE | mvim -p --servername ${SERVERNAME} - ;
    grep -n "TODO" **/* | mvim -p --servername GREP - ;
    git diff HEAD | mvim -p --servername GITDIFF - ;
    lacheckE | mvim -p --servername LACHECK - ;
    pylintE | mvim -p --servername PYLINT - ;
}
function checksave() {
    grep -n "TODO" **/* > TODO.log ;
    git diff HEAD > GITDIFF.log ;
    lacheckE > LATEXERR.log ;
    pylintE > PYERR.log ;
}

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


function upslac() { scp -r ${1} cpd@ki-ls${3}.slac.stanford.edu:${2} ;}
function downslac() { scp -r cpd@ki-ls${3}.slac.stanford.edu:${1} ${2} ;}
function upnersc() { scp -r ${1} cpd@carver.nersc.gov:/global/homes/c/cpd/${2} ;}

function lacheckE() {
    ARRAY=(**/*.tex) ;
    for i in ${ARRAY[*]};
    do
        echo $i ;
        lacheck $i ;
    done
}

function pylintE() {
    ARRAY=(**/*.py) ;
    for i in ${ARRAY[*]};
    do
        echo $i ;
        pylint -E $i ;
    done
}

function pylintA() {
    ARRAY=(**/*.py) ;
    for i in ${ARRAY[*]};
    do
        echo $i ;
        pylint $i ;
    done
}

# every time a directory changes; zsh checks if chpwd is defined and runs it
function chpwd(){ ls; }

# markdown macro
function markdown() {
    # don't call the .md, just the name before that
    perl ~/.dotfiles/Markdown.pl ${1}.md > ${1}.html ;
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
        old_sessions=$(tmux ls 2>/dev/null | egrep "^[0-9]{14}.*[0-9]+\)$" | cut -f 1 -d:)
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
# WavefrontPSF
export PYTHONPATH=${PROJECTS_DIR}/WavefrontPSF/code:$PYTHONPATH
# SpaceWarps
export PATH=$PATH:${PROJECTS_DIR}/SpaceWarps/analysis
export PYTHONPATH=$PYTHONPATH:${PROJECTS_DIR}/SpaceWarps/analysis
# cluster-z
export CLUSTERZ_DIR=${PROJECTS_DIR}/cluster-z
export PYTHONPATH=$PYTHONPATH:${PROJECTS_DIR}/cluster-z/code
# strongcnn
export PYTHONPATH=$PYTHONPATH:${PROJECTS_DIR}/strongcnn/code
# weak_sauce
export PYTHONPATH=$PYTHONPATH:${PROJECTS_DIR}/weak_sauce/code
# learnpsf
export PYTHONPATH=$PYTHONPATH:${PROJECTS_DIR}/LearnPSF/code
# osprey
if [[ $CPD_NAME == 'MAC' ]]; then
    export PYTHONPATH=$PYTHONPATH:${PROJECTS_DIR}/osprey/build/lib.macosx-10.11-intel-2.7;
elif [[ $CPD_NAME == 'KILS' ]]; then
    export PYTHONPATH=$PYTHONPATH:${PROJECTS_DIR}/osprey/build/lib.linux-x86_64-2.7;
fi

# cosmosis
if [[ $CPD_NAME == 'KILS' ]]; then
    export PYTHONPATH=$PYTHONPATH:${PROJECTS_DIR}/DES/;
fi

# caffe
export PYTHONPATH=$PYTHONPATH:${PROJECTS_DIR}/caffe/python

# miniconda
if [ $CPD_NAME = 'MAC' ]; then
    export PATH="/Users/cpd/miniconda2/bin:$PATH";
    # activate cpd environment
    source activate cpd;
fi
