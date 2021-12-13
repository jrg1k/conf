if status is-interactive
    # Commands to run in interactive sessions can go here
end

if status is-login
    set -x (gnome-keyring-daemon --start | string split "=")
end
