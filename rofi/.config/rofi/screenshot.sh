#!/usr/bin/env bash

## Author  : Aditya Shakya (adi1090x)
## Modified: Cleaned up to use default Rofi config only
## Applets : Screenshot + Screen Recording (Hyprland + grim + slurp + wf-recorder)

# Prompt & Message
prompt='Screenshot/Recording'
mesg="$HOME/Pictures/Screenshots"

# Options
option_1=" Capture Region to Clipboard"
option_2=" Capture Desktop"
option_3="📋 Capture Region"
option_4=" Start Screen Recording (with Audio)"
option_5=" Start Screen Recording (No Audio)"
option_6="❌ Exit Recording"

# Notification and Sound
notify_view() {
	local file_path=$1
	local is_video=$2
	local notify_icon=$3
	local notify_message=$4

	paplay /usr/share/sounds/freedesktop/stereo/screen-capture.oga &>/dev/null &
	dunstify -u low -h string:x-dunst-stack-tag:obscreenshot -i "$notify_icon" "$notify_message"

	viewnior "$file_path"
}

# Rofi CMD using default config
rofi_cmd() {
	rofi \
		-dmenu \
		-p "$prompt" \
		-mesg "$mesg"
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5\n$option_6" | rofi_cmd
}

# Directories
screenshot_dir="$HOME/Pictures/Screenshots"
recording_dir="$HOME/Pictures/Recordings"

mkdir -p "$screenshot_dir" "$recording_dir"

# Timestamp
timestamp=$(date +%Y-%m-%d-%H-%M-%S)

# Screenshot Functions
shotnow() {
	file="$screenshot_dir/desktop_${timestamp}.png"
	grim "$file"
	notify_view "$file" false "/usr/share/icons/dunst/picture.png" "Screenshot Saved: $file"
}

shotarea() {
	file="$screenshot_dir/region_${timestamp}.png"
	grim -g "$(slurp)" "$file"
	notify_view "$file" false "/usr/share/icons/dunst/picture.png" "Screenshot Saved: $file"
}

shotarea_clipboard() {
	grim -g "$(slurp)" - | wl-copy
	dunstify -u low -h string:x-dunst-stack-tag:obscreenshot -i "/usr/share/icons/dunst/picture.png" "Screenshot copied to clipboard."
}

# Screen Recording Functions
start_recording_with_audio() {
	file="$recording_dir/screen_recording_${timestamp}.mp4"
	wf-recorder -f "$file" --audio &
	dunstify -u low -h string:x-dunst-stack-tag:obscreenshot -i "/usr/share/icons/dunst/video.png" "Recording Started (with Audio)"
}

start_recording_no_audio() {
	file="$recording_dir/screen_recording_${timestamp}.mp4"
	wf-recorder -f "$file" &
	dunstify -u low -h string:x-dunst-stack-tag:obscreenshot -i "/usr/share/icons/dunst/video.png" "Recording Started (No Audio)"
}

exit_recording() {
	killall wf-recorder
	dunstify -u low -h string:x-dunst-stack-tag:obscreenshot -i "/usr/share/icons/dunst/video.png" "Recording Stopped"
}

# Execute Command
run_cmd() {
	case "$1" in
		--opt1) shotnow ;;
		--opt2) shotarea ;;
		--opt3) start_recording_with_audio ;;
		--opt4) start_recording_no_audio ;;
		--opt5) shotarea_clipboard ;;
		--opt6) exit_recording ;;
	esac
}

# Actions
chosen=$(run_rofi)
case ${chosen} in
	"$option_1") run_cmd --opt5 ;;
	"$option_2") run_cmd --opt1 ;;
	"$option_3") run_cmd --opt2 ;;
	"$option_4") run_cmd --opt3 ;;
	"$option_5") run_cmd --opt4 ;;
	"$option_6") run_cmd --opt6 ;;
esac

