pragma Singleton
import Quickshell
import QtQuick

QtObject {
    property bool networkVisible: false
    property bool powerIdleVisible: false
    property bool sysTrayMenuVisible: false
    //property bool windowVisible: false
    property bool volumeVisible: false
    property bool brightnessVisible: false
    property bool dateTimeVisible: false

    property string volbrightTracker: ""
}
