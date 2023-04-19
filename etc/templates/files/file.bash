#!/usr/bin/env bash
# shellcheck shell=bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  {date}-git
# @@Author           :  {developer}
# @@Contact          :  {mail}
# @@License          :  WTFPL
# @@ReadME           :  {filename} --help
# @@Copyright        :  Copyright: (c) {year} {developer}, {company}
# @@Created          :  {datetime}
# @@File             :  {filename}
# @@Description      :  {description}
# @@Changelog        :  newScript
# @@TODO             :  Refactor code
# @@Other            :  
# @@Resource         :  
# @@Terminal App     :  no
# @@sudo/root        :  no
# @@Template         :  shell/bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="$(basename "$0" 2>/dev/null)"
VERSION="{date}-git"
HOME="${USER_HOME:-$HOME}"
USER="${SUDO_USER:-$USER}"
RUN_USER="${SUDO_USER:-$USER}"
SCRIPT_SRC_DIR="${BASH_SOURCE%/*}"
GEN_SCRIPT_REPLACE_ENV_REQUIRE_SUDO="${GEN_SCRIPT_REPLACE_ENV_REQUIRE_SUDO:-GEN_SCRIPT_REPLACE_SUDO}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Reopen in a terminal
#if [ ! -t 0 ] && { [ "$1" = --term ] || [ $# = 0 ]; }; then { [ "$1" = --term ] && shift 1 || true; } && TERMINAL_APP="TRUE" myterminal -e "$APPNAME $*" && exit || exit 1; fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Initial debugging
[ "$1" = "--debug" ] && set -x && export SCRIPT_OPTS="--debug" && export _DEBUG="on"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Disables colorization
[ "$1" = "--raw" ] && export SHOW_RAW="true"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# pipes fail
set -o pipefail
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Import functions
CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
SCRIPTSFUNCTDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}/functions"
SCRIPTSFUNCTFILE="${SCRIPTSAPPFUNCTFILE:-testing.bash}"
SCRIPTSFUNCTURL="${SCRIPTSAPPFUNCTURL:-https://github.com/dfmgr/installer/raw/GEN_SCRIPT_REPLACE_DEFAULT_BRANCH/functions}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -f "$PWD/$SCRIPTSFUNCTFILE" ]; then
  . "$PWD/$SCRIPTSFUNCTFILE"
elif [ -f "$SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE" ]; then
  . "$SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE"
