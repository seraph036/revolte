import QtQuick
import Quickshell
import Quickshell.Io
import qs.components
import qs.properties
import qs.services

Item {
    id: volumeMod
    anchors.verticalCenter: parent.verticalCenter
    width: volBox.width
    height: volBox.height
    property var popout

    MouseArea {
        anchors.verticalCenter: parent.verticalCenter
        width: volBox.width
        height: volBox.height

        onWheel: wheel => {
            if (wheel.angleDelta.y > 0) {
                VolumeUtils.increaseVolume();
            } else if (wheel.angleDelta.y < 0) {
                VolumeUtils.decreaseVolume();
            }
        }

        cursorShape: Qt.PointingHandCursor

        acceptedButtons: Qt.LeftButton/* | Qt.RightButton*/ | Qt.MiddleButton         

        onClicked: {
            if (mouse.button === Qt.LeftButton) {
                PopupTracking.volbrightTracker = "volumeMod"
                popout.trigger()
            }
            
            if (mouse.button === Qt.MiddleButton) {
                VolumeUtils.muteToggle()
                }
        }

        StyledRect {
            id: volBox
            anchors.verticalCenter: parent.verticalCenter
            width: childrenRect.width + 32
            height: Parameters.defaultModSize
            rectRadius: Parameters.dashboardRadius
            rectBgColor: Parameters.colorBackground
            rectBorderColor: Parameters.colorBorder
            hasBorder: true

            Row {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                width: childrenRect.width
                spacing: VolumeUtils.currentVolLevel == 0 ? 4 : 1

                Text {
                    id:volumeSymbolDisplay

                    anchors.verticalCenter: parent.verticalCenter

                    text: VolumeUtils.currentVolSymbol
                    color: VolumeUtils.currentVolLevel != 0 ? Parameters.colorForeground : Qt.lighter(Parameters.colorRed, 1.35)
                    font.pointSize: Parameters.fontSize
                    font.family: Parameters.iconFont
                }

                Text {
                    id:volumeLevelDisplay

                    anchors.verticalCenter: parent.verticalCenter
                
                    text: VolumeUtils.currentVolLevel + "%"
                    color: VolumeUtils.currentVolLevel != 0 ? Parameters.colorForeground : Qt.lighter(Parameters.colorRed, 1.8)
                    font.pointSize: Parameters.fontModSize
                    font.family: Parameters.fontFamily
                    font.styleName: "Bold"
                }
            }
        }
    }
}