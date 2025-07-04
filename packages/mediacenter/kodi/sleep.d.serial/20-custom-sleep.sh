#!/bin/sh

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2013 Stephan Raue (stephan@openelec.tv)

. /etc/profile

# see https://wiki.archlinux.org/index.php/Power_Management#Hooks_in_.2Fusr.2Flib.2Fsystemd.2Fsystem-sleep

for script in $HOME/.config/sleep.d/*.power; do
  if [ -f $script ]; then
    progress "running custom sleep script $script ($@)..."
    sh $script $@
  fi
done

case "$1" in
  pre)
    # runs before suspending
    if [ -f $HOME/.config/scripts/on_suspend.sh ]; then
      sh $HOME/.config/scripts/on_suspend.sh
    fi
    ;;
  post)
    # runs on resume
    if [ -f $HOME/.config/scripts/on_resume.sh ]; then
      sh $HOME/.config/scripts/on_resume.sh
    fi
    ;;
esac

exit 0
