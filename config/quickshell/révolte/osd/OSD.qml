import Quickshell
import Quickshell.Wayland
import QtQuick
import qs.services
import qs.osd.osdComponents

Variants {
    id: osd
    model: Quickshell.screens

    PanelWindow {
        id: osdLayer
        property var modelData
        screen: modelData

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        color: "transparent"
        visible: volumeOSD.visible || brightnessOSD.visible

        mask: Region {
            item: volumeOSD
        }

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
        exclusionMode: ExclusionMode.Ignore

        VolumeOSD {
            id: volumeOSD
        }

        BrightnessOSD {
            id: brightnessOSD
        }
    }
}