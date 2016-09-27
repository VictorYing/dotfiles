# ~/.bashrc: executed by bash(1) for interactive shells.

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Shell Options
#
# See man bash for more options...
#
# Don't wait for job termination notification
# set -o notify
#
# Don't use ^D to exit
# set -o ignoreeof
#
# Use case-insensitive filename globbing
# shopt -s nocaseglob
#
# Make bash append rather than overwrite the history on disk
shopt -s histappend
#
# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
shopt -s cdspell

# Enable regular expression globs
shopt -s extglob

# The pattern "**" in a pathname expansion will match all files
# and zero or more directories and subdirectories.
shopt -s globstar

# Check the window size after each command
shopt -s checkwinsize

#Fail when overwritting file unless explicitly forced
set -o noclobber

# Completion options
#
# These completion tuning parameters change the default behavior of bash_completion:
#
# Define to access remotely checked-out files over passwordless ssh for CVS
# COMP_CVS_REMOTE=1
#
# Define to avoid stripping description in --option=description of './configure --help'
# COMP_CONFIGURE_HINTS=1
#
# Define to avoid flattening internal contents of tar files
# COMP_TAR_INTERNAL_PATHS=1
#
# Uncomment to turn on programmable completion enhancements.
# Any completions you add in ~/.bash_completion are sourced last.
[[ -f /etc/bash_completion ]] && . /etc/bash_completion

# History Options

# Don't put duplicate lines or lines starting with whitespace in the history.
export HISTCONTROL=ignoreboth

# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:logout'
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:logout:ls' # Ignore the ls command as well

# Whenever displaying the prompt, write the previous line to disk
export PROMPT_COMMAND="history -a"

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Aliases
#
# Some people use a different file for aliases
if [ -f "${HOME}/.bash_aliases" ]; then
  source "${HOME}/.bash_aliases"
fi

# Umask
#
# /etc/profile sets 022, removing write perms to group + others.
# Set a more restrictive umask: i.e. no exec perms for others:
# umask 027
# Paranoid: neither group nor others have any perms:
umask 077

# Functions
#
# Some people use a different file for functions
if [ -f "${HOME}/.bash_functions" ]; then
  source "${HOME}/.bash_functions"
fi

# Make sort, grep, etc. behave as expected.
export LC_ALL=C

# Check if we can use SSH agent.
ssh-add -l >/dev/null 2>&1
if [ $? = 2 ]; then
    # No ssh-agent usable
    # Use existing SSH agent if possible.
    SSH_SCRIPT_DIR="~/.ssh/"
    SSH_SCRIPT=$SSH_SCRIPT_DIR"env.sh"
    if [ -e $SSH_SCRIPT ]; then
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
            ssh-add ~/.ssh/keys/!(*.pub) 2> /dev/null
        elif [ -d ~/.ssh/private ]; then
            ssh-add ~/.ssh/private/!(*.pub) 2> /dev/null
        else
            ssh-add ~/.ssh/!(*.pub) 2> /dev/null
        fi
    fi
fi
