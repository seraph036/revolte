#!/bin/bash

isCommandAvailable() { command -v "$1" >/dev/null 2>&1; }

if $(isCommandAvailable flatpak) && $(isCommandAvailable snap); then
    echo "1,1"
elif $(isCommandAvailable flatpak); then
    echo "1,0"
elif $(isCommandAvailable snap); then
    echo "0,0"
fi

