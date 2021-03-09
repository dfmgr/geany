#!/usr/bin/env sh
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="{filename}"
VERSION="{filename}"
USER="$USER"
HOME="$HOME"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#set opts

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : {date}-git
# @Author        : {developer}
# @Contact       : {mail}
# @License       : WTFPL
# @ReadME        : {filename} --help
# @Copyright     : Copyright: (c) {year} {developer}, {company}
# @Created       : {datetime}
# @File          : {filename}
# @Description   : {description}
# @TODO          :
# @Other         :
# @Resource      :
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Check for needed applications
check_app bash || exit 1  # graphical prompt
cmd_exists bash || exit 1 # exit if not found
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set variables

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set functions
printf_color() { printf "%b" "$(tput setaf "$1" 2>/dev/null)" "\t\t$2\n" "$(tput sgr0 2>/dev/null)"; }
__help() { printf_color "4" "usage: {filename}  |  {filename} --help" && exit; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set additional variables

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# bring in user config
[ -f "$HOME/.config/{filename}/settings" ] && . "$HOME/.config/{filename}/settings"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Main application

case "$1" in
--help)
  shift 1
  __help
  ;;
--version)
  shift 1
  grep ^"# @" "$APPNAME"
  grep ^"##@" "$APPNAME"
  ;;
*)
  exec ""
  ;;
esac

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
exit $?
# end
