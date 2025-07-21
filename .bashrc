#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_STYLE_OVERRIDE=kvantum
export CLIPHIST_MAX_ITEMS=1000
export QT_STYLE_OVERRIDE=kvantum
export QT_QPA_PLATFORMTHEME=qt6ct
