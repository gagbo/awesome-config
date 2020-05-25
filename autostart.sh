#!/usr/bin/env bash

run() {
  if ! pgrep "$1" ;
  then
    "$@"&
  fi
}

# Compositor
run picom -b

# Network
run nm-applet

# Battery / Power management
run xfce4-power-manager

run nextcloud

run keepassxc
