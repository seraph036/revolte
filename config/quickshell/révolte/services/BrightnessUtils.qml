pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import qs.properties

Singleton {
    id:brightnessLevel

    property string activeMonitorModel: ""
    property string activeMonitorType: ""
    property int currentBrightLevel: 50
    property string currentBrightSymbol: ""

    property bool brightOSDTrigger: false

    property real scrollSteps: 0

    // will be set to false if brightness should decrease, and true if it should increase
    property int isOpIncrease: -1

    onIsOpIncreaseChanged: {
        if (isOpIncrease == 0 || isOpIncrease == 1) {
            console.log("trying to start timer")
            startChange.running = true;
        }
    }

    property real customLevel: 0
    property int doCustomLevel: 0

    onDoCustomLevelChanged: {
        if (doCustomLevel == 1) {
            setCustomLevel.running = true;
        }
    }

    function setBrigthness(stepNum: real): void {
        console.log("function called")
        if (brightnessLevel.activeMonitorType == "acpi") {
            if (isOpIncrease == 1) {
                let setIncrease = "+" + stepNum.toString() + "%"
                Quickshell.execDetached({
                    command: ["sh", "-c", "brightnessctl set " + setIncrease]
                });
                Qt.callLater(() => {
                    brightnessSafeRead.running = true;
                });
            } else {
                let setDecrease = stepNum.toString() + "%" + "-"
                Quickshell.execDetached({
                    command: ["sh", "-c", "brightnessctl set " + setDecrease]
                });
                Qt.callLater(() => {
                    brightnessSafeRead.running = true;
                });
            }
        } else {
            if (isOpIncrease == 1) {
                let setIncrease = " " + "+" + " " + stepNum.toFixed(0).toString() + " "
                Quickshell.execDetached({  
                    command: ["sh", "-c", "ddcutil setvcp 10" + setIncrease + "&> /dev/null"]  
                });
                Qt.callLater(() => {
                    brightnessSafeRead.running = true;
                });
            } else {
                let setDecrease = " " + "-" + " " + stepNum.toFixed(0).toString() + " "
                Quickshell.execDetached({  
                    command: ["sh", "-c", "ddcutil setvcp 10" + setDecrease + "&> /dev/null"]  
                });
                Qt.callLater(() => {
                    brightnessSafeRead.running = true;
                });
            }
        }
        brightnessLevel.scrollSteps = 0;
        brightnessLevel.isOpIncrease = -1;
    }

    function setBrightLevel(level) {
        if (brightnessLevel.activeMonitorType == "acpi") {
            let strLevel = level.toString() + "%"
            Quickshell.execDetached({
                command: ["sh", "-c", "brightnessctl set " + strLevel]
            });
            Qt.callLater(() => {
                brightnessSafeRead.running = true;
            });
        } else {
            let strLevel = level.toString()
            Quickshell.execDetached({
                command: ["sh", "-c", "ddcutil setvcp 10 " + strLevel]
            });
            Qt.callLater(() => {
                brightnessSafeRead.running = true;
            });
        }
        brightnessLevel.customLevel = 0;
        brightnessLevel.doCustomLevel = 0;
    }

    Process {
        id:monitorActiveModelGet
        command: ["sh", "-c", "hyprctl monitors -j | jq -r 'if .[].focused then .[].model end'"]
        stdout: StdioCollector {
            onStreamFinished: {
                activeMonitorModel = "'" + text.trim() + "'";
            }
        }
        Component.onCompleted: running = false
    }

    Process {
        id:monitorTypeGet
        command: ["sh", "-c", "ls /sys/class/backlight"]
        stdout: StdioCollector {
            onStreamFinished: {
                if (text.trim() != "") {
                    brightnessLevel.activeMonitorType = "acpi"
                } else {
                    brightnessLevel.activeMonitorType = "ddc"
                }
            }
        }
        Component.onCompleted: running = false
    }

    Process {
        id:brightnessGetACPI
        command: ["sh", "-c", "echo 0//TODO"]
        stdout: SplitParser {
            onRead: data => {
                brightnessLevel.currentBrightLevel = data.trim().match(/Current brightness:[ ]*([0-9])/[1])
            }
        }
        Component.onCompleted: running = false
    }

    Process {
        id:brightnessGetDDC
        command: ["sh", "-c", "ddcutil getvcp 10 --brief | gawk ' { print $4 } '"]
        stdout: SplitParser {
            onRead: data => {
                brightnessLevel.currentBrightLevel = data.trim()
                if (brightnessLevel.currentBrightLevel >= 75) {
                    brightnessLevel.currentBrightSymbol = Parameters.brightIcons[3]
                } else if (brightnessLevel.currentBrightLevel >= 40) {
                    brightnessLevel.currentBrightSymbol = Parameters.brightIcons[2]
                } else if (brightnessLevel.currentBrightLevel >= 15) {
                    brightnessLevel.currentBrightSymbol = Parameters.brightIcons[1]
                } else {
                    brightnessLevel.currentBrightSymbol = Parameters.brightIcons[0]
                }
            }
        }
        Component.onCompleted: running = false
    }

    Timer {
        interval: 10
        running: true
        repeat: false
        onTriggered: {
            monitorActiveModelGet.running = true;
            monitorTypeGet.running = true;
            if (brightnessLevel.activeMonitorType == "acpi") {
                brightnessGetACPI.running = true
            } else {
                brightnessGetDDC.running = true
            }
        }
    }

    Timer {
        id: startChange
        interval: 200
        running: false
        repeat: false
        onTriggered: {
            brightnessChange.running = true;
        }
    }

    Timer {
        id: brightnessChange
        interval: 10
        running: false
        repeat: false
        onTriggered: brightnessLevel.setBrigthness(scrollSteps)
    }

    Timer {
        id: brightnessSafeRead
        interval: 150
        running: false
        repeat: false
        onTriggered: {
            if (brightnessLevel.activeMonitorType == "acpi") {
                brightnessGetACPI.running = true;
                brightOSDTrigger = !brightOSDTrigger;
            } else {
                brightnessGetDDC.running = true;
                brightOSDTrigger = !brightOSDTrigger
            }
        }
    }

    Timer {
        id: setCustomLevel
        interval: 200
        running: false
        repeat: false
        onTriggered: {
            brightnessLevel.setBrightLevel(brightnessLevel.customLevel)
        }
    }
}
