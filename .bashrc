# ~/.bashrc: executed by bash(1) for interactive shells.


# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return


# Normally, we want to put dotfiles in the home directory, so $HOME should equal $DOTFILES_HOME
# But for situations where I have to share a single login with others to a shared machine,
# try to allow setting up dotfiles in some other directory.
export DOTFILES_HOME="$(cd "$( dirname "${BASH_SOURCE[0]}")" && pwd)"


# Miscellaneous shell options
# See man bash for more options...

# Don't wait for job termination notification
set -o notify

# Don't use ^D to exit
set -o ignoreeof

# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
shopt -s cdspell

# Check the window size after each command
shopt -s checkwinsize

#Fail when overwritting file unless explicitly forced
set -o noclobber


# Glob options

# Enable regular expression globs
shopt -s extglob

# The pattern "**" in a pathname expansion will match all files
# and zero or more directories and subdirectories.
shopt -s globstar

# If a pattern fails to match, report an error
#shopt -s failglob

# Include hidden files
shopt -s dotglob

# Exclude . and .. from matches
GLOBIGNORE=${GLOBIGNORE:+$GLOBIGNORE:}.:..

# Use case-insensitive filename globbing
# shopt -s nocaseglob


# Completion options

# These completion tuning parameters change the default behavior of bash_completion:

# Define to access remotely checked-out files over passwordless ssh for CVS
# COMP_CVS_REMOTE=1

# Define to avoid stripping description in --option=description of './configure --help'
# COMP_CONFIGURE_HINTS=1

# Define to avoid flattening internal contents of tar files
# COMP_TAR_INTERNAL_PATHS=1

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [ -x /usr/bin/mint-fortune ]; then
     /usr/bin/mint-fortune
fi

