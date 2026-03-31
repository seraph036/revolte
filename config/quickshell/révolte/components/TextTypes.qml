pragma Singleton
import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.properties

Item {
    component BarSeparator: RowLayout {
        required property color pipeColor
        Text {
            text: "  "
            color: "transparent"
            font.pixelSize: Parameters.barHeight / 2
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            text: " | "
            color: pipeColor
            font.pixelSize: Parameters.barHeight / 2
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            text: "  "
            color: "transparent"
            font.pixelSize: Parameters.barHeight / 2
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    component BarSeparatorSlim: Text {
        text: "|"
        color: Parameters.colorWine
        font.pixelSize: Parameters.barHeight / 2
        anchors.verticalCenter: parent.verticalCenter
    }
}