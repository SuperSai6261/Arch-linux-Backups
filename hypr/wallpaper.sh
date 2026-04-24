#!/bin/bash
WALLPAPER_DIR=~/Pictures/catppuccin/landscapes

while true; do
  for img in "$WALLPAPER_DIR"/*; do
    pkill swaybg
    swaybg -i "$img" -m fill &
    sleep 120
  done
done