else
  echo "Can not load the functions file: $SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE" 1>&2
  exit 1
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Options are: *_install
# desktopmgr devenvmgr dfmgr dockermgr fontmgr iconmgr
#   pkmgr system systemmgr thememgr user wallpapermgr
user_install && __options "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Send all output to /dev/null
__devnull() {
  tee &>/dev/null && GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=0 || GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=1
  return ${GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -'
# Send errors to /dev/null
__devnull2() {
  [ -n "$1" ] && local cmd="$1" && shift 1 || return 1
  eval $cmd "$*" 2>/dev/null && GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=0 || GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=1
  return ${GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -'
# See if the executable exists
__cmd_exists() {
  GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=0
  [ -n "$1" ] && local GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS="" || return 0
  for cmd in "$@"; do
    builtin command -v "$cmd" &>/dev/null && GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS+=$(($GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS + 0)) || GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS+=$(($GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS + 1))
  done
  [ $GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS -eq 0 ] || GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=3
  return ${GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Check for a valid internet connection
__am_i_online() {
  local GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=0
  curl -q -LSsfI --max-time 1 --retry 0 "${1:-http://1.1.1.1}" 2>&1 | grep -qi 'server:.*cloudflare' || GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=4
  return ${GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# colorization
if [ "$SHOW_RAW" = "true" ]; then
  printf_color() { printf '%b' "$1" | tr -d '\t' | sed '/^%b$/d;s,\x1B\[ 0-9;]*[a-zA-Z],,g'; }
else
  printf_color() { printf "%b" "$(tput setaf "${2:-7}" 2>/dev/null)" "$1" "$(tput sgr0 2>/dev/null)"; }
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Additional printf_ colors
__printf_head() { printf_blue "$1"; }
__printf_opts() { printf_purple "$1"; }
__printf_line() { printf_cyan "$1"; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# output version
__version() { printf_cyan "$VERSION"; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# list options
__list_options() {
  printf_color "$1: " "$5"
  echo -ne "$2" | sed 's|:||g;s/'$3'/ '$4'/g' | tr '\n' ' '
  printf_newline
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# create the config file
__gen_config() {
  local NOTIFY_CLIENT_NAME="$APPNAME"
  if [ "$INIT_CONFIG" != "TRUE" ]; then
    printf_blue "Generating the config file in"
    printf_cyan "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE"
  fi
  [ -d "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR" ] || mkdir -p "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR"
  [ -d "$GEN_SCRIPT_REPLACE_ENV_CONFIG_BACKUP_DIR" ] || mkdir -p "$GEN_SCRIPT_REPLACE_ENV_CONFIG_BACKUP_DIR"
  [ -f "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE" ] &&
    cp -Rf "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE" "$GEN_SCRIPT_REPLACE_ENV_CONFIG_BACKUP_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE.$$"
  cat <<EOF >"$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE"
# Settings for {filename}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Color Settings
GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_1="${GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_1:-}"
GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_2="${GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_2:-}"
GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_GOOD="${GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_GOOD:-}"
GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_ERROR="${GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_ERROR:-}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Notification Settings
GEN_SCRIPT_REPLACE_ENV_NOTIFY_ENABLED="${GEN_SCRIPT_REPLACE_ENV_NOTIFY_ENABLED:-}"
GEN_SCRIPT_REPLACE_ENV_GOOD_NAME="${GEN_SCRIPT_REPLACE_ENV_GOOD_NAME:-}"
GEN_SCRIPT_REPLACE_ENV_ERROR_NAME="${GEN_SCRIPT_REPLACE_ENV_ERROR_NAME:-}"
GEN_SCRIPT_REPLACE_ENV_GOOD_MESSAGE="${GEN_SCRIPT_REPLACE_ENV_GOOD_MESSAGE:-}"
GEN_SCRIPT_REPLACE_ENV_ERROR_MESSAGE="${GEN_SCRIPT_REPLACE_ENV_ERROR_MESSAGE:-}"
GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_NAME="${GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_NAME:-}"
GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_ICON="${GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_ICON:-}"
GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_URGENCY="${GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_URGENCY:-}"

EOF
  if builtin type -t __gen_config_local | grep -q 'function'; then __gen_config_local; fi
  if [ -f "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE" ]; then
    [ "$INIT_CONFIG" = "TRUE" ] || printf_green "Your config file for $APPNAME has been created"
    . "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE"
    GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=0
  else
    printf_red "Failed to create the config file"
    GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=1
  fi
  return ${GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Help function - Align to 50
__help() {
  __printf_head "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  __printf_opts "$APPNAME: {description} - $VERSION"
  __printf_head "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  __printf_line "Usage: $APPNAME [options] [commands]"
  __printf_line " - "
  __printf_line " - "
  __printf_line "--dir                           - Sets the working directory"
  __printf_head "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  __printf_opts "Other Options"
  __printf_head "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  __printf_line "--help                          - Shows this message"
  __printf_line "--config                        - Generate user config file"
  __printf_line "--version                       - Show script version"
  __printf_line "--options                       - Shows all available options"
  __printf_line "--debug                         - Enables script debugging"
  __printf_line "--raw                           - Removes all formatting on output"
  __printf_head "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__grep() { grep "$@" 2>/dev/null; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Is current user root
__user_is_root() {
  { [ $(id -u) -eq 0 ] || [ $EUID -eq 0 ] || [ "$WHOAMI" = "root" ]; } && return 0 || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Is current user not root
__user_is_not_root() {
  { [ $(id -u) -eq 0 ] || [ $EUID -eq 0 ] || [ "$WHOAMI" = "root" ]; } && return 1 || return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Check if user is a member of sudo
__sudo_group() {
  grep -s "${1:-$USER}" "/etc/group" | grep -Eq 'wheel|adm|sudo' || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# # Get sudo password
__sudoask() {
  ask_for_password sudo true && return 0 || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Run sudo
__sudorun() {
  __sudoif && __cmd_exists sudo && sudo -HE "$@" || { __sudoif && eval "$@"; }
  return $?
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Test if user has access to sudo
__can_i_sudo() {
  (sudo -vn && sudo -ln) 2>&1 | grep -vq 'may not' >/dev/null && return 0
  __sudo_group "${1:-$USER}" || __sudoif || __sudo true &>/dev/null || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# User can run sudo
__sudoif() {
  __user_is_root && return 0
  __can_i_sudo "${RUN_USER:-$USER}" && return 0
  __user_is_not_root && __sudoask && return 0 || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Run command as root
requiresudo() {
  if [ "$GEN_SCRIPT_REPLACE_ENV_REQUIRE_SUDO" = "yes" ] && [ -z "$GEN_SCRIPT_REPLACE_ENV_REQUIRE_SUDO_RUN" ]; then
    export GEN_SCRIPT_REPLACE_ENV_REQUIRE_SUDO="no"
    export GEN_SCRIPT_REPLACE_ENV_REQUIRE_SUDO_RUN="true"
    __sudo "$@"
    exit $?
  else
    return 0
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Execute sudo
__sudo() {
  CMD="${1:-echo}" && shift 1
  CMD_ARGS="${*:--e "${RUN_USER:-$USER}"}"
  SUDO="$(builtin command -v sudo 2>/dev/null || echo 'eval')"
  [ "$(basename "$SUDO" 2>/dev/null)" = "sudo" ] && OPTS="--preserve-env=PATH -HE"
  if __sudoif; then
    export PATH="$PATH"
    $SUDO ${OPTS:-} $CMD $CMD_ARGS && true || false
    GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=$?
  else
    printf '%s\n' "This requires root to run"
    GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=1
  fi
  return ${GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS:-1}
}
# End of sudo functions
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__trap_exit() {
  GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=${GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS:-$?}
  [ -f "$GEN_SCRIPT_REPLACE_ENV_TEMP_FILE" ] && rm -Rf "$GEN_SCRIPT_REPLACE_ENV_TEMP_FILE" &>/dev/null
  if builtin type -t __trap_exit_local | grep -q 'function'; then __trap_exit_local; fi
  return $GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# User defined functions

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# User defined variables/import external variables

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Application Folders
GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=0
GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE="${GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE:-settings.conf}"
GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR="${GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR:-$HOME/.config/myscripts/$APPNAME}"
GEN_SCRIPT_REPLACE_ENV_CONFIG_BACKUP_DIR="${GEN_SCRIPT_REPLACE_ENV_CONFIG_BACKUP_DIR:-$HOME/.local/share/myscripts/$APPNAME/backups}"
GEN_SCRIPT_REPLACE_ENV_LOG_DIR="${GEN_SCRIPT_REPLACE_ENV_LOG_DIR:-$HOME/.local/log/$APPNAME}"
GEN_SCRIPT_REPLACE_ENV_RUN_DIR="${GEN_SCRIPT_REPLACE_ENV_RUN_DIR:-$HOME/.local/run/system_scripts/$GEN_SCRIPT_REPLACE_ENV_SCRIPTS_PREFIX}"
GEN_SCRIPT_REPLACE_ENV_TEMP_DIR="${GEN_SCRIPT_REPLACE_ENV_TEMP_DIR:-$HOME/.local/tmp/system_scripts/$APPNAME}"
GEN_SCRIPT_REPLACE_ENV_CACHE_DIR="${GEN_SCRIPT_REPLACE_ENV_CACHE_DIR:-$HOME/.cache/$APPNAME}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Color Settings
GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_1="${GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_1:-33}"
GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_2="${GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_2:-5}"
GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_GOOD="${GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_GOOD:-2}"
GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_ERROR="${GEN_SCRIPT_REPLACE_ENV_OUTPUT_COLOR_ERROR:-1}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Notification Settings
GEN_SCRIPT_REPLACE_ENV_NOTIFY_ENABLED="${GEN_SCRIPT_REPLACE_ENV_NOTIFY_ENABLED:-yes}"
GEN_SCRIPT_REPLACE_ENV_GOOD_NAME="${GEN_SCRIPT_REPLACE_ENV_GOOD_NAME:-Great:}"
GEN_SCRIPT_REPLACE_ENV_ERROR_NAME="${GEN_SCRIPT_REPLACE_ENV_ERROR_NAME:-Error:}"
GEN_SCRIPT_REPLACE_ENV_GOOD_MESSAGE="${GEN_SCRIPT_REPLACE_ENV_GOOD_MESSAGE:-No errors reported}"
GEN_SCRIPT_REPLACE_ENV_ERROR_MESSAGE="${GEN_SCRIPT_REPLACE_ENV_ERROR_MESSAGE:-Errors were reported}"
GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_NAME="${GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_NAME:-$APPNAME}"
GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_ICON="${GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_ICON:-notification-new}"
GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_URGENCY="${GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_URGENCY:-normal}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Additional Variables

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Generate config files
[ -f "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE" ] ||
  [ "$*" = "--config" ] || INIT_CONFIG="${INIT_CONFIG:-TRUE}" __gen_config ${SETARGS:-$@}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Import config
[ -f "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE" ] &&
  . "$GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR/$GEN_SCRIPT_REPLACE_ENV_CONFIG_FILE"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Ensure Directories exist
[ -d "$GEN_SCRIPT_REPLACE_ENV_RUN_DIR" ] || mkdir -p "$GEN_SCRIPT_REPLACE_ENV_RUN_DIR" |& __devnull
[ -d "$GEN_SCRIPT_REPLACE_ENV_LOG_DIR" ] || mkdir -p "$GEN_SCRIPT_REPLACE_ENV_LOG_DIR" |& __devnull
[ -d "$GEN_SCRIPT_REPLACE_ENV_TEMP_DIR" ] || mkdir -p "$GEN_SCRIPT_REPLACE_ENV_TEMP_DIR" |& __devnull
[ -d "$GEN_SCRIPT_REPLACE_ENV_CACHE_DIR" ] || mkdir -p "$GEN_SCRIPT_REPLACE_ENV_CACHE_DIR" |& __devnull
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
GEN_SCRIPT_REPLACE_ENV_TEMP_FILE="${GEN_SCRIPT_REPLACE_ENV_TEMP_FILE:-$(mktemp $GEN_SCRIPT_REPLACE_ENV_TEMP_DIR/XXXXXX 2>/dev/null)}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup trap to remove temp file
trap '__trap_exit' EXIT
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup notification function
__notifications() {
  __cmd_exists notifications || return
  [ "$GEN_SCRIPT_REPLACE_ENV_NOTIFY_ENABLED" = "yes" ] || return
  [ "$SEND_NOTIFICATION" = "no" ] && return
  (
    set +x
    export SCRIPT_OPTS="" _DEBUG=""
    export NOTIFY_GOOD_MESSAGE="${NOTIFY_GOOD_MESSAGE:-$GEN_SCRIPT_REPLACE_ENV_GOOD_MESSAGE}"
    export NOTIFY_ERROR_MESSAGE="${NOTIFY_ERROR_MESSAGE:-$GEN_SCRIPT_REPLACE_ENV_ERROR_MESSAGE}"
    export NOTIFY_CLIENT_ICON="${NOTIFY_CLIENT_ICON:-$GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_ICON}"
    export NOTIFY_CLIENT_NAME="${NOTIFY_CLIENT_NAME:-$GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_NAME}"
    export NOTIFY_CLIENT_URGENCY="${NOTIFY_CLIENT_URGENCY:-$GEN_SCRIPT_REPLACE_ENV_NOTIFY_CLIENT_URGENCY}"
    notifications "$@"
    retval=$?
    return $retval
  ) |& __devnull &
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set custom actions

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Argument/Option settings
SETARGS=("$@")
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SHORTOPTS=""
SHORTOPTS+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
LONGOPTS="completions:,config,debug,dir:,help,options,raw,version,silent"
LONGOPTS+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ARRAY=""
ARRAY+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
LIST=""
LIST+=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup application options
setopts=$(getopt -o "$SHORTOPTS" --long "$LONGOPTS" -n "$APPNAME" -- "$@" 2>/dev/null)
eval set -- "${setopts[@]}" 2>/dev/null
while :; do
  case "$1" in
  --raw)
    shift 1
    export SHOW_RAW="true"
    printf_column() { tee | grep '^'; }
    printf_color() { printf '%b' "$1" | tr -d '\t' | sed '/^%b$/d;s,\x1B\[ 0-9;]*[a-zA-Z],,g'; }
    ;;
  --debug)
    shift 1
    set -xo pipefail
    export SCRIPT_OPTS="--debug"
    export _DEBUG="on"
    __devnull() { tee || return 1; }
    __devnull2() { eval "$@" |& tee || return 1; }
    ;;
  --completions)
    if [ "$2" = "short" ]; then
      printf '%s\n' "-$SHORTOPTS" | sed 's|"||g;s|:||g;s|,|,-|g' | tr ',' '\n'
    elif [ "$2" = "long" ]; then
      printf '%s\n' "--$LONGOPTS" | sed 's|"||g;s|:||g;s|,|,--|g' | tr ',' '\n'
    elif [ "$2" = "array" ]; then
      printf '%s\n' "$ARRAY" | sed 's|"||g;s|:||g' | tr ',' '\n'
    elif [ "$2" = "list" ]; then
      printf '%s\n' "$LIST" | sed 's|"||g;s|:||g' | tr ',' '\n'
    else
      exit 1
    fi
    shift 2
    exit $?
    ;;
  --options)
    shift 1
    printf_blue "Current options for ${PROG:-$APPNAME}"
    [ -z "$SHORTOPTS" ] || __list_options "Short Options" "-${SHORTOPTS}" ',' '-' 4
    [ -z "$LONGOPTS" ] || __list_options "Long Options" "--${LONGOPTS}" ',' '--' 4
    [ -z "$ARRAY" ] || __list_options "Base Options" "${ARRAY}" ',' '' 4
    [ -z "$LIST" ] || __list_options "Base Options" "${LIST}" ',' '' 4
    exit $?
    ;;
  --version)
    shift 1
    __version
    exit $?
    ;;
  --help)
    shift 1
    __help
    exit $?
    ;;
  --config)
    shift 1
    __gen_config
    exit $?
    ;;
  --silent)
    shift 1
    GEN_SCRIPT_REPLACE_ENV_SILENT="true"
    ;;
  --dir)
    CWD_IS_SET="TRUE"
    GEN_SCRIPT_REPLACE_ENV_CWD="$2"
    [ -d "$GEN_SCRIPT_REPLACE_ENV_CWD" ] || mkdir -p "$GEN_SCRIPT_REPLACE_ENV_CWD" |& __devnull
    shift 2
    ;;
  --)
    shift 1
    break
    ;;
  esac
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Get directory from args
# set -- "$@"
# for arg in "$@"; do
# if [ -d "$arg" ]; then
# GEN_SCRIPT_REPLACE_ENV_CWD="$arg" && shift 1 && SET_NEW_ARGS=("$@") && break
# elif [ -f "$arg" ]; then
# GEN_SCRIPT_REPLACE_ENV_CWD="$(dirname "$arg" 2>/dev/null)" && shift 1 && SET_NEW_ARGS=("$@") && break
# else
# SET_NEW_ARGS+=("$arg")
# fi
# done
# set -- "${SET_NEW_ARGS[@]}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set directory to first argument
# [ -d "$1" ] && GEN_SCRIPT_REPLACE_ENV_CWD="$1" && shift 1 || GEN_SCRIPT_REPLACE_ENV_CWD="${GEN_SCRIPT_REPLACE_ENV_CWD:-$PWD}"
GEN_SCRIPT_REPLACE_ENV_CWD="$(realpath "${GEN_SCRIPT_REPLACE_ENV_CWD:-$PWD}" 2>/dev/null)"
# if [ -d "$GEN_SCRIPT_REPLACE_ENV_CWD" ] && cd "$GEN_SCRIPT_REPLACE_ENV_CWD"; then
# if [ "$GEN_SCRIPT_REPLACE_ENV_SILENT" != "true" ] && [ "$CWD_SILENCE" != "true" ]; then
# printf_cyan "Setting working dir to $GEN_SCRIPT_REPLACE_ENV_CWD"
# fi
# else
# printf_exit "💔 $GEN_SCRIPT_REPLACE_ENV_CWD does not exist 💔"
# fi
export GEN_SCRIPT_REPLACE_ENV_CWD
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set actions based on variables

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Check for required applications/Network check
#requiresudo "$0" "$@" || exit 2     # exit 2 if errors
cmd_exists --error --ask bash || exit 3 # exit 3 if not found
#am_i_online --error || exit 4           # exit 4 if no internet
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# APP Variables overrides

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Actions based on env

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Export variables

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# begin main app
printf_red "User ID: $UID"
printf_green "User Name: $RUN_USER"
printf_blue "Script Name: $APPNAME"
printf_cyan "Version: $VERSION"
printf_yellow "Config Dir: $GEN_SCRIPT_REPLACE_ENV_CONFIG_DIR"
printf_purple "Current Working directory: $GEN_SCRIPT_REPLACE_ENV_CWD"
GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS=$?
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set exit code
GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS="${GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS:-$?}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# End application
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# lets exit with code
exit ${GEN_SCRIPT_REPLACE_ENV_EXIT_STATUS:-$?}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# End application
# ex: ts=2 sw=2 et filetype=sh
