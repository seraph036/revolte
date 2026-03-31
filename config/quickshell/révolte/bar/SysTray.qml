pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects
import QtQuick.Controls
import QtQuick.Layouts
import qs.popouts
import qs.components
import qs.properties
import qs.services

ClippingWrapperRectangle {
    id: sysTRoot
    anchors.verticalCenter: parent.verticalCenter
    implicitHeight: Parameters.defaultModSize
    color: Qt.lighter(Parameters.colorBackground, 2.8)
    implicitWidth: trayRow.trayCount * 36 - ((Math.max(trayRow.trayCount, 1) - 1) * 8)
    radius: Parameters.dashboardRadius
    border.width: 2
    border.color: Qt.tint(Parameters.colorBackground, Qt.rgba(Parameters.colorBorder.r, Parameters.colorBorder.g, Parameters.colorBorder.b, 0.2))
    visible: trayRow.trayCount > 0
    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: "#202020"
        shadowScale: 1.2
    }

        RowLayout {
            id: trayRow
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8
            property bool menuShow: false
            property var openMenus: []

            property int trayCount: trayItemRepeater.count

            Item {width: 2}
            
            Repeater {
                id: trayItemRepeater
                model: SystemTray.items

                delegate: MouseArea {
                    id:trayItems
                    Layout.preferredWidth: childrenRect.width
                    height: childrenRect.height
                    Layout.alignment: Qt.AlignVCenter

                    cursorShape: Qt.PointingHandCursor

                    required property SystemTrayItem modelData

                    acceptedButtons: Qt.LeftButton | Qt.RightButton

                    onClicked: event => {
                        if (event.button === Qt.LeftButton)
                            modelData.activate();
                        else {
                            sysTrayMenu.askForMenu(modelData)
                        }
                    }

                    IconImage {
                        id: trayIcon
                        source: modelData.icon
                        anchors.verticalCenter: parent.verticalCenter
                        implicitSize: 16
                        mipmap: true
                        asynchronous: true
                    }

                    PopupWindow {
                        id: sysTrayMenu
                        anchor.item: trayIcon
                        implicitWidth: 270
                        implicitHeight: itemsColumn.buttonSizeCount
                        anchor.rect.x: (trayIcon.width - 270) / 2
                        anchor.rect.y: 8
                        visible: false
                        color: "transparent"

                        HyprlandFocusGrab {
                            id: focusGrab
                            windows: [sysTrayMenu]

                            onCleared: {
                                console.log("cleared")
                                sysTrayMenu.close()
                            }
                        }

                        function open() {
                            sysTrayMenu.visible = true
                            focusGrab.active = true
                            openingTimer.restart()
                        }

                        function close() {
                            sysMenu.scale = 0.98
                            sysMenu.opacity = 0
                            closingTimer.restart()
                        }

                        function trigger() {
                            if (sysTrayMenu.visible) {
                                sysTrayMenu.close()
                            } else {
                                sysTrayMenu.open()
                            }
                        }

                        Timer {
                            id: openingTimer
                            interval: 1
                            onTriggered: {
                                sysMenu.scale = 1.0
                                sysMenu.opacity = 1.0
                            }
                        }

                        Timer {
                            id: closingTimer
                            interval: 200
                            onTriggered: {
                                sysTrayMenu.visible = false;
                            }
                        }

                        property var origin: trayItems.modelData

                        property SystemTrayItem sysItem

                        function askForMenu(menuItem: SystemTrayItem): void {  
                            // Close all other open menus  
                            trayRow.openMenus.forEach(menu => {  
                                if (menu !== sysTrayMenu && menu.visible) {  
                                    menu.close()
                                }  
                            })  
                            
                            // Update open menus list  
                            if (menuItem == sysTrayMenu.origin) {  
                                sysTrayMenu.trigger()
                                if (sysTrayMenu.visible) {  
                                    if (!trayRow.openMenus.includes(sysTrayMenu)) {  
                                        trayRow.openMenus.push(sysTrayMenu)  
                                    }  
                                } else {  
                                    const index = trayRow.openMenus.indexOf(sysTrayMenu)  
                                    if (index >= 0) {  
                                        trayRow.openMenus.splice(index, 1)  
                                    }  
                                }  
                            } else {  
                                sysTrayMenu.close()  
                            }  
                        }  

                        QsMenuOpener {
                            id: menuOpener
                            menu: trayItems.modelData.menu
                        }

                        Rectangle {
                            id: sysMenu
                            anchors.fill: parent
                            color: Parameters.colorBackground
                            radius: Parameters.dashboardRadius
                            anchors.topMargin: 18
                            anchors.bottomMargin: 18
                            scale: 0.98
                            opacity: 0
                            visible: parent.visible
                            border.width: 2
                            border.color: Qt.tint(Parameters.colorBackground, Qt.rgba(Parameters.colorBorder.r, Parameters.colorBorder.g, Parameters.colorBorder.b, 0.2))

                            Behavior on scale { 
                                NumberAnimation { 
                                    duration: (contentContainer.opacity < 0.5) ? 100 : 200
                                    easing.type: Easing.OutQuad;
                                } 
                            }
                            
                            Behavior on opacity {
                                NumberAnimation {
                                    duration: (contentContainer.opacity < 0.5) ? 60 : 30;
                                    easing.type: Easing.InQuint;
                                }
                            }

                            Flickable {
                                anchors.fill: parent
                                contentHeight: itemsColumn.height
                                acceptedButtons: Qt.NoButton
                                clip: true
                                boundsBehavior: Flickable.StopAtBounds
                                anchors.topMargin: 24
                                anchors.bottomMargin: 12
                                
                                ColumnLayout {
                                    id: itemsColumn
                                    width: parent.width
                                    spacing: 0
                                    property int buttonSizeCount: (menuRepeater.count + 2) * 36 // buttonDelegate height

                                    Repeater {
                                        id: menuRepeater
                                        model: menuOpener.children ? menuOpener.children.values : []
                                        
                                        delegate: Rectangle {
                                            id: buttonDelegate
                                            required property var modelData
                                            Layout.fillWidth: true
                                            Layout.leftMargin: 20
                                            Layout.rightMargin: 20
                                            Layout.preferredHeight: 36
                                            color: "transparent"

                                            MouseArea {
                                                anchors.fill: parent
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    if (modelData.triggered) {
                                                        modelData.triggered();
                                                    } else if (modelData.activate) {
                                                        modelData.activate();
                                                    }
                                                }

                                                Row {
                                                    anchors.fill: parent
                                                    spacing: 4

                                                    Image {
                                                        width: 16
                                                        height: 16
                                                        source: {
                                                            if (trayItems.modelData.icon.includes("nm")) {
                                                                if (buttonDelegate.modelData.text.includes("Ethernet Network")) {
                                                                    return "image://icon/nm-device-wired"
                                                                } else if (buttonDelegate.modelData.text.includes("disconnected")) {
                                                                    return "image://icon/nm-no-connection"
                                                                } else {
                                                                return buttonDelegate.modelData.icon
                                                                } 
                                                            } else {
                                                                return buttonDelegate.modelData.icon
                                                            }
                                                        }
                                                        visible: source != ""
                                                    }

                                                    Text {
                                                        color: Parameters.colorForeground
                                                        text: buttonDelegate.modelData.text
                                                        font.family: Parameters.fontFamily
                                                        font.pointSize: 12
                                                        width: parent.width - 20
                                                        height: contentHeight
                                                        maximumLineCount: 1
                                                        elide: Text.ElideRight
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Item {width: 2}
        }
}
