import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.components
import qs.services
import qs.properties

StyledRect {
    anchors.verticalCenter: parent.verticalCenter
    width: currentWindowText.width + Parameters.paddingLarge
    height: Parameters.defaultModSize
    rectRadius: Parameters.dashboardRadius
    rectBorderColor: Parameters.colorBorder
    hasBorder: true
    
    Text {
        id:currentWindowText

        anchors.centerIn: parent

        color:Parameters.colorForeground

        text: HyprlandUtils.windowText() == undefined ? HyprlandUtils.wTitle : HyprlandUtils.windowText()
        font.pointSize: Parameters.fontSize - 1
        font.family: Parameters.fontFamilyMedium
        font.bold: false
        elide: Text.ElideRight
    }
}

