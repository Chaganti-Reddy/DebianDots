#!/usr/bin/env bash 

#export SSH_AUTH_SOCK
#export GPG_AGENT_INFO
#export GNOME_KEYRING_CONTROL
#export GNOME_KEYRING_PID

# Polkit agent (auth dialogs)
/usr/lib/polkit-1/polkitd --no-debug &

# numlockx
numlockx &
sxhkd &

xscreensaver --no-splash &

# Network manager applet
# blueman-applet &
greenclip daemon &

# Dunst notification daemon
if [[ `pidof dunst` ]]; then
	pkill dunst
fi
dunst &

# X compositor
xcompmgr &

# Music player daemon
# if [[ ! `pidof mpd` ]]; then
#   mpd &
# fi

# Conky 
# if [[ ! `pidof conky` ]]; then
#   conky -c ~/.config/conky/conky.conf &
# fi

# slstatus (or dwmblocks)
slstatus &

/usr/bin/udiskie --smart-tray &
# /usr/bin/gnome-keyring-daemon --start &

# Clean cached wallpapers if any
[ -d ~/.cache/wallheaven ] && rm -rf ~/.cache/wallheaven

# Fix cursor
xsetroot -cursor_name left_ptr

# DWM scripts
~/.dwm/newlook &
~/.config/scripts/mouse &
~/.config/scripts/check-battery.sh &

#if [ -z "$(pgrep xfce4-clipman)" ]; then
#    xfce4-clipman &
#fi

# Run ollama serve in the background silently.
# ollama serve > /dev/null 2>&1 &

