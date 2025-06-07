#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

alias neofetch='neofetch --source /home/helomo/ASCII/Art/Paimon_3'
alias prime-run='__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only'
alias firefox='prime-run firefox'
export PATH="$PATH:/home/helomo/.local/bin"
export WLR_NO_HARDWARE_CURSORS=1

neofetch
eval "$(oh-my-posh init bash --config /home/helomo/helomoTheme/helomoTheme.json)"
