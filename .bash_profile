# ~/.bash_profile: executed by bash(1) for login shells.

# Normally, we want to put dotfiles in the home directory, so $HOME should equal $DOTFILES_HOME
# But for situations where I have to share a single login with others to a shared machine,
# try to allow setting up dotfiles in some other directory.
export DOTFILES_HOME="$(cd "$( dirname "${BASH_SOURCE[0]}")" && pwd)"

# source the users shell-independent profile if it exists
if [ -f "${DOTFILES_HOME}/.profile" ] ; then
  source "${DOTFILES_HOME}/.profile"
fi

# source the users bashrc if it exists
if [ -f "${DOTFILES_HOME}/.bashrc" ] ; then
  source "${DOTFILES_HOME}/.bashrc"
fi
