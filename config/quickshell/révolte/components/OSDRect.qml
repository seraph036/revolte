pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import qs.properties

Item {
    required property string osdType

    Rectangle {
        id: root

        anchors.fill: parent
        clip: true
        antialiasing: true

        opacity: 0.94

        radius: 12

        property string type: parent.osdType

        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop {position: 0.0; color: Qt.lighter(Parameters.colorBackground, 1.0)}
            GradientStop {position: 0.75; color: Qt.lighter(Parameters.colorBackground, 1.65)}
            GradientStop {position: 1.0; color: Qt.lighter(Parameters.colorBackground, 2)}
        }

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowBlur: 0.4
            shadowColor: Qt.darker(Qt.tint("#020202", Parameters.colorHighlight), 1.7)
            shadowOpacity: 0.25
            shadowScale: 1.0
            blurEnabled: true
            blur: 0.4
            blurMultiplier: 0.1
            blurMax: 21
            autoPaddingEnabled: true
        }

        border.color: "#ffffff"
        border.width: 2.2
    }
}
