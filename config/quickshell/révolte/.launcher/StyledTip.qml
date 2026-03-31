import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import qs.properties

WrapperRectangle {
    id: root
    implicitHeight: 15
    color: Parameters.colorBackground
    radius: Parameters.modRadius

    required property int delay

    opacity: 0
    visible: false

    property bool tracker: false

    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }

    function open() {
        if (!tracker) {
            delayer.restart()
        } else {
            return
        }
    }

    function close() {
        if (tracker) {
            root.opacity = 0.0
            closer.restart()
        } else {
            return
        }
    }

    Timer {
        id: closer
        running: false
        repeat: false
        interval: 100
        onTriggered: root.visible = false
    }

    Timer {
        id: delayer
        running: false
        repeat: false
        interval: root.delay
        onTriggered: {
            root.visible = true
            Qt.callLater(() => {
                root.opacity = 0.85
            })
        }
    }
}