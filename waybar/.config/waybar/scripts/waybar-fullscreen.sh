#!/usr/bin/env python3
"""
Auto-hide Waybar when a window goes fullscreen (and show it again on exit).

Waybar sits on the "top" layer and has no native hide-on-fullscreen option, so
this watches Hyprland's IPC event stream and hides/shows the bar itself. This
Waybar build ignores SIGUSR1 (verified: the bar does not toggle), so we hide by
killing the process and show by relaunching it. socat isn't installed, so the
event socket is read directly from Python — no extra dependencies.

Autostarted from hyprland.conf (exec-once). Works for any fullscreen trigger:
keybind (super+F) or an app's own fullscreen (video players, games, ...).
"""

import os
import socket
import subprocess
import time


def event_socket_path():
    sig = os.environ["HYPRLAND_INSTANCE_SIGNATURE"]
    xdg = os.environ.get("XDG_RUNTIME_DIR", f"/run/user/{os.getuid()}")
    return f"{xdg}/hypr/{sig}/.socket2.sock"


def connect(path):
    # At login the socket may not exist yet; retry briefly.
    for _ in range(50):
        try:
            s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
            s.connect(path)
            return s
        except (FileNotFoundError, ConnectionRefusedError):
            time.sleep(0.2)
    raise SystemExit("waybar-fullscreen: could not connect to Hyprland event socket")


def waybar_running():
    return subprocess.run(["pgrep", "-x", "waybar"],
                          stdout=subprocess.DEVNULL).returncode == 0


def hide_waybar():
    subprocess.run(["pkill", "-x", "waybar"])


def show_waybar():
    if waybar_running():
        return
    # Detach so the bar survives independently of this listener. Waybar defaults
    # to ~/.config/waybar/{config.jsonc,style.css}, so no flags are needed.
    subprocess.Popen(["waybar"],
                     stdin=subprocess.DEVNULL,
                     stdout=subprocess.DEVNULL,
                     stderr=subprocess.DEVNULL,
                     start_new_session=True)


def main():
    sock = connect(event_socket_path())
    visible = waybar_running()

    buf = b""
    with sock:
        while True:
            data = sock.recv(4096)
            if not data:
                break
            buf += data
            while b"\n" in buf:
                raw, buf = buf.split(b"\n", 1)
                name, _, value = raw.decode(errors="ignore").partition(">>")
                if name != "fullscreen":
                    continue
                want_visible = value.strip() == "0"
                if want_visible == visible:
                    continue
                if want_visible:
                    show_waybar()
                else:
                    hide_waybar()
                visible = want_visible


if __name__ == "__main__":
    main()
