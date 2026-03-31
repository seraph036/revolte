import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.bar
import qs.components
import qs.properties
import qs.services


PanelPopup {
    id: dashWindow
    tracker: PopupTracking.dashboardVisible
    popWidth: 520
    anchor.rect.x: -resTray.width / 1.5
    popHeight: 500
    anchor.rect.y: 37

    Column {
        width: parent.width
        height: parent.height

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
                    text: qsTr("Resources")

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
                    text: qsTr("System Stats")

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
                    text: qsTr("Mixer")

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