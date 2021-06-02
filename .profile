# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
umask 022

# Normally, we want to put dotfiles in the home directory, so $HOME should equal $DOTFILES_HOME
# But for situations where I have to share a single login with others to a shared machine,
# try to allow setting up dotfiles in some other directory.
export DOTFILES_HOME="$(cd "$( dirname "${BASH_SOURCE[0]}")" && pwd)"

# Set PATH so it includes user's private bin if it exists
if [ -d "${HOME}/.local/bin" ] ; then
  PATH="${HOME}/.local/bin:${PATH}"
fi
if [ -d "${DOTFILES_HOME}/.bin" ] ; then
  PATH="${DOTFILES_HOME}/.bin:${PATH}"
fi
if [ -d "${HOME}/bin" ] ; then
  PATH="${HOME}/bin:${PATH}"
fi

# Set MANPATH so it includes users' private man if it exists
if [ -d "${HOME}/.local/man" ]; then
  export MANPATH="${HOME}/.local/man:${MANPATH}"
fi
if [ -d "${DOTFILES_HOME}/.man" ]; then
  export MANPATH="${DOTFILES_HOME}/.man:${MANPATH}"
fi

if command -v vim >/dev/null 2>&1; then
  export EDITOR="$(command -v vim)"
elif command -v vi >/dev/null 2>&1; then
  export EDITOR="$(command -v vi)"
fi


# Make sort, grep, etc. behave as expected.
#export LC_ALL=C


# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
