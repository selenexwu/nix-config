{ pkgs, ... }:
pkgs.writeShellScript "i3-gnome" ''

# Register with gnome-session so that it does not kill the whole session thinking it is dead.
test -n "$DESKTOP_AUTOSTART_ID" && {
dbus-send --print-reply --session --dest=org.gnome.SessionManager "/org/gnome/SessionManager" org.gnome.SessionManager.RegisterClient "string:i3" "string:$DESKTOP_AUTOSTART_ID"
}

# Support for merging .Xresources
test -e $HOME/.Xresources && {
xrdb -merge $HOME/.Xresources
}

${pkgs.i3}/bin/i3

# Logout process.
test -n "$DESKTOP_AUTOSTART_ID" && {
dbus-send --print-reply --session --dest=org.gnome.SessionManager "/org/gnome/SessionManager" org.gnome.SessionManager.Logout "uint32:1"
}
''

