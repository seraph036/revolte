pragma Singleton
import QtQuick
import Quickshell

QtObject {

    // required packages: jq, brightnessctl, ddcutil, ttf-iosevka-nerd, ttf-roboto, ttf-ubuntu-nerd

    // useful hardcoded colours
    readonly property color colorCyan: "#0db9d7"
    readonly property color colorPurple: '#c518e7'
    readonly property color colorRed: "#dc2332"
    readonly property color colorWine: '#6e1b22'
    readonly property color colorYellow: "#f9af26"
    readonly property color colorBlue: "#7aa2f7"
    readonly property color colorGrey: "#2f313a"
    readonly property color colorSilver: "#84858d"
    readonly property color colorMagenta: "#ff00e6"
    readonly property color colorHotPink: "#fd2ab7"
    
    // custom module colours
    readonly property color colorBackground: "#070707"
    readonly property color colorBackgroundLight: "#171717"
    readonly property color colorForeground: "#dce0e3"
    readonly property color colorDimmed: "#444b6a"
    readonly property color colorSlightDim: "#191919"
    readonly property color colorDashButton: colorSlightDim
    readonly property color colorBgDateTime: "#404040"//Qt.tint(Parameters.colorHighlight, Qt.rgba(Parameters.colorBackground.r, Parameters.colorBackground.g, Parameters.colorBackground.b, 0.4))
    readonly property color colorBgSystemTray: colorSlightDim

    // theme colours
    readonly property color colorHighlight: "#eeeeee" //Qt.tint(Parameters.colorPurple, Qt.rgba(Parameters.colorBackground.r, Parameters.colorBackground.g, Parameters.colorBackground.b, 0.1))
    readonly property color colorBorder: colorForeground//colorCyan
    readonly property color visualizerColorStart: colorForeground//Qt.tint(Parameters.colorPurple, Qt.rgba(Parameters.colorBackground.r, Parameters.colorBackground.g, Parameters.colorBackground.b, 0.1))
    readonly property color visualizerColorEnd: colorDimmed//colorCyan

    // font size and family
    property int fontSize: 14
    property int fontModSize: 13 // some bar modules' text works better with a slightly smaller font size
    property int fontDashSize: 12
    property string fontFamily: "Roboto Condensed"
    property string fontFamilyBold: "Ubuntu Nerd Font Bold"
    property string fontFamilyMedium: "Roboto Condensed Medium"
    property string windowTitleFont: "Iosevka NFP Medium"
    property string fontFamilyCond: "Ubuntu Nerd Font Propo Cond"
    property string fontFamilyPropo: "Iosevka NFP Medium"
    property string iconFont: "Phosphor-Bold"
    property string nerdFont: "Ubuntu Nerd Font"

    // size parameters
    property int barHeight: 42
    property int workspaceHeight: 30
    property int workspaceWidth: 30
    property int workspaceIndicatorHeight: 3
    property int paddingSmall: 10
    property int paddingMedium: 20
    property int paddingLarge: 30
    property int defaultModSize: 34//38
    property int dashboardRadius: 30
    property int modRadius: 14
    property int visualizerWidth: 220
    property real modBorderSize: 1

    // paths
    readonly property string home: Quickshell.env("HOME") // home path

    // sys icon config
    property int sysIconType: 0 // 0 will mean text, using a font-based icon. 1 will mean using a custom image (either the font icon or the img path must be defined below)
    property string systemIconText: " 󰣇  "
    property int systemIconFontSize: 25
    property string systemImagePath: `${home}/.config/quickshell/révolte/assets/lethearch.png` // path for OS/distro icon
    property int systemImageWidth: systemImageHeight
    property int systemImageHeight: barHeight * 2 / 3.5

    // workspace names
    property list<string> workspaceNames: ["", "󰈹", "", "", "󰥠", ""]

    // workspace icon size
    property int workspaceIconSize: 17

    // applications for window title substitution (match is based on index, so index 0 of TitleSub will be replaced with index 0 of IconSubs and so on)
    property list<string> windowTitleSub: [" — Konsole", " - Code - OSS", " — Firefox", " — Firefox Private Browsing", " — Firefox Developer Edition", " — Firefox Developer Edition Private Browsing", " — Elisa", " — Kate", " — Dolphin", " – GIMP"]

    property list<string> windowIconSubs: ["   ", "   ", "󰈹  ", "󱐡  ", "󰈹  ", "󱐡  ", "󰓃  ", "   ", "󱢴   ", "    "]

    // match icon for window titles that don't have the substitution (match logic is the same as above, index based) (uses hyprctl class instead of topleveltitle)
    property list<string> windowClassForAddIcon: ["kitty"]

    property list<string> windowIconAdd: ["󰄛  "]

    // title and icon for when there are no open windows in a workspace
    property list<string> emptyWorkspaceWindow: ["Desktop", "󰍹  "]

    // how time should be displayed
    property string timeDisplay: "󰥔  HH:mm"

    // how the date should be displayed
    property string dateDisplay: "  dd/MM"

    // icon substitutions for workspace indicator

    /*function iconMap(class: string): string {
        class.contains("firefox") ? return "firefox" :
        class.contains("minecraft") ? return "minecraft" :
        class.contains("code-oss") ? return "visual-studio-code" :
        class.contains("kate") ? return ""
    }*/

    // volume icons
    property list<string> volIcons: ["", "", "", ""]
    property list<string> inputVolIcons: ["", ""]

    // brightness icons
    property list<string> brightIcons: ["󰃞", "󰃟", "󰃝", "󰃠"]

    // power profs icons
    property list<string> powerProfIcons: ["", "", ""]

    // idle icons
    property list<string> idleIcons: ["󰈈", "", ""]

    // music players to be recognized by the visualizer widget:
    property list<string> mediaPlayers: ["elisa", "cmus", "mpd"]

    // when song is paused, and then changed with the next/previous buttons, should it start playing automatically?
    property bool autoPlayOnChange: true
}
