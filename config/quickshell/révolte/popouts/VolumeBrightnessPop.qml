import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls
import Quickshell
import qs.components
import qs.services
import qs.properties

PanelPopup {
    id: popupVolBright
    popWidth: 250
    popHeight: 300

    GridLayout {
        anchors.fill: parent
        rows: 3
        columns: 2
        columnSpacing: 8
        rowSpacing: 10

        Text {
            Layout.leftMargin: 20
            text: VolumeUtils.currentVolSymbol
            color: Parameters.colorForeground
            font.family: Parameters.iconFont
            font.pointSize: 20
        }

        Slider {
            id: volControl
            Layout.rightMargin: 20
            Layout.fillWidth: true
            wheelEnabled: true
            stepSize: 5
            live: false
            from: 0
            to: 100
            value: VolumeUtils.currentVolLevel

            onMoved: {
                VolumeUtils.setVolume(volControl.position)
            }

            background: Rectangle {
                y: volControl.availableHeight / 2 - height / 2
                width: parent.availableWidth
                height: 8
                radius: Parameters.modRadius
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
                    height: parent.height
                    radius: parent.radius
                    width: volControl.visualPosition * parent.width

                    gradient: Gradient {
                        orientation: Gradient.Horizontal

                        GradientStop {position: 0.0; color: Qt.darker(Parameters.colorHighlight, 1.4)}
                        GradientStop {position: 0.3; color: Qt.darker(Parameters.colorHighlight, 1.2)}
                        GradientStop {position: 0.5; color: Qt.darker(Parameters.colorHighlight, 1.0)}
                        GradientStop {position: 0.7; color: Qt.darker(Parameters.colorHighlight, 1.1)}
                        GradientStop {position: 0.3; color: Qt.darker(Parameters.colorHighlight, 1.15)}
                        GradientStop {position: 0.9; color: Qt.darker(Parameters.colorHighlight, 1.2)}
                    }
                }
            }

            handle: Rectangle {
                x: volControl.visualPosition * (volControl.availableWidth - width)
                y: volControl.availableHeight / 2 - height / 2
                color: Parameters.colorForeground
                implicitWidth: 18
                radius: implicitWidth / 2
                implicitHeight: implicitWidth
                border.width: 1
                border.color: Parameters.colorSilver
            }
        }

        Text {
            Layout.leftMargin: 20
            text: VolumeUtils.currentInputVolSymbol
            color: Parameters.colorForeground
            font.family: Parameters.iconFont
            font.pointSize: 19
        }

        Slider {
            id: volInputControl
            Layout.rightMargin: 20
            Layout.fillWidth: true
            wheelEnabled: true
            stepSize: 5
            live: false
            from: 0
            to: 100
            value: VolumeUtils.currentInputVolLevel

            onMoved: {
                VolumeUtils.setInputVolume(volInputControl.position)
            }

            background: Rectangle {
                y: volInputControl.availableHeight / 2 - height / 2
                width: parent.availableWidth
                height: 8
                radius: Parameters.modRadius
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
                    height: parent.height
                    radius: parent.radius
                    width: volInputControl.visualPosition * parent.width

                    gradient: Gradient {
                        orientation: Gradient.Horizontal

                        GradientStop {position: 0.0; color: Qt.darker(Parameters.colorHighlight, 1.4)}
                        GradientStop {position: 0.3; color: Qt.darker(Parameters.colorHighlight, 1.2)}
                        GradientStop {position: 0.5; color: Qt.darker(Parameters.colorHighlight, 1.0)}
                        GradientStop {position: 0.7; color: Qt.darker(Parameters.colorHighlight, 1.1)}
                        GradientStop {position: 0.3; color: Qt.darker(Parameters.colorHighlight, 1.15)}
                        GradientStop {position: 0.9; color: Qt.darker(Parameters.colorHighlight, 1.2)}
                    }
                }
            }

            handle: Rectangle {
                x: volInputControl.visualPosition * (volInputControl.availableWidth - width)
                y: volInputControl.availableHeight / 2 - height / 2
                color: Parameters.colorForeground
                implicitWidth: 18
                radius: implicitWidth / 2
                implicitHeight: implicitWidth
                border.width: 1
                border.color: Parameters.colorSilver
            }
        }

        Text {
            Layout.leftMargin: 20
            text: BrightnessUtils.currentBrightSymbol + " "
            color: Parameters.colorForeground
            font.family: Parameters.nerdFont
            font.pointSize: 20
        }

        Slider {
            id: brightControl
            Layout.rightMargin: 20
            Layout.fillWidth: true
            wheelEnabled: true
            stepSize: 5
            live: false
            from: 0
            to: 100
            value: BrightnessUtils.currentBrightLevel

            onMoved: {
                BrightnessUtils.customLevel = (brightControl.position * 100);
                BrightnessUtils.doCustomLevel = 1;
            }

            background: Rectangle {
                y: brightControl.availableHeight / 2 - height / 2
                width: parent.availableWidth
                height: 8
                radius: Parameters.modRadius
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
                    height: parent.height
                    radius: parent.radius
                    width: brightControl.visualPosition * parent.width

                    gradient: Gradient {
                        orientation: Gradient.Horizontal

                        GradientStop {position: 0.0; color: Qt.darker(Parameters.colorHighlight, 1.4)}
                        GradientStop {position: 0.3; color: Qt.darker(Parameters.colorHighlight, 1.2)}
                        GradientStop {position: 0.5; color: Qt.darker(Parameters.colorHighlight, 1.0)}
                        GradientStop {position: 0.7; color: Qt.darker(Parameters.colorHighlight, 1.1)}
                        GradientStop {position: 0.3; color: Qt.darker(Parameters.colorHighlight, 1.15)}
                        GradientStop {position: 0.9; color: Qt.darker(Parameters.colorHighlight, 1.2)}
                    }
                }
            }

            handle: Rectangle {
                x: brightControl.visualPosition * (brightControl.availableWidth - width)
                y: brightControl.availableHeight / 2 - height / 2
                color: Parameters.colorForeground
                implicitWidth: 18
                radius: implicitWidth / 2
                implicitHeight: implicitWidth
                border.width: 1
                border.color: Parameters.colorSilver
            }
        }
    }
}