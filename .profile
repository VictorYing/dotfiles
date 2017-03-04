# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
umask 022

# Set PATH so it includes user's private bin if it exists
if [ -d "${HOME}/.bin" ] ; then
  PATH="${HOME}/.bin:${PATH}"
fi

# Set MANPATH so it includes users' private man if it exists
if [ -d "${HOME}/.man" ]; then
  MANPATH="${HOME}/.man:${MANPATH}"
fi

# Set INFOPATH so it includes users' private info if it exists
if [ -d "${HOME}/.info" ]; then
  INFOPATH="${HOME}/.info:${INFOPATH}"
fi

# Set LD_LIBRARY_PATH so it includes users' private lib if it exists
if [ -d "${HOME}/.lib" ]; then
  LD_LIBRARY_PATH="${HOME}/.lib:${LD_LIBRARY_PATH}"
fi


if command -v vim >/dev/null 2>&1; then
  export EDITOR="$(command -v vim)"
elif command -v vi >/dev/null 2>&1; then
  export EDITOR="$(command -v vi)"
fi

# Make sort, grep, etc. behave as expected.
export LC_ALL=C


# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


aklog -cell csail.mit.edu

