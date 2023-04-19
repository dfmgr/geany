#!/usr/bin/env sh
# shellcheck shell=sh
# shellcheck disable=SC2317
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
# @@Template         :  shell/sh
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="$(basename "$0")"
SRC_DIR="$(dirname "$APPNAME")"
EXITCODE=0
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set opts

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# # Set functions
__cmd_exists() { [ -n "$(\which "$1")" ] || return 2; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Check for needed applications
__cmd_exists bash || exit 1 # exit 1 if not found
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set variables

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Variables based on actions

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Overwrite variables

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Main application

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
exit $EXITCODE
# end
