import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import qs.components
import qs.services
import qs.properties
import qs.osd

OSDRect {
    id: osdVolRoot

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.topMargin: parent.height / 1.8

    osdType: "volume"

    visible: false
    opacity: 0
    
    width: 150
    height: 180

    Behavior on opacity {
        NumberAnimation {
            id: osdVolFade
            property int fadeInTime: 130
            duration: opacity == 1 ? fadeInTime : 90
            easing.type: Easing.InQuad
        }
    }

    Connections {
        target: VolumeUtils
        function onVolOSDTriggerChanged() {
            console.log("timer func triggered")
            osdVolRoot.osdVolOpen()
        }
    }

    function osdVolOpen() {
        osdLayer.visible = true
        osdVolRoot.visible = true
        osdFadeIn.running = true
        osdAutoClose.running = true
    }

    function osdVolClose() {
        osdVolRoot.opacity = 0.1
        osdFadeOut.running = true
    }

    Item {
        id: osdVolContain
        anchors.fill: parent
        z: 1

        ColumnLayout {
            anchors.fill: parent

            Text {
                //anchors.horizontalCenter: parent.horizontalCenter
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                Layout.topMargin: 15
                font.family: Parameters.iconFont
                font.pointSize: 48
                text: VolumeUtils.currentVolSymbol
                color: Parameters.colorForeground
            }

            Rectangle {
                id: sliderBg

                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.bottomMargin: 8
                Layout.leftMargin: 12
                Layout.rightMargin: 12
                height: 15
                radius: 30

                gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop {position: 0.0; color: Qt.lighter(Parameters.colorBackgroundLight, 1.4)}
                        GradientStop {position: 0.3; color: Qt.lighter(Parameters.colorBackgroundLight, 1.2)}
                        GradientStop {position: 0.5; color: Qt.lighter(Parameters.colorBackgroundLight, 1.0)}
                        GradientStop {position: 0.7; color: Qt.lighter(Parameters.colorBackgroundLight, 1.1)}
                        GradientStop {position: 0.3; color: Qt.lighter(Parameters.colorBackgroundLight, 1.15)}
                        GradientStop {position: 0.9; color: Qt.lighter(Parameters.colorBackgroundLight, 1.2)}
                    }

                Rectangle {
                    anchors {
                        left: parent.left
                        top: parent.top
                        bottom: parent.bottom
                    }
                    height: parent.height
                    radius: parent.radius
                    width: Math.round(VolumeUtils.currentVolLevel / 100 * parent.width)

                    Behavior on width {
                        NumberAnimation {
                            duration: 150
                            easing.type: Easing.InQuad
                        }
                    }

                    gradient: Gradient {
                        orientation: Gradient.Horizontal

                        GradientStop {position: 0.0; color: Qt.darker(Parameters.colorHighlight, 1.4)}
                        GradientStop {position: 0.3; color: Qt.darker(Parameters.colorHighlight, 1.2)}
                        GradientStop {position: 0.5; color: Qt.darker(Parameters.colorHighlight, 1.0)}
                        GradientStop {position: 0.7; color: Qt.darker(Parameters.colorHighlight, 1.1)}
                        GradientStop {position: 0.3; color: Qt.darker(Parameters.colorHighlight, 1.15)}
                        GradientStop {position: 0.9; color: Qt.darker(Parameters.colorHighlight, 1.2)}
                    }

                    // maxWidth: parent's width, in this case, 124 (150 - 24 -> margins)
                }
            }

            Text {
                anchors.top: sliderBg.bottom
                anchors.topMargin: 5
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: Parameters.fontFamilyMedium
                font.pointSize: 13
                text: VolumeUtils.currentVolLevel + "%"
                color: Parameters.colorForeground
            }
        }
    }

    Timer {
        id: osdFadeIn
        running: false
        repeat: false
        interval: 30
        onTriggered: {
            osdVolRoot.opacity = 1
        }
    }

    Timer {
        id: osdFadeOut
        running: false
        repeat: false
        interval: osdVolFade.duration
        onTriggered: {
            osdVolRoot.visible = false
            osdLayer.visible = false
        }
    }

    Timer {
        id: osdAutoClose
        running: false
        repeat: false
        interval: 1400//2300
        onTriggered: {
            osdVolRoot.osdVolClose()
        }
    }
}