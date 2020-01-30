# Lines configured by zsh-newuser-install
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
# beeping is annoying
unsetopt beep
# be in vim mode
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename ${HOME}/.zshrc

autoload -Uz compinit
compinit
# End of lines added by compinstall


# history options
HISTFILE=${HOME}/.histfile
HISTSIZE=10000
SAVEHIST=$HISTSIZE
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
# Killer: share history between multiple shells
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

# my zshrc
# configure jk to go into normal mode
# plus a couple other useful ones.
bindkey -M viins jk vi-cmd-mode
bindkey -M vicmd -s ",h" "^"
bindkey -M vicmd -s ",l" "$"
# note that / will let you search in command history, with n and N

# useful renaming within zsh
# example zmv command to replace all spaces in filenames with underscores:
# zmv '* *' '$f:gs/ /_'
autoload -Uz zmv

# load up zcalc. E and PI are defined, and common math funcs
autoload -Uz zcalc

# command autosuggestions
source ~/.dotfiles/zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# accept the suggestion with double comma
bindkey ',,' autosuggest-accept
# Set ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE to an integer value to disable
# autosuggestion for large buffers. The default is unset, which means that
# autosuggestion will be tried for any buffer size. Recommended value is 20.
# This can be useful when pasting large amount of text in the terminal, to
# avoid triggering autosuggestion for too long strings.
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
# set the color to something that will work with both my light and dark background settings
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=4'

#parses .dircolors and makes env var for GNU ls
directory_colors=${HOME}/.dircolors

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
export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# added by travis gem
[ -f /Users/cpd/.travis/travis.sh ] && source /Users/cpd/.travis/travis.sh

# should this really be here and not in env files?
export PROJECTS_DIR=${HOME}/Projects
# using the PROJECTS_DIR from above, define some variables
export IPYTHON_NOTEBOOK_DIR=$PROJECTS_DIR

# every time a directory changes; zsh checks if chpwd is defined and runs it 
function chpwd(){ ls; }

#####
# Aliases shared across all computers
#####
function pdfmerge() { gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -sOutputFile=$@ ; }
alias vims='vim -S Session.vim'
alias dua='du -h | sort -hr'
alias grep='grep --color'

function vimwiki() {
    cd ${HOME}/Projects/vimwiki
    # vim -S Session.vim -c "colorscheme solarized | set background=light"
    vim -S Session.vim
}

