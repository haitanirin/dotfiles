#!/usr/bin/env bash

sxhkd -c "$HOME/.config/bspwm/config/keybindings" &
dunst -config "$HOME/.config/bspwm/config/notification" &
picom --config "$HOME/.config/bspwm/config/compositor" &

xrdb "$HOME/.Xresources" &
$HOME/.config/bspwm/modules/panel/launch &
$HOME/.fehbg &

xsetroot -cursor_name left_ptr &

/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &>/dev/null
eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg) &>/dev/null

