#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
PROG="{filename}"
VERSION="{version}"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"
SRC_DIR="${BASH_SOURCE%/*}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#set opts

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#set opts

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
{fileheader}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Check for needed applications
cmd_exists bash || exit 1 # exit if not found
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set variables

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set functions
printf_color() { printf "%b" "$(tput setaf "$1" 2>/dev/null)" "\t\t$2\n" "$(tput sgr0 2>/dev/null)"; }
__version() {
  grep ^"# @" "GEN_SCRIPT_REPLACE_FILENAME"
  grep ^"##@" "GEN_SCRIPT_REPLACE_FILENAME"
}
__help() {
  printf_color "4" "$(grep ^"# @Description" "GEN_SCRIPT_REPLACE_FILENAME | grep ' : " || GEN_SCRIPT_REPLACE_FILENAME help)"
  printf_color "4" "usage: GEN_SCRIPT_REPLACE_FILENAME  |  GEN_SCRIPT_REPLACE_FILENAME --version"
  exit
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set additional variables

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# bring in user config
[ -f "$HOME/.config/GEN_SCRIPT_REPLACE_FILENAME/settings" ] && . "$HOME/.config/GEN_SCRIPT_REPLACE_FILENAME/settings"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Main application
case "$1" in
--help | -h)
  shift 1
  __help
  ;;
--version | -v)
  shift 1
  __version
  ;;
*)
  exec ""
  ;;
esac
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
exit $?
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# end