# a useful command for fetching all git branches in a repo
function fetch(){
    # git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done
    for remote in `git branch -r`; do git branch --track ${remote#origin/} $remote; done
    git fetch --all
    git pull --all
}
# function to update all submodules in repo
function subupdate(){
    git pull --recurse-submodules && git submodule update --recursive
}
# function that does all the requisite testing for jekyll blogging
function blog() {
    cd ${HOME}/Projects/cpadavis.github.io
    bundle update
    bundle exec jekyll build
    bundle exec jekyll serve
}

# kill swap files
function ksw() {
    for X in p o
    do
        rm .*.sw$X
    done
}


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

#####
# various ssh things
# TODO: set default
#####
function gcloudip(){
    ssh -XY -i ~/.ssh/instance_key chris@${1}
}
function gcp(){
    gcloud compute --project "dl-security-test" ssh --zone "${2:=us-central1-c}" "${3:=chris}@${1:=chris-dev-1804-2}" --ssh-flag="-CY"
}
function gcpstart(){
    gcloud compute instances start --project "dl-security-test" --zone "${2:=us-central1-c}" "${1:=chris-dev-1804-2}"
}
function gcpstop(){
    gcloud compute instances stop --project "dl-security-test" --zone "${2:=us-central1-c}" "${1:=chris-dev-1804-2}"
}
alias gcphttp='python3 -m http.server 8888'
function gscpd(){
    gcloud compute --project "dl-security-test" scp --zone "${4:=us-central1-c}" "chris@${3:=chris-dev-1804-2}:${1}" ${2}
}
function gscpu(){
    gcloud compute --project "dl-security-test" scp --zone "${4:=us-central1-c}" ${1} "chris@${3:=chris-dev-1804-2}:${2}"
}
function jup(){
    if it2check ; then it2setcolor preset "base16-github.light"; fi
    gcloud compute --project "dl-security-test" ssh --zone "${2:=us-central1-c}" "${3:=chris}@${1:=chris-dev-1804-2}" --ssh-flag="-CY -L localhost:8888:localhost:8888"
}
function gpu(){
    if it2check ; then it2setcolor preset 'base16-solarized.dark'; fi
    gcloud compute --project "dl-security-test" ssh --zone "${2:=us-central1-c}" "${3:=chris}@${1:=chris-dev-1804-2}" --ssh-flag="-CY -L localhost:16006:localhost:6006"
}



function rpi(){
    ssh -Y pi@${1=192.168.1.128}
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

#####
# tmux related
#####

# kick off other terminals
alias detach='tmux detach -a'
alias attach='tmux attach -d'

function tmuxk() {
    # Kill defunct sessions first
    old_sessions=($(tmux ls 2>/dev/null | egrep "^[0-9]{14}.*[0-9]+\)$" | cut -f 1 -d:))
    for old_session_id in ${old_sessions[*]}; do
        echo killing $old_session_id
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

    base_session=tmuxs
    tmux_nb=$(trim `tmux ls | grep "^$base_session" | wc -l`)
    if [[ "$tmux_nb" == "0" ]]; then
        tmuxs
    else
        if [[ -z "$TMUX" ]]; then
            tmux has-session -t $base_session 2>/dev/null
            if [ "$?" -eq 1 ] ; then
                tmuxs
            else
                # Kill defunct sessions first
                old_sessions=($(tmux ls 2>/dev/null | egrep "^[0-9]{14}" | cut -f 1 -d:))
                for old_session_id in $old_sessions; do
                    tmux kill-session -t $old_session_id
                done

                echo "Launching copy of base session $base_session ..."
                # Session is is date and time to prevent conflict
                session_id=`date +%Y%m%d%H%M%S`
                # Create a new session (without attaching it) and link to base session
                # to share windows
                tmux new-session -d -t $base_session -s $session_id
                # Attach to the new session
                tmux attach-session -t $session_id
                # When we detach from it, kill the session
                tmux kill-session -t $session_id
            fi
        else
            echo 'Already in a tmux session.'
        fi
    fi
}

# tmux split and execute command
function tmv() {
    tmux split-window -vd "$*"
}
function tmh() {
    tmux split-window -hd "$*"
}

function tmuxs
{
    # I like my tmux to be in a certain color scheme. We can ensure that with iterm2

    if [[ "$CPD_NAME" == "MB_PREMERGE" ]]; then
        # TODO: might need this for DESCARTES
        conda deactivate
    fi

    tmux start-server
    tmux new-session -d -s tmuxs

    # create notebook in window 0
    tmux rename-window notebook
    # tmux send-keys "notebook" C-m
    tmux send-keys "notebook"

    if [[ "$CPD_NAME" == "GCLOUD" ]]; then
        tmux split-window -v
        tmux select-pane -t 1
        tmux send-keys "rustivus" C-m
    fi

    if [[ "$CPD_NAME" == "MB" || "$CPD_NAME" == "DESCARTES" ]]; then
        tmux new-window
        tmux rename-window vimwiki
        tmux send-keys "vimwiki" C-m
    fi

    # create new window. with no -d flag, this is automatically chosen
    tmux new-window

    # start session
    tmux attach-session -t tmuxs
}

# TODO: revisit this
function tgpu(){

    # I like my tmux to be in a certain color scheme. We can ensure that with iterm2
    base_session=tgpu
    tmux start-server
    tmux new-session -d -s $base_session

    # make grid of 2 x 2 windows
    tmux split-window -h
    tmux split-window -v
    tmux split-window -v
    tmux select-pane -t 0
    tmux split-window -v

    # tmux send-keys -t $base_session:0.0 "echo train" C-m
    # tmux send-keys -t $base_session:0.1 "echo analyze" C-m
    tmux send-keys -t $base_session:0.2 "htop" C-m
    tmux send-keys -t $base_session:0.3 "watch nvidia-smi" C-m
    tmux send-keys -t $base_session:0.4 "tensorboard --logdir="
    tmux attach-session -t $base_session

}

alias closeport='lsof -ti:${1:=8888} | xargs kill -9'

# syntax highlighting. It has to go at the end of the file for Reasons
source ~/.dotfiles/zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
# To have commands starting with `rm -rf` in red:
ZSH_HIGHLIGHT_PATTERNS=('rm -rf *' 'fg=white,bold,bg=red')

# I do not understand why this works in .zshrc but not in .zshenv
if [[ "$CPD_NAME" == "DESCARTES" ]]; then
    source activate
fi

if [[ "$CPD_NAME" == "MB" ]]; then
    # added by Anaconda3 2019.10 installer
    # >>> conda init >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$(CONDA_REPORT_ERRORS=false '/Users/cpd/opt/anaconda3/bin/conda' shell.bash hook 2> /dev/null)"
    if [ $? -eq 0 ]; then
        \eval "$__conda_setup"
    else
        if [ -f "/Users/cpd/opt/anaconda3/etc/profile.d/conda.sh" ]; then
            . "/Users/cpd/opt/anaconda3/etc/profile.d/conda.sh"
            CONDA_CHANGEPS1=false conda activate base
        else
            \export PATH="/Users/cpd/opt/anaconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda init <<<
    conda activate py37
fi
