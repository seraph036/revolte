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

getPackageNum() {
    case "$mainPackageManager" in
    #nix)
    pacman)
        pacman -Qq | wc -l
        ;;
    dnf)
        dnf list installed | wc -l
        ;;
    apt)
        apt -qq list --installed | wc -l
        ;;
    zypper)
        zypper list --installed-only | cut -d \n -f6- | wc -l
        ;;
    portage)
        if [ $(isCommandAvailable equery) ]; then
            equery list '*' | cut -d \n -f2- | wc -l
        else
            cat /var/lib/portage/world | wc -l
        fi
        ;;
    xbps)
        xbps-query -l | wc -l
        ;;
    #yum)
    *)
        echo ""
        ;;
    esac
}

packagesAmount=$(($(getPackageNum)))

if [ ! -z $packagesAmount ]; then
    if $(isCommandAvailable flatpak); then
        flatpakPackages=$(($(flatpak list | awk '$1 !~ /^Name/' | wc -l)))

        if $(isCommandAvailable snap); then
            snapPackages=$(($(snap list | awk '$1 !~ /^Name/' | wc -l))) && packagesAmount=$(($packagesAmount+$snapPackages))

            echo $mainPackageManager: $packagesAmount,flatpak: $flatpakPackages,snap: $snapPackages
        else
            echo $mainPackageManager: $packagesAmount,flatpak: $flatpakPackages
        fi
    else
        echo $mainPackageManager: $packagesAmount
    fi
else
    echo ""
fi

