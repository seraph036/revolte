pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.osd
import qs.properties

Singleton {
    id:volumeLevel

    property string currentVolLevel: ""
    property string currentVolSymbol: ""

    property string currentInputVolLevel: ""
    property string currentInputVolSymbol: ""

    property bool volOSDTrigger: false

    Process {
        id:currentVolLevelGet
        command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@"]
        stdout: SplitParser {
            onRead: data => {
                if (!data.includes("MUTED")) {
                        volumeLevel.currentVolLevel = Math.round(parseFloat(data.match(/Volume:\s*([\d.]+)/)[1]) * 100)
                    if (volumeLevel.currentVolLevel == 0) {
                        volumeLevel.currentVolSymbol = Parameters.volIcons[0]
                    } else if (volumeLevel.currentVolLevel >= 80) {
                        volumeLevel.currentVolSymbol = Parameters.volIcons[3]
                    } else if (volumeLevel.currentVolLevel >= 35) {
                        volumeLevel.currentVolSymbol = Parameters.volIcons[2]
                    } else {
                        volumeLevel.currentVolSymbol = Parameters.volIcons[1]
                    }
                } else {
                    volumeLevel.currentVolSymbol = Parameters.volIcons[0];
                    volumeLevel.currentVolLevel = 0
                }
            }
        }
        Component.onCompleted: running = false;
    }

    Process {
        id:currentInputVolLevelGet
        command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SOURCE@"]
        stdout: SplitParser {
            onRead: data => {
                if (!data.includes("MUTED")) {
                        volumeLevel.currentInputVolLevel = Math.round(parseFloat(data.match(/Volume:\s*([\d.]+)/)[1]) * 100)
                    if (volumeLevel.currentInputVolLevel == 0) {
                        volumeLevel.currentInputVolSymbol = Parameters.inputVolIcons[0]
                    } else {
                        volumeLevel.currentInputVolSymbol = Parameters.inputVolIcons[1]
                    }
                } else {
                    volumeLevel.currentInputVolSymbol = Parameters.inputVolIcons[0];
                    volumeLevel.currentInputVolLevel = 0
                }
            }
        }
        Component.onCompleted: running = false;
    }

    function increaseVolume() {
        if (currentVolLevel <= 95) {
            Quickshell.execDetached(["sh", "-c", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+"])
        }
        volGetTimer.running = true;
        }

    function decreaseVolume() {
        if (currentVolLevel >= 5) {
            Quickshell.execDetached(["sh", "-c", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-"])
        }
        volGetTimer.running = true;
    }

    function muteToggle() {
        Quickshell.execDetached(["sh", "-c", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"])
        volGetTimer.running = true;
    }

    function setVolume(level) {
        let strLevel = level.toString()
        Quickshell.execDetached({
            command: ["sh", "-c", "wpctl set-volume @DEFAULT_AUDIO_SINK@ " + strLevel]
        });
        volGetTimer.running = true
    }

    function muteInputToggle() {
        Quickshell.execDetached(["sh", "-c", "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"])
        volInputGetTimer.running = true;
    }

    function setInputVolume(level) {
        let strLevel = level.toString()
        Quickshell.execDetached({
            command: ["sh", "-c", "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ " + strLevel]
        });
        volInputGetTimer.running = true
    }

    Timer {
        id: volGetTimer
        interval: 10
        running: true
        repeat: false
        onTriggered: {
            currentVolLevelGet.running = true
            currentInputVolLevelGet.running = true
            volOSDTrigger = !volOSDTrigger
        }
    }

    Timer {
        id: volInputGetTimer
        interval: 10
        running: true
        repeat: false
        onTriggered: {
            currentVolLevelGet.running = true
            currentInputVolLevelGet.running = true
        }
    }
}