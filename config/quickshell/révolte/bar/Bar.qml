import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.properties
import qs.components
import qs.popouts
import qs.services
import "ResourceTrayModules" as ResMod

Variants {
    id:bar
    model: Quickshell.screens

    PanelWindow {
        /*Component.onCompleted: {
            if (this.WlrLayershell != null) {
                this.WlrLayershell.layer = WlrLayer.Top;
            }
        }*/
        id:barPanel
        property var modelData
        screen: modelData
        aboveWindows: false

        anchors {
            top: true
            left: true
            right: true
        }

        implicitHeight: Parameters.barHeight
        color: "transparent"

        margins {
            top: 0
            bottom: 0
            left: 0
            right: 0
        }

        RowLayout {
            anchors.fill: parent
            //anchors.leftMargin: (parent.width / 100)
            //anchors.rightMargin: (parent.width / 100)
            //spacing: parent.width / 100
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            spacing: 0

            SystemIcon {
                id: sysIcon
            }

            /*InfoDashboard {
                id: dashPop
                anchorer: resTray
            }*/

            Item { width: 8 }

            Workspaces {
                id: workMod
            }

            Item { width: 8 }

            Visualizer {
                id: visMod
            }

            Item { Layout.fillWidth: true }

            CurrentWindow {
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Item { Layout.fillWidth: true }

            Row {
                id: resourceRoot
                spacing: 5
                anchors.verticalCenter: parent.verticalCenter

                //TextTypes.BarSeparatorSlim {}

                //TextTypes.BarSeparatorSlim {}

                //ResMod.BluetoothMod {}

                //TextTypes.BarSeparatorSlim {}

                ResMod.VolumeMod {
                    id: volumeResMod
                    popout: volbrightResPop
                }

                VolumeBrightnessPop {
                    id: volbrightResPop
                    anchorer: PopupTracking.volbrightTracker == "volumeMod" ? volumeResMod : brightnessResMod
                }

                //TextTypes.BarSeparatorSlim {}

                ResMod.BrightnessMod {
                    id: brightnessResMod
                    popout: volbrightResPop
                }

                //TextTypes.BarSeparatorSlim {}

                ResMod.PowerProfsMod {}

            }

            Item { width: 8 }

            SysTray {
                id: systemTray
            }

            Item { width: 8 }
            
            DateTime {}
        }
    }
}
