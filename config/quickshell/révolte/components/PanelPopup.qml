pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import QtQuick
import QtQuick.Effects
import QtQuick.Controls
import QtQuick.Layouts
import qs.bar
import qs.properties
import qs.services

PopupWindow {
    id:root

    required property Item anchorer
    required property real popWidth
    required property real popHeight

    anchor.item: anchorer
    anchor.rect.x: (anchorer.width - popWidth) / 2
    anchor.rect.y: anchorer.height
    visible: false
    implicitWidth: popWidth
    implicitHeight: popHeight
    color: "transparent"

    default property alias contentData: contentContainer.data

    HyprlandFocusGrab {
        id: focusGrab
        windows: [root]

        onCleared: {
            root.close()
        }
    }

    Shortcut {
        enabled: focusGrab.active
        sequence: "Escape";
        onActivated: root.close()
    }

    function open() {
        root.visible = true
        focusGrab.active = true
        openingTimer.restart()
    }

    function close() {
        contentContainer.scale = 0.98
        contentContainer.opacity = 0
        closingTimer.restart()
    }

    function trigger() {
        if (root.visible) {
            root.close()
        } else {
            root.open()
        }
    }

    Timer {
        id: openingTimer
        interval: 100
        onTriggered: {
            contentContainer.scale = 1.0
            contentContainer.opacity = 1.0
        }
    }

    Timer {
        id: closingTimer
        interval: 200
        onTriggered: {
            root.visible = false;
        }
    }

    WrapperRectangle {
        id: contentContainer
        anchors.fill: parent;
        anchors.margins: 0; //root.shadowMargin
        transformOrigin: Item.Top;
        scale: 0.98;
        opacity: 0;

        Behavior on scale { 
            NumberAnimation { 
                duration: 250
                easing.type: Easing.OutCubic;
            } 
        }
        
        Behavior on opacity {
            NumberAnimation {
                duration: 200;
                easing.type: Easing.InCubic;
            }
        }

        radius: Parameters.dashboardRadius
        implicitWidth: root.popWidth
        implicitHeight: root.popHeight

        border.width: 2
        border.color: Qt.tint(Parameters.colorBackground, Qt.rgba(Parameters.colorBorder.r, Parameters.colorBorder.g, Parameters.colorBorder.b, 0.2))

        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop {position: 0.0; color: Parameters.colorBackground}
            GradientStop {position: 0.4; color: Qt.lighter(Parameters.colorBackground, 1.3)}
            GradientStop {position: 0.65; color: Qt.lighter(Parameters.colorBackground, 1.6)}
            GradientStop {position: 1.0; color: Qt.lighter(Parameters.colorBackground, 1)}
        }
    }
}