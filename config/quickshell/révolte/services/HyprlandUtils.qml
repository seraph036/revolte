pragma Singleton

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.properties

Singleton {
    id: hyprService

    readonly property HyprlandToplevel activeToplevel: Hyprland.activeToplevel?.wayland?.activated ? Hyprland.activeToplevel : null
    readonly property string activeWindowClass: Hyprland.activeToplevel?.lastIpcObject?.class
    property string windowNameWithSub: "";
    property string currentLayout: "";
    
    readonly property string wTitle: {
        if (activeToplevel && activeToplevel.title !== "") {
            return activeToplevel.title;
        }
        return "noWindowOpen";
    }

    Timer {
        id: getWindowNameAtStart
        running: true
        repeat: false
        interval: 50
        onTriggered: {
            Hyprland.refreshToplevels();
        }
    }

    Connections {
        target: Hyprland
        function onRawEvent(event: HyprlandEvent): void {
            const n = event.name;

            if (("workspace").includes(n)) {
                //Hyprland.refreshToplevels();
                getLayout.running = true
            }
            
            if (["activewindowv2", "closewindow", "workspace"].includes(n)) {
                Hyprland.refreshToplevels();
            }
        }
    }

    Process {
        id: getLayout
        command: ["sh", "-c", "hyprctl activeworkspace -j | jq -r '.tiledLayout'"]
        stdout: SplitParser {
            onRead: data => {
                hyprService.currentLayout = data.trim()
            }
        }
        Component.onCompleted: getLayout.running = false
    }

    function windowText() {
        for (var i = 0; i <= Parameters.windowTitleSub.length; i++) {
            if (hyprService.wTitle == "noWindowOpen") {
                return Parameters.emptyWorkspaceWindow[1] + " " + Parameters.emptyWorkspaceWindow[0]
            } else if (hyprService.wTitle.endsWith(Parameters.windowTitleSub[i])) {
                return Parameters.windowIconSubs[i] + hyprService.wTitle.slice(0, (hyprService.wTitle.length - Parameters.windowTitleSub[i].length))
            } else {
                for (var j = 0; j <= Parameters.windowClassForAddIcon.length; j++) {
                    if (hyprService.activeWindowClass == Parameters.windowClassForAddIcon[j]) {
                        return Parameters.windowIconAdd[j] + hyprService.wTitle
                    }
                }
            }
        }
    }
}