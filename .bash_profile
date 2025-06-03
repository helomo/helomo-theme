#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc 

export WLR_NO_HARDWARE_CURSORS=1
export LIBVA_DRIVER_NAME=nvidia
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export GBM_BACKEND=nvidia-drm
export WLR_RENDERER=vulkan
export XDG_SESSION_TYPE=wayland

if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then hyprland; fi 
