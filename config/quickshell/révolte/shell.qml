//@ pragma Env QSG_RENDER_LOOP=threaded
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000

import Quickshell
import "bar"
import "osd"

ShellRoot {
    id: root
    
    Bar {
        id: barRoot
    }

    OSD {
        id: osdRoot
    }
}



/* {
sysicon
workspaces
open window (with popout)
[currLayout]
tray with (hover popout) {
network (wifi e ethernet) (brief info) (wifi on/off and name, signal strength, 2.4 or 5ghz, wifi 5 or 6,)
bluetooth (brief info) (on/off, connected devices)
power profile
[currLayout]
}
floating insta terminal (e.g. yakuake)
calendar



}
import "hotZones"
/* zone 1: right {
brightness
volume
[microphone]
}

zone 2: bottom {
copy caestelia's dashboard
}

zone 3: left [or click tray on bar] {
more network options
more bluetooth options

keep awake
screenshot
screenrecord
[enable/disable mic]
kernel version (formatted on sight, full uname on hover)
number of updates available
power/session options (sleep shutdown reboot log off)
}


[import "launcher"][or don't and use rofi]

[import "notifications"][or don't and use a theme for another daemon (eg mako)]

import "idle"
/*
idle/screensaver
locking
*/




/*import "modules"
import "modules/drawers"
import "modules/background"
import "modules/areapicker"
import "modules/lock"
import Quickshell
*/


