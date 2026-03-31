pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import qs.properties

WrapperRectangle {
    id: root
    anchors.verticalCenter: parent.verticalCenter

    required property color rectBgColor
    required property color rectBorderColor
    required property real rectRadius
    required property bool hasBorder
    property real blurStrength: 0

    property string rectType: ""

    antialiasing: true

    property bool enableBorder: hasBorder

    radius: rectRadius

    property color bgColor: rectBgColor
    property color borderColor: rectBorderColor

    border.color: Qt.tint(root.bgColor, Qt.rgba(root.borderColor.r, root.borderColor.g, root.borderColor.b, 0.2))
    border.width: hasBorder ? 1 : 0

    //color: bgColor

    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowBlur: 0.6
        shadowColor: Qt.darker(Qt.tint("#020202", Parameters.colorHighlight), 1.7)
        shadowOpacity: 0.7
        shadowScale: 0.7
        blurEnabled: root.blurStrength > 0
        blur: root.blurStrength
    }

    gradient: Gradient {
        orientation: Gradient.Horizontal
        GradientStop {position: 0.0; color: Parameters.colorBackground}
        GradientStop {position: 0.45; color: Qt.lighter(Parameters.colorBackground, 3.2)}
        GradientStop {position: 0.5; color: Qt.lighter(Parameters.colorBackground, 2.7)}
        GradientStop {position: 0.66; color: Qt.lighter(Parameters.colorBackground, 2)}
        GradientStop {position: 0.75; color: Qt.lighter(Parameters.colorBackground, 3.5)}
        GradientStop {position: 1.0; color: Qt.lighter(Parameters.colorBackground, 2.1)}
    }
}
