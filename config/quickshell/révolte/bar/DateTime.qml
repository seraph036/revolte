import QtQuick
import Quickshell
import qs.properties

Rectangle {
    color: Parameters.colorBgDateTime
    //color: Qt.tint(Parameters.colorHighlight, Qt.rgba(Parameters.colorBackground.r, Parameters.colorBackground.g, Parameters.colorBackground.b, 0.5))
    anchors.verticalCenter: parent.verticalCenter
    width: childrenRect.width + 15
    height: Parameters.defaultModSize - 5
    radius: Parameters.modRadius
    border.width: 1.2
    border.color: Qt.tint(Parameters.colorBackground, Qt.rgba(Parameters.colorBorder.r, Parameters.colorBorder.g, Parameters.colorBorder.b, 0.8))

    Text {
        id: clockText
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        function customFormatTimeDate() {
            return Qt.formatDateTime(new Date(), Parameters.dateDisplay + " | " + Parameters.timeDisplay)
        }
        
        /*function customFormatDate() {
            return Qt.formatDateTime(new Date(), Parameters.dateDisplay)
        }*/

        color: Parameters.colorForeground
        font.pointSize: Parameters.fontModSize 
        font.family: Parameters.fontFamilyMedium
        font.bold: false

        text: customFormatTimeDate()

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: clockText.text = clockText.customFormatTimeDate()
        }
    }
}