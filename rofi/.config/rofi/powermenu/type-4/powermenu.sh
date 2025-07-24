#!/usr/bin/env bash

# Current Theme
dir="$HOME/.config/rofi/powermenu/type-4"
theme='style-5'

# CMDs
uptime="`uptime -p | sed -e 's/up //g'`"
host=`hostname`

# Options
shutdown=''
reboot=''
lock=''
suspend=''
logout=''
yes=''
no=''

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-p "Goodbye ${USER}" \
		-mesg "Uptime: $uptime" \
		-theme ${dir}/${theme}.rasi
}

# Confirmation CMD
confirm_cmd() {
	rofi -dmenu \
		-p 'Confirmation' \
		-mesg 'Are you Sure?' \
		-theme ${dir}/shared/confirm.rasi
}

# Ask for confirmation
confirm_exit() {
	echo -e "$yes\n$no" | confirm_cmd
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
run_cmd() {
	selected="$(confirm_exit)"
	if [[ "$selected" == "$yes" ]]; then
		if [[ $1 == '--shutdown' ]]; then
			systemctl poweroff
		elif [[ $1 == '--reboot' ]]; then
			systemctl reboot
		elif [[ $1 == '--suspend' ]]; then
			mpc -q pause
			pamixer -m
			systemctl suspend
		elif [[ $1 == '--logout' ]]; then
			if [[ "$DESKTOP_SESSION" == 'openbox' ]]; then
				openbox --exit
			elif [[ "$DESKTOP_SESSION" == 'bspwm' ]]; then
				bspc quit
			elif [[ "$DESKTOP_SESSION" == 'i3' ]]; then
				i3-msg exit
      elif [[ "$DESKTOP_SESSION" == 'hyprland' ]]; then 
        hyprctl dispatch exit 0
      elif [[ "$DESKTOP_SESSION" == 'sway' ]]; then
        swaymsg exit 0
      elif [[ "$DESKTOP_SESSION" == 'qtile' ]]; then
        qtile cmd-obj -o cmd -f shutdown
			fi
		fi
	else
		exit 0
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
    echo "$(uptime -p) from $(uptime -s) till $(date '+%Y-%m-%d %H:%M:%S')...  Shutting Down" >> ~/dotfiles/Uptime.log
		run_cmd --shutdown
        ;;
    $reboot)
    echo "$(uptime -p) from $(uptime -s) till $(date '+%Y-%m-%d %H:%M:%S')...  Rebooting" >> ~/dotfiles/Uptime.log
		run_cmd --reboot
        ;;
    $lock)
	  hyprlock &	
        ;;
    $suspend)
		run_cmd --suspend
        ;;
    $logout)
		run_cmd --logout
        ;;
esac
