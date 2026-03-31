import Quickshell
import QtQuick
import qs.properties
import qs.components
import qs.popouts
import "ResourceTrayModules" as ResMod

Row {
    id: resourceRoot
    spacing: 5
    anchors.verticalCenter: parent.verticalCenter

    //TextTypes.BarSeparatorSlim {}

    //TextTypes.BarSeparatorSlim {}

    //ResMod.BluetoothMod {}

    //TextTypes.BarSeparatorSlim {}

    ResMod.VolumeMod {
        id: volumeResMod
        popout: volumeResPop
    }

    VolumePop {
        id: volumeResPop
        anchorer: volumeResMod
    }

    //TextTypes.BarSeparatorSlim {}

    ResMod.BrightnessMod {
        id: brightnessResMod
    }

    //TextTypes.BarSeparatorSlim {}

    ResMod.PowerProfsMod {}

}
