#!/bin/sh

#############################################################################
#
# This code is the Property, a Trade Secret and the Confidential Information
# of Univa Corporation.
#
# Copyright 2008-2018 Univa Corporation. All Rights Reserved. Access is Restricted.
#
# It is provided to you under the terms of the
# Univa Term Software License Agreement.
#
# If you have any questions, please contact our Support Department.
#
# http://www.univa.com
#
#############################################################################

logFile=/tmp/urb_add_exec.log
TeeOut() {
echo "$@" | tee -a $logFile >&2
}

ARGS=$(getopt -o h -l "software-profile:,hardware-profile:,cell-dir:" -n "$0" -- "$@" );

if [ $? -ne 0 ]; then
  exit 1
fi

eval set -- "$ARGS";

while true; do
  case "$1" in
    -h)
      shift;
      ;;
    --software-profile)
      shift;
      swprofilename="$1"
      shift;
      ;;
    --hardware-profile)
      shift;
      hwprofilename="$1"
      shift;
      ;;
    --cell-dir)
      shift;
      cell_dir="$1"
      shift;
      ;;
    --)
      shift;
      break;
      ;;
  esac
done

function usage() {
  TeeOut "URB kit: usage: $0 [--software-profile NAME] [--hardware-profile NAME] --cell-dir CELL_DIR HOSTNAME"
  exit 1
}

# Validate argumens
if [ -z "$cell_dir" ] || [ -z "$1" ]; then
  usage
fi

node=$1
TeeOut "URB kit: On adding host: $node"

binDir=`dirname $0`
cd $binDir
binDir=`pwd`

if [ ! -d "$cell_dir" ]; then
  TeeOut "URB kit: Error: cell directory $cell_dir does not exist"
  exit 1
fi

if [ ! -f $cell_dir/common/settings.sh ]; then
  TeeOut "URB kit: UGE settings file not found in $cell_dir"
  exit 1
fi

. $cell_dir/common/settings.sh

if [ ! -f $SGE_ROOT/setup/uge-config.sh ]; then
  echo "$SGE_ROOT/setup/uge-config.sh not found"
  exit 1
fi
. $SGE_ROOT/setup/uge-config.sh


if ! qconf -sel | egrep -q "^($node\..*)|($node)$"; then
  TeeOut "URB kit: Making exec host $node"
  REPLACE_HOST="$node" EDITOR="$binDir/install-exec-host.sh" qconf -ae
fi

TeeOut "URB kit: Adding urb complex on $node"
if ! add_complex_value $node urb 1 ; then
  TeeOut "URB kit: Error adding urb complex on $node"
  exit 1
fi

exit 0
