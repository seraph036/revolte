#!/bin/bash

isCommandAvailable() { command -v "$1" >/dev/null 2>&1; }

getMainPackageManager() {
  [[ -f /etc/NIXOS ]] && echo "nix" && return
  isCommandAvailable pacman && echo "pacman" && return
  isCommandAvailable dnf && echo "dnf" && return
  isCommandAvailable apt && echo "apt" && return
  isCommandAvailable zypper && echo "zypper" && return
  isCommandAvailable portage && echo "portage" && return
  isCommandAvailable xbps-install && echo "xbps" && return
  #isCommandAvailable yum && ! isCommandAvailable dnf && echo "yum" && return

  echo "unknown"
}

mainPackageManager=$(getMainPackageManager)

getAvailableUpdates() {
    case "$mainPackageManager" in
    #nix)
    pacman)
        #if $(isCommandAvailable checkupdates); then
            #checkupdates | wc -l
        #else
            pacman -Q --upgrades | wc -l
        #fi
        ;;
    #dnf)
    apt)
        apt -q -y --ignore-hold --allow-change-held-packages --allow-unauthenticated -s dist-upgrade | grep  ^Inst | wc -l
        ;;
    #zypper)
    #portage)
    #xbps)
    #yum)
    *)
        echo ""
        ;;
    esac
}

systemUpgrades=$(($(getAvailableUpdates)))

echo "$systemUpgrades"

if $(isCommandAvailable flatpak); then
    #flatpakUpgrades=$(($(flatpak update --appstream &>/dev/null && flatpak update | awk '$1 ~ /^[[:digit:]]/' | wc -l )))
    #TODO: FIX ONCE INTERNET WORKS AGAIN
    flatpakUpgrades=$(($(timeout -s 9 10s flatpak update | awk '$1 ~ /^[[:digit:]]/' | wc -l)))
else
    flatpakUpgrades=0
fi

if $(isCommandAvailable snap); then
    flatpakUpgrades=$(($(snap refresh --list | awk '$1 !~ /^Name/' | wc -l)))
else
    snapUpgrades=0
fi

echo ",$flatpakUpgrades,$snapUpgrades"