# Custom completion
if [ -d ${HOME}/.bash/completion ]; then
  for file in  ${HOME}/.bash/completion/*; do
    source $file
  done
fi


# History Options

# Make bash append rather than overwrite the history on disk
shopt -s histappend

# don't put duplicate lines or lines starting with whitespace in the history.
HISTCONTROL=ignoreboth

# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
HISTIGNORE=$'[ \t]*:&:[fb]g:exit:logout'
# HISTIGNORE=$'[ \t]*:&:[fb]g:exit:logout:ls' # Ignore the ls command as well

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=200000

# Whenever displaying the prompt, write the previous line to disk
PROMPT_COMMAND="history -a"

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


# Prompt and title

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm|xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    if [[ ${EUID} == 0 ]] ; then
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\h\[\033[01;36m\]:\W\[\033[00m\]\$ '
    else
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\]\$ '
    fi
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
git_prompt_sh="/usr/lib/git-core/git-sh-prompt" # Debian/Ubuntu packages install a copy here
if [[ ! -f "${git_prompt_sh}" ]]; then
    git_prompt_sh="/usr/share/git-core/contrib/completion/git-prompt.sh" # CentOS
fi
if [[ -f "${git_prompt_sh}" ]]; then
    source "${git_prompt_sh}"  # This defines the __git_ps1 bash function
    # See substring replacement in the Bash Advanced Scripting Guide
    # https://tldp.org/LDP/abs/html/string-manipulation.html
    # Note: Bash version 4.3 or greater allows using quotes as escape
    # characters in the replacement string during pattern substitution
    # https://github.com/bminor/bash/blob/ce23728687ce9e584333367075c9deef413553fa/COMPAT#L370-L373
    # This would allow us to write:
    #PS1="${PS1/%'\$ '/'$(__git_ps1 " (%s)")\$ '}"
    # But, for compability with Bash 4.2 (or older), e.g., on CentOS 7, we must
    # backslash-escape all special characters in the replacement string:
    PS1="${PS1/%'\$ '/\$(__git_ps1 \" (%s)\")\\\$ }"

    GIT_PS1_SHOWDIRTYSTATE="true"  # This is slow for large repos: git config --local bash.showDirtyState false
    GIT_PS1_SHOWSTASHSTATE="true"
    GIT_PS1_SHOWUNTRACKEDFILES="true"  # This is slow for large repos: git config --local bash.showUntrackedFiles false
    GIT_PS1_SHOWUPSTREAM="auto"
    GIT_PS1_DESCRIBE_STYLE="branch"
    GIT_PS1_SHOWCOLORHINTS="true"
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac





# Umask
#
# /etc/profile sets 022, removing write perms to group + others.
umask 022
# Set a more restrictive umask: i.e. no exec perms for others:
# umask 027
# Paranoid: neither group nor others have any perms:
# umask 077


# Aliases
#
# Some people use a different file for aliases
if [ -f "${DOTFILES_HOME}/.bash/aliases" ]; then
  source "${DOTFILES_HOME}/.bash/aliases"
fi

# Functions
#
# Some people use a different file for functions
if [ -f "${DOTFILES_HOME}/.bash/functions" ]; then
  source "${DOTFILES_HOME}/.bash/functions"
fi

# Check if we can use SSH agent.
ssh-add -l >/dev/null 2>&1
if [ $? = 2 ]; then
    # No ssh-agent usable
    # Use existing SSH agent if possible.
    SSH_SCRIPT_DIR="$HOME/.ssh/"
    SSH_SCRIPT="${SSH_SCRIPT_DIR}${HOSTNAME}_env.sh"
    if [ -f $SSH_SCRIPT ]; then
        source $SSH_SCRIPT > /dev/null
    fi
    # Check if we can use SSH agent.
    ssh-add -l >/dev/null 2>&1
    if [ $? = 2 ]; then
        # No ssh-agent usable
        # Kill existing ssh-agents
        pkill -u $USER -f ssh-agent

        # Start new SSH agent and record the information to use it in a file
        mkdir -p $SSH_SCRIPT_DIR
        # >| allows output redirection to over-write files if no clobber is set
        ssh-agent -s >| $SSH_SCRIPT
        source $SSH_SCRIPT > /dev/null

        # Add SSH keys
        if [ -d ~/.ssh/keys ]; then
            ssh-add ~/.ssh/keys/id!(*.pub) 2> /dev/null
        elif [ -d ~/.ssh/private ]; then
            ssh-add ~/.ssh/private/id!(*.pub) 2> /dev/null
        else
            ssh-add ~/.ssh/id!(*.pub) 2> /dev/null
        fi
    fi
fi

# Check if we can use X server.
if [ -z "${DISPLAY+x}" ]; then
  # https://github.com/microsoft/WSL/issues/4555#issuecomment-539674785
  #if [ $(grep -oE 'gcc version ([0-9]+)' /proc/version | awk '{print $3}') -gt 5 ]; then
  if [[ -n "$WSL_INTEROP" ]]; then
    # https://github.com/microsoft/WSL/issues/4106
    # https://stackoverflow.com/q/61110603
    export DISPLAY="$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0"
  fi
fi
X_SCRIPT="${DOTFILES_HOME}/.${HOSTNAME}_x_env.sh"
xset q >/dev/null 2>&1
if [ $? != 0 ]; then
  # No X server reachable
  unset DISPLAY
  if [ -f "$X_SCRIPT" ]; then
    source "$X_SCRIPT"
  fi
else
  # We can reach an X server
  TMP_X_SCRIPT="/tmp/${USER}_x.sh"
  echo "export DISPLAY=${DISPLAY}" >| "$TMP_X_SCRIPT"
  if ! cmp -s "$X_SCRIPT" "$TMP_X_SCRIPT"; then
    echo "Saving new ${X_SCRIPT}."
    if [ -f "$X_SCRIPT" ]; then
      mv -f "$X_SCRIPT" "${X_SCRIPT}.bak"
    fi
    mv "$TMP_X_SCRIPT" "$X_SCRIPT"
  else
    echo "${X_SCRIPT} already up to date."
    rm -f "$TMP_X_SCRIPT"
  fi
fi

