./.on-kbd XIDeviceEnabled xx XISlaveKeyboard
inputplug -d -c ./.on-kbd &
xbanish &
xbindkeys &
autokey-gtk &
dunst &
flameshot &

export PATH=$PATH:~/.local/bin
export EDITOR="nvim"
export TERMINAL="konsole"
export BROWSER="google-chrome-stable"
# QT_QPA_PLATFORMTHEME=qt5ct

feh --bg-fill --randomize ~/Pictures/Wallpapers/* &
xrandr --output VGA-1 --primary --left-of DVI-I-1

exec i3
