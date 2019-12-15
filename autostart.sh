#!/usr/bin/env bash

run() {
  if ! pgrep "$1" ;
  then
    "$@"&
  fi
}

# Compositor
run compton -b --conf "${HOME}/.config/compton.conf"

# Network
run nm-applet

# Battery / Power management
run xfce4-power-manager

run owncloud

run keepassxc
