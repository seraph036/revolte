import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.components
import qs.properties
import qs.services

Rectangle {
    id: sysIconMod
    anchors.verticalCenter: parent.verticalCenter
    implicitHeight: Parameters.workspaceHeight + 2
    implicitWidth: 34
    color: Parameters.colorBackground
    radius: 30
    border.width: 1
    border.color: Qt.tint(Parameters.colorBackground, Qt.rgba(Parameters.colorBorder.r, Parameters.colorBorder.g, Parameters.colorBorder.b, 0.8))

    SwipeView {
        id:currentSystemImage
        currentIndex: Parameters.sysIconType
        anchors.fill: parent
        interactive: false

        Repeater {
            model: 2
            Item {
                anchors.fill: parent
                Text {
                    anchors.centerIn: parent
                    color: Parameters.colorHighlight
                    text: Parameters.systemIconText
                    font.family: Parameters.fontFamily
                    font.pixelSize: Parameters.systemIconFontSize
                    visible: Parameters.sysIconType === 0
                }
                Image {
                    anchors.centerIn: parent
                    source: Parameters.systemImagePath
                    fillMode: Image.PreserveAspectFit
                    width: 20
                    height: width
                    visible: Parameters.sysIconType === 1
                }
            }
        }

    }

    /*Text {
        anchors.centerIn: parent
        color: Parameters.colorHighlight
        text: Parameters.systemIconText
        font.family: Parameters.fontFamily
        font.pixelSize: Parameters.systemIconFontSize
        visible: Parameters.sysIconType === 0
    }*/
}
