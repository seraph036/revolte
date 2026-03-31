import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Hyprland
import qs.components
import qs.properties

StyledRect {
    anchors.verticalCenter: parent.verticalCenter
    implicitHeight: Parameters.defaultModSize
    implicitWidth: workRow.width + Parameters.paddingMedium
    //bgColor: Parameters.colorBackground
    rectBgColor: Parameters.colorBackground
    rectBorderColor: Parameters.colorBorder
    rectRadius: Parameters.modRadius
    hasBorder: true

    Item {
        anchors.fill: parent
        z: 1

        RowLayout {
            id: workRow
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            
            Repeater {
                model: Hyprland.workspaces

                Rectangle {
                    Layout.preferredWidth: Parameters.workspaceWidth
                    Layout.preferredHeight: Parameters.workspaceHeight
                    color: "transparent"

                    // Necessary vars to make the workspace indicators magic happen
                    property var workspace: Hyprland.workspaces.values.find(ws => ws.id === index + 1) ?? null
                    property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                    readonly property var occupied: Hyprland.workspaces.values.reduce((acc, curr) => {
                        acc[curr.id] = curr.lastIpcObject.windows > 0;
                        return acc;
                    }, {})
                    required property int index
                    readonly property int ws: index + 1
                    readonly property bool isOccupied: occupied[ws] ?? false
                    Connections {
                        target: Hyprland
                        function onRawEvent(event: HyprlandEvent): void {
                            const n = event.name;
                            
                            if (["activewindowv2", "closewindow", "workspace"].includes(n)) {
                                Hyprland.refreshWorkspaces();
                            }
                        }
                    }
                    // End of vars

                    Text {
                        text: index + 1 <= 6 ? Parameters.workspaceNames[index] : index + 1
                        
                        //color: parent.isActive ? Parameters.colorRed : (parent.hasWindows ? Parameters.colorCyan : Parameters.colorDimmed)
                        color: {
                            if (parent.isActive) return Parameters.colorHighlight
                            else if (parent.isOccupied == true) return Parameters.colorForeground
                            else return Parameters.colorDimmed
                        }
                        font.pixelSize: Parameters.workspaceIconSize
                        font.family: Parameters.fontFamily
                        font.bold: true
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Hyprland.dispatch("workspace " + (index + 1))
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }
        }
    }
}

