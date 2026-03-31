import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.components
import qs.services
import qs.properties

WrapperRectangle {
    id: visRoot

    anchors.verticalCenter: parent.verticalCenter
    
    implicitHeight: 30
    implicitWidth: 120

    radius: Parameters.modRadius

    border.width: 1
    border.color: Qt.tint(Parameters.colorBackground, Qt.rgba(Parameters.colorBorder.r, Parameters.colorBorder.g, Parameters.colorBorder.b, 0.2))

    gradient: Gradient {
        orientation: Gradient.Horizontal
        GradientStop {position: 0.0; color: Parameters.colorBackground}
        GradientStop {position: 0.45; color: Qt.lighter(Parameters.colorBackground, 2)}
        GradientStop {position: 0.5; color: Qt.lighter(Parameters.colorBackground, 1.8)}
        GradientStop {position: 0.66; color: Qt.lighter(Parameters.colorBackground, 1.5)}
        GradientStop {position: 0.75; color: Qt.lighter(Parameters.colorBackground, 2)}
        GradientStop {position: 1.0; color: Qt.lighter(Parameters.colorBackground, 1.6)}
    }

    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowBlur: 0.6
        shadowColor: Qt.darker(Qt.tint("#020202", Parameters.colorHighlight), 1.7)
        shadowOpacity: 0.7
        shadowScale: 0.7
        blurEnabled: true
        blur: 0
    }

}