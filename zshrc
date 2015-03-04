

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
eval "$(dircolors $d)"

# change prompt colors
autoload -U colors && colors
PS1="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "

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
alias number="echo $(ls -1 --file-type | grep -v '/$' | wc -l)"
alias pylab='ipython --profile=nbserver'
alias iconsole='ipython console --profile=nbserver --existing'
alias bjobl="bjobs -l | less"
alias bjobr='bjobs | awk '\''{if($3 != "PEND") print ;}'\'' | less'
if [ -z "$SSH_CONNECTION" ]; then
    alias notebook="ipython notebook --profile=nbserver"
    alias cs231n="ipython notebook --profile=cs231n"
else
    export IPYNOTEBOOKIP=`echo $SSH_CONNECTION | awk '{print $3}'`
    alias notebook="ipython notebook --profile=nbserver --ip=${IPYNOTEBOOKIP}"
fi

# check if we have mvim else just stick to vim
if hash mvim 2>/dev/null; then
    alias vim='mvim -v'
fi
alias ls='ls -hFa --color'
alias dua='du -ah --max-depth=1 | sort -nr'
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
alias nersc='ssh -Y cpd@carver.nersc.gov'
function slac(){ ssh -Y cpd@ki-ls${1:=10}.slac.stanford.edu ;}
alias rye='ssh -Y cpd@ry01.stanford.edu'

alias trivialAccess='trivialAccess \-u cpd \-p cpd70chips -d dessci'

# some key difs between my mac and kils
if [ $CPD_NAME = 'MAC' ]; then
    alias pipi='sudo -E pip install'
    alias pipu='sudo -E pip install --upgrade'
    function tmuxs
    {
        tmux start-server
        tmux new-session -d -s tmuxs -n irssi
        tmux new-window -t tmuxs:2 -n nb
        tmux new-window -t tmuxs:3 -n slac
        tmux new-window -t tmuxs:4 -n workadirk

        # send commands to windows
        tmux send-keys -t tmuxs:1 "irssi" C-m
        tmux send-keys -t tmuxs:2 "notebook &" C-m
        tmux send-keys -t tmuxs:3 "slac" C-m

        tmux select-window -t tmuxs:4
        tmux attach-session -t tmuxs
        ## # When we detach from it, kill the session
        ## tmux kill-session -t tmuxs
    }
elif [ $CPD_NAME = 'KILS' ]; then
    alias pipi="pip install --user"
    alias pipu="pip install --user --upgrade"
    function tmuxs
    {
        tmux start-server
        tmux new-session -d -s tmuxs -n notebook
        tmux new-window -t tmuxs:2 -n mongod
        tmux new-window -t tmuxs:3 -n workadirk

        tmux send-keys -t tmuxs:1 "notebook &" C-m
        tmux send-keys -t tmuxs:2 "cd $SWAP/mongo/; mongod --dbpath . &" C-m

        tmux select-window -t tmuxs:3
        tmux attach-session -t tmuxs
    }
    function im() { python -c "import matplotlib.pyplot as plt; plt.imshow(plt.imread('${1}')); plt.show()" & ;}
    function pdf() { xpdf -z page ${1} & ;}
    function roopsfex() { /nfs/slac/g/ki/ki22/roodman/DESDM/eups/packages/Linux64/psfex/3.17.0+0/bin/psfex ${1} -c /u/ec/roodman/Astrophysics/PSF/desdm-plus.psfex -OUTCAT_NAME ${2} ; }
else
    alias pipi="pip install --user"
    alias pipu="pip install --user --upgrade"
    function tmuxs
    {
        tmux start-server
        tmux new-session -d -s tmuxs -n notebook
        tmux new-window -t tmuxs:2 -n workadirk

        tmux send-keys -t tmuxs:1 "notebook &" C-m

        tmux select-window -t tmuxs:2
        tmux attach-session -t tmuxs
    }
fi

alias thisroot=". bin/thisroot.sh"

alias gitypo='checksave | git commit -am "typoes and minor bugs"; git push origin master'
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
        # focus session on irssi window
        tmux select-window -t $session_id:1
        # Attach to the new session
        tmux attach-session -t $session_id
        # When we detach from it, kill the session
        tmux kill-session -t $session_id
    fi
}
