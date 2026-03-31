pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import qs.properties

Item {
    property color rectBgColor
    required property color rectBorderColor
    required property real rectRadius
    required property bool hasBorder

    Rectangle {
        id: root

        anchors.fill: parent
        clip: true
        antialiasing: true

        property bool enableBorder: hasBorder

        radius: 16

        property color bgColor: parent.rectBgColor
        property color borderColor: parent.rectBorderColor

        // Helper to apply opacity to a color via alpha channel
        function applyOpacity(baseColor, opacityValue) {
            return Qt.rgba(baseColor.r, baseColor.g, baseColor.b, baseColor.a * opacityValue);
        }

        border.color: Qt.tint(root.bgColor, Qt.rgba(root.borderColor.r, root.borderColor.g, root.borderColor.b, 0.8))
        border.width: hasBorder ? Parameters.modBorderSize : 0
        
        color: bgColor

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowBlur: 0.6
            shadowColor: Qt.darker(Qt.tint("#020202", Parameters.colorHighlight), 1.7)
            shadowOpacity: 0.7
            shadowScale: 0.7
            blurEnabled: true
            blur: 0.2
        }

        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop {position: 0.0; color: Parameters.colorBackground}
            GradientStop {position: 0.45; color: Qt.lighter(Parameters.colorBackground, 3)}
            GradientStop {position: 0.5; color: Qt.lighter(Parameters.colorBackground, 1.8)}
            GradientStop {position: 0.66; color: Qt.lighter(Parameters.colorBackground, 2.4)}
            GradientStop {position: 0.75; color: Qt.lighter(Parameters.colorBackground, 2.6)}
            GradientStop {position: 1.0; color: Qt.lighter(Parameters.colorBackground, 1.4)}
        }
    }
}
