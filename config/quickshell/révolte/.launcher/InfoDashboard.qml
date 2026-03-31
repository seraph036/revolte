import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.bar
import qs.components
import qs.properties
import qs.services


PopupWindow {
    id: dashWindow
    property var anchorer
    anchor.item: anchorer
    //tracker: undefined
    //popWidth: 520
    anchor.rect.x: -resTray.width / 1.5
    //popHeight: 500
    width: 520
    height: 500
    anchor.rect.y: yPos
    property int yPos
    visible: false
    color: "transparent"

    Behavior on yPos {
        NumberAnimation {
            duration: 80
            easing.type: parent.visible ? Easing.InCirc : Easing.OutCirc
        }
    }

    Timer {
        id: openDash
        running: false
        repeat: false
        interval: 40
        onTriggered: {
            dashWindow.visible = false
            dashWindow.visible = true
        }
    }

    Timer {
        id: closeDash
        running: false
        repeat: false
        interval: 30
        onTriggered: {
            dashColumn.opacity = 0.3
            dashWindow.visible = false
        }
    }

    Connections {
        target: PopupTracking
        function onDashboardVisibleChanged() {
            if (PopupTracking.dashboardVisible == true) {
                dashWindow.visible = true
                dashColumn.opacity = 1
                dashWindow.yPos = 40
                openDash.running = true
                
            } else {
                dashWindow.yPos = -Parameters.barHeight
                closeDash.running = true
            }
        }
    }

    Column {
        id: dashColumn
        width: parent.width
        height: parent.height
        opacity: 0.2

        Behavior on opacity {
            NumberAnimation {
                duration: dashWindow.visible ? 40 : 100
                easing.type: Easing.OutCubic
            }
        }

        Rectangle {
            id:tabBarBg
            implicitWidth: parent.width
            implicitHeight: parent.implicitHeight / 12
            topRightRadius: Parameters.dashboardRadius
            topLeftRadius: Parameters.dashboardRadius / 6

            color: "transparent"

            TabBar {
                id: dashTabs
                implicitWidth: parent.width
                implicitHeight: parent.implicitHeight
                currentIndex: dashboardContents.currentIndex

                TabButton {
                    id:dashT1
                    text: qsTr("Info Dash")

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: dashTabs.setCurrentIndex(0)
                    }

                    contentItem: Text {
                        text: parent.text
                        color: dashTabs.currentIndex == 0 ? Parameters.colorHighlight : Parameters.colorForeground
                        font.family: Parameters.fontFamily
                        font.styleName: "Bold"
                        font.pointSize: Parameters.fontDashSize
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        implicitHeight: dashTabs.implicitHeight
                        opacity: 1
                        color: dashTabs.currentIndex == 0 ? Parameters.colorBackground : Parameters.colorBackgroundLight
                        topLeftRadius: Parameters.dashboardRadius
                    }
                }

                TabButton {
                    id:dashT2
                    text: qsTr("System Stats")

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: dashTabs.setCurrentIndex(1)
                    }

                    contentItem: Text {
                        text: parent.text
                        color: dashTabs.currentIndex == 1 ? Parameters.colorHighlight : Parameters.colorForeground
                        font.family: Parameters.fontFamily
                        font.styleName: "Bold"
                        font.pointSize: Parameters.fontDashSize
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        implicitHeight: dashTabs.implicitHeight
                        opacity: 1
                        color: dashTabs.currentIndex == 1 ? Parameters.colorBackground : Parameters.colorBackgroundLight
                        radius: 0
                    }
                }

                TabButton {
                    id:dashT3
                    text: qsTr("Media")

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: dashTabs.setCurrentIndex(2)
                    }

                    contentItem: Text {
                        text: parent.text
                        color: dashTabs.currentIndex == 2 ? Parameters.colorHighlight : Parameters.colorForeground
                        font.family: Parameters.fontFamily
                        font.styleName: "Bold"
                        font.pointSize: Parameters.fontDashSize
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        implicitHeight: dashTabs.implicitHeight
                        opacity: 1
                        color: dashTabs.currentIndex == 2 ? Parameters.colorBackground : Parameters.colorBackgroundLight
                        radius: 0
                    }
                }

                TabButton {
                    id:dashT4
                    text: qsTr("Weather")

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: dashTabs.setCurrentIndex(3)
                    }

                    contentItem: Text {
                        text: parent.text
                        color: dashTabs.currentIndex == 3 ? Parameters.colorHighlight : Parameters.colorForeground
                        font.family: Parameters.fontFamily
                        font.styleName: "Bold"
                        font.pointSize: Parameters.fontDashSize
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        implicitHeight: dashTabs.implicitHeight
                        opacity: 1
                        color: dashTabs.currentIndex == 3 ? Parameters.colorBackground : Parameters.colorBackgroundLight
                        topRightRadius: tabBarBg.topRightRadius
                    }
                }
            }

            Rectangle {
                id:tabBarLowRect
                implicitWidth: parent.width / 4
                implicitHeight: tabBarBg.implicitHeight / 10
                x: (targetIndex * parent.width / 4)

                Behavior on x {
                    NumberAnimation {
                        duration: 110
                        easing.type: Easing.OutCubic
                    }
                }
                
                anchors.bottom: parent.bottom

                color: Parameters.colorHighlight

                property int targetIndex: dashboardContents.currentIndex
            }
        }

        

        StackLayout {
            id:dashboardContents
            height: parent.height - (tabBarBg.height + tabBarLowRect.height)
            width: parent.width
            currentIndex: dashTabs.currentIndex
            //layout.alignment: Qt.AlignBottom

            Rectangle {
                id:rect1
                width: parent.width
                height: parent.height
                color: Parameters.colorBackground
                bottomLeftRadius: Parameters.dashboardRadius
                bottomRightRadius: Parameters.dashboardRadius
            }

            Rectangle {
                id:rect2
                width: parent.width
                height: parent.height
                color: Parameters.colorBackground
                bottomLeftRadius: Parameters.dashboardRadius
                bottomRightRadius: Parameters.dashboardRadius
            }

            Rectangle {
                id:rect3
                width: parent.width
                height: parent.height
                color: Parameters.colorBackground
                bottomLeftRadius: Parameters.dashboardRadius
                bottomRightRadius: Parameters.dashboardRadius
            }

            Rectangle {
                id:rect4
                width: parent.width
                height: parent.height
                color: Parameters.colorBackground
                bottomLeftRadius: Parameters.dashboardRadius
                bottomRightRadius: Parameters.dashboardRadius
            }
        }
    }
}