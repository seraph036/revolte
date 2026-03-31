import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import qs.components
import qs.services
import qs.properties

Item {
    anchors.verticalCenter: parent.verticalCenter
    width: powerBox.width
    height: powerBox.height

    MouseArea {
        anchors.verticalCenter: parent.verticalCenter
        width: powerBox.width
        height: powerBox.height

        StyledRect {
            id: powerBox
            anchors.verticalCenter: parent.verticalCenter
            width: childrenRect.width + 15
            height: Parameters.defaultModSize
            rectRadius: Parameters.modRadius
            rectBgColor: Parameters.colorBackground
            rectBorderColor: Parameters.colorBorder
            hasBorder: true

            RowLayout {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                width: childrenRect.width
                height: childrenRect.height

                Text {
                    id:powerProfilesIcon
                    anchors.verticalCenter: parent.verticalCenter

                    text: PowerUtils.currentPowerProf
                    color: Parameters.colorForeground
                    font.pointSize: Parameters.fontSize
                    font.family: Parameters.iconFont
                }

                Text {
                    id:idleIcon
                    anchors.verticalCenter: parent.verticalCenter

                    text: PowerUtils.currentIdleStatus
                    color: Parameters.colorForeground
                    font.pointSize: Parameters.fontSize
                    font.family: Parameters.nerdFont
                }
            }
        }
    }
}