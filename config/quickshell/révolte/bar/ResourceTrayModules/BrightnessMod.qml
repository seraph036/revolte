import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.properties
import qs.services
import qs.components

Item {
    id: brightModRoot
    anchors.verticalCenter: parent.verticalCenter
    width: brightBox.width
    height: brightBox.height
    property var popout

    MouseArea {
        anchors.verticalCenter: parent.verticalCenter
        width: brightBox.width
        height: brightBox.height

        onWheel: wheel => {
            BrightnessUtils.scrollSteps += 2.5
            if (wheel.angleDelta.y > 0) {
                BrightnessUtils.isOpIncrease = 1;
            } else {
                BrightnessUtils.isOpIncrease = 0;
            }
        }

        cursorShape: Qt.PointingHandCursor

        acceptedButtons: Qt.LeftButton/* | Qt.RightButton | Qt.MiddleButton*/

        onClicked: {
            if (mouse.button === Qt.LeftButton) {
                PopupTracking.volbrightTracker = "brightnessMod"
                popout.trigger()
            }
            
            /*if (mouse.button === Qt.MiddleButton) {
                VolumeUtils.muteToggle()
                }*/
        }

        StyledRect {
            id: brightBox
            //color: Parameters.colorBgSystemTray
            anchors.verticalCenter: parent.verticalCenter
            width: childrenRect.width + 32
            height: Parameters.defaultModSize
            rectRadius: Parameters.modRadius
            rectBgColor: Parameters.colorBackground
            rectBorderColor: Parameters.colorBorder
            hasBorder: true

            RowLayout {
                anchors.centerIn: parent
                spacing: 2

                Text {
                    id:volumeSymbolDisplay
                    anchors.verticalCenter: parent.verticalCenter

                    text: BrightnessUtils.currentBrightSymbol
                    color: Parameters.colorForeground
                    font.pointSize: Parameters.fontSize
                    font.family: Parameters.fontFamily
                }

                Text {
                    id:volumeLevelDisplay
                    anchors.verticalCenter: parent.verticalCenter

                    text: BrightnessUtils.currentBrightLevel + "%"
                    color: Parameters.colorForeground
                    font.pointSize: Parameters.fontModSize
                    font.family: Parameters.fontFamily
                    font.styleName: "Bold"
                }
            }
        }
    }
}