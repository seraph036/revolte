import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.components
import qs.properties
import qs.services

PanelPopup {
    id: sysTrayMenu
    tracker: PopupTracking.sysTrayMenuVisible
    popWidth: 270
    popHeight: 600
    anchor.rect.y: 38

    //required property SystemTrayItem sysItem

    QsMenuOpener {
        id: menuOpener
        menu: root.item.menu
    }

    Rectangle {
        anchors.fill: parent
        color: Parameters.colorBackground
        radius: Parameters.dashboardRadius
    }
}