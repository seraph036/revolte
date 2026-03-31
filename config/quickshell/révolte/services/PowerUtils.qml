pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import qs.properties

Singleton {
    id: powerServices
    property string currentPowerProf: ""
    //TODO:
    property string currentIdleStatus: Parameters.idleIcons[0]

    Process {
        id:powerProfilesGet
        command: ["sh", "-c", "powerprofilesctl get"]
        stdout: SplitParser {
            onRead: data => {
                if (data.trim() == "performance") {
                    powerServices.currentPowerProf = Parameters.powerProfIcons[2]
                } else if (data.trim() == "balanced") {
                    powerServices.currentPowerProf = Parameters.powerProfIcons[1]
                } else if (data.trim() == "power-saver") {
                    powerServices.currentPowerProf = Parameters.powerProfIcons[0]
                }
            }
        }
        Component.onCompleted: running = false
    }

    Timer {
        interval: 2000
        running: true
        repeat: false //TODO
        onTriggered: {
            powerProfilesGet.running = true
        }
    }
}