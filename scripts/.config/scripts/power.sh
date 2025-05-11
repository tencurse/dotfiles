uptime="$(uptime -p | sed -e 's/up //g')"
host=$(hostname)

# Options
shutdown='Shutdown'
reboot='Reboot'
lock='Lock'
suspend='Suspend'
logout='Logout'
yes='Yes'
no='No'

# Rofi CMD
rofi_cmd() {
  rofi -dmenu \
    -p "$host" \
    -mesg "Uptime: $uptime" \
    -theme "/home/$USER/.config/rofi/powermenu.rasi"
}

# Confirmation CMD
confirm_cmd() {
  rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 250px;}' \
    -theme-str 'mainbox {children: [ "message", "listview" ];}' \
    -theme-str 'listview {columns: 2; lines: 1;}' \
    -theme-str 'element-text {horizontal-align: 0.5;}' \
    -theme-str 'textbox {horizontal-align: 0.5;}' \
    -dmenu \
    -p 'Confirmation' \
    -mesg 'Are you sure?' \
    -theme "/home/$USER/.config/rofi/powermenu.rasi"
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
      #	mpc -q pause
      #	amixer set Master mute
      systemctl suspend
    elif [[ $1 == '--logout' ]]; then
      if [[ "$DESKTOP_SESSION" == 'openbox' ]]; then
        openbox --exit
      elif [[ "$DESKTOP_SESSION" == 'bspwm' ]]; then
        bspc quit
      elif [[ "$DESKTOP_SESSION" == 'i3' ]]; then
        #		i3-msg exit
        killall i3
      elif [[ "$DESKTOP_SESSION" == 'plasma' ]]; then
        qdbus org.kde.ksmserver /KSMServer logout 0 0 0
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
  run_cmd --shutdown
  ;;
$reboot)
  run_cmd --reboot
  ;;
$lock)
  if [[ -x '/usr/bin/betterlockscreen' ]]; then
    betterlockscreen -l
  elif [[ -x '/usr/bin/i3lock' ]]; then
    #i3lock
    /home/$USER/.config/scripts/lock
  fi
  ;;
$suspend)
  run_cmd --suspend
  ;;
$logout)
  run_cmd --logout
  ;;
esac

#chosen=$(printf "Log Out\nSuspend\nRestart\nPower OFF" | rofi -dmenu -i -p "Power Menu" -theme-str '@import "~/.config/rofi/powermenu.rasi"')
# chosen=$(printf "Lock\nLogout\nReboot\nShutdown" | rofi -dmenu -i -p "Power Menu")
# Perform the action based on user choice
#case "$chosen" in
#"Log Out") $logout ;;
#"Suspend") eval $suspend ;;
#"Restart") systemctl reboot ;;
#"Power OFF") systemctl poweroff ;;
#*) exit 1 ;;
#esac
