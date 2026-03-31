import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import qs.components
import qs.popouts
import qs.properties
import qs.services

ClippingRectangle {
    id: root
    implicitWidth:  120
    implicitHeight: Parameters.defaultModSize - 2
    anchors.verticalCenter: parent.verticalCenter
    radius: Parameters.modRadius
    contentInsideBorder: true
    antialiasing: true

    border.width: 1
    border.color: Qt.tint(Parameters.colorBackground, Qt.rgba(Parameters.colorBorder.r, Parameters.colorBorder.g, Parameters.colorBorder.b, 0.8))

    color: Parameters.colorBackground

    // ---------------------------------------------------------------
    // Settings
    // ---------------------------------------------------------------
    readonly property string vizMode: "curve-filled"
    readonly property int    barCount:     12
    readonly property int    curvePoints:  32
    readonly property int    barSpacing:    4
    readonly property int    barWidth:      6      // 0 = auto
    readonly property int    curveLineWidth: 2
    readonly property int    sensitivity:   100
    readonly property string channels:      "mono"  // "mono" | "stereo"
    readonly property string orientation:   "bottom"
    readonly property real   bgOpacity: 0
    readonly property int silenceTimeout: 1600 // in ms

    // "opacity" is the new unified key; fall back to old "barOpacity" for existing configs.
    readonly property real fgOpacity: 1

    property color barColor: Parameters.colorForeground
    property color startColor: Parameters.visualizerColorStart
    property color endColor: Parameters.visualizerColorEnd

    property bool rainbowMode: true

    // In curve mode the "bar count" cava sees is controlled by curvePoints;
    // the barCount setting is only surfaced in the UI when vizMode === "bars".
    readonly property int effectiveBars: vizMode === "bars" ? barCount : curvePoints

    property var  barValues:     []
    property bool isSilent:      true
    property bool fadedOut:      !PlayerUtils.isCurrPlaying
    property bool hasPlayedOnce: false

    /*onIsSilentChanged: {
        if (isSilent) {
            if (hasPlayedOnce) silenceTimer.restart()
        } else {
            hasPlayedOnce = true
            silenceTimer.stop()
            fadedOut = false
        }
    }

    Timer {
        id: silenceTimer
        repeat: false
        interval: root.silenceTimeout
        onTriggered: root.fadedOut = true
    }*/

    opacity: fadedOut ? 0 : 1.0

    Behavior on opacity { 
        NumberAnimation { 
            duration: 1000; easing.type: Easing.InOutQuad 
        } 
    }

    Timer {
        id: rebuildTimer
        interval: 50
        repeat: false
        onTriggered: {
            if (cavaProcess.running) {
                cavaProcess.running = false
            } else if (!configWriter.running) {
                configWriter.running = true
            }
        }
    }

    function rebuildConfig() {
        rebuildTimer.restart()
    }

    Process {
        id: configWriter
        command: [
            "bash", "-c",
            "cat > /tmp/cava-widget.cfg << 'CAVAEOF'\n" +
            "[general]\n" +
            "bars = "        + root.effectiveBars + "\n" +
            "framerate = 60\n" +
            "sensitivity = " + root.sensitivity   + "\n" +
            "channels = "    + root.channels      + "\n" +
            "\n" +
            "[output]\n" +
            "method = raw\n" +
            "channels = "    + root.channels      + "\n" +
            "raw_target = /dev/stdout\n" +
            "data_format = ascii\n" +
            "ascii_max_range = 1000\n" +
            "bar_delimiter = 59\n" +
            "frame_delimiter = 10\n" +
            "CAVAEOF"
        ]
        running: false
        onRunningChanged: {
            if (!running) cavaProcess.running = true
        }
    }

    Process {
        id: cavaProcess
        command: ["cava", "-p", "/tmp/cava-widget.cfg"]
        running: false
        onRunningChanged: {
            if (!running && !configWriter.running) {
                configWriter.running = true
            }
        }

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: function(line) {
                if (!line || line.length === 0) return
                const parts = line.split(";")
                const vals = []
                let silent = true
                for (let i = 0; i < parts.length; i++) {
                    const n = parseInt(parts[i], 10)
                    if (!isNaN(n)) {
                        const v = Math.min(1.0, n / 1000.0)
                        vals.push(v)
                        if (v > 0.01) silent = false
                    }
                }
                if (vals.length > 0) {
                    root.barValues = vals
                    root.isSilent  = silent
                }
            }
        }
    }

    Component.onCompleted:      rebuildConfig()
    onEffectiveBarsChanged:     rebuildConfig()
    onSensitivityChanged:       rebuildConfig()
    onChannelsChanged:          rebuildConfig()
    // Switching mode may change effectiveBars, but also forces a repaint.
    onVizModeChanged:           rebuildConfig()

    MouseArea {
        id: playerMouseArea
        anchors.fill: parent
        hoverEnabled: PlayerUtils.isCurrPlaying

        acceptedButtons: Qt.RightButton

        onEntered: {
            if (root.opacity < 1) {
                root.opacity = 1
            }
            playerControlWrapper.opacity = 1.0
            controlsFadeIn.restart()
            musTooltip.open()
        }

        onExited: {
            if (root.isSilent) {
                root.isSilent = !root.isSilent
                Qt.callLater(() => {
                    root.opacity = 0.3
                    root.isSilent = !root.isSilent
                })
            }
            playerControlWrapper.opacity = 0.0
            controlsFadeOut.restart()
            musTooltip.close()
        }
        
        opacity: root.opacity

        Item {
            id: vis
            anchors.fill: parent

            readonly property real effectiveBarW: root.barWidth > 0
                ? root.barWidth
                : Math.max(1, (width  - (root.effectiveBars - 1) * root.barSpacing) / root.effectiveBars)

            readonly property real effectiveBarH: root.barWidth > 0
                ? root.barWidth
                : Math.max(1, (height - (root.effectiveBars - 1) * root.barSpacing) / root.effectiveBars)

            // ---- BARS: BOTTOM / TOP / HORIZONTAL ----
            Row {
                id: barRow
                visible: root.vizMode === "bars"
                    && !parent.fadedOut && 
                    (root.orientation === "bottom"
                    || root.orientation === "top"
                    || root.orientation === "horizontal")
                width:   parent.width
                height:  root.height - 1
                spacing: root.barSpacing
                anchors.horizontalCenter: parent.horizontalCenter
                Component.onCompleted: console.log(height)

                property int barColorShifter: 0

                Repeater {
                    id: barRepeat
                    model: root.vizMode === "bars" ? root.barCount : 0
                    delegate: Rectangle {
                        required property int index
                        readonly property real norm: root.barValues[index] ?? 0.0

                        width: vis.effectiveBarW
                        height: Math.max(1, norm * barRow.height)
                        y: root.orientation === "bottom" ? vis.height - height
                        : root.orientation === "horizontal" ? vis.height / 2 - height / 2
                        : 0

                        Behavior on height {
                            SmoothedAnimation {
                                velocity: vis.height * 4
                            } 
                        }

                        radius: 2

                        color: {
                            if (root.rainbowMode) {
                                const a = root.fgOpacity
                                
                                // Extract RGB values from our QML colors
                                const r1 = root.startColor.r, g1 = root.startColor.g, b1 = root.startColor.b
                                const r2 = root.endColor.r, g2 = root.endColor.g, b2 = root.endColor.b

                                for (let i = 0; i < 12; i++) {
                                    let currR = r1 + (r2 - r1) * index / 12
                                    let currG = g1 + (g2 - g1) * index / 12
                                    let currB = b1 + (b2 - b1) * index / 12
                                    
                                    return Qt.rgba(currR, currG, currB, a)
                                }
                            } else {
                                return Qt.rgba(root.barColor.r, root.barColor.g, root.barColor.b, root.fgOpacity * (0.85 + norm * 0.15))
                            }
                        }
                    }
                }
            }

            // ---- CURVE: OUTLINE / FILLED ----
            // Drawn on a Canvas using a Catmull-Rom spline, which passes through
            // every data point — giving an accurate frequency envelope without the
            // jagged look of linear segments.
            //
            // Left/Right orientations fall back to bar mode because a horizontal
            // spline through vertical frequency samples doesn't read well visually.
            Canvas {
                id: curveCanvas

                visible: (root.vizMode === "curve-outline" || root.vizMode === "curve-filled") && !root.fadedOut

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: root.orientation == "horizontal" ? parent.verticalCenter : undefined
                anchors.bottom : root.orientation == "bottom" ? parent.bottom : undefined
                anchors.top: root.orientation == "top" ? parent.top : undefined
                height: root.height - 2
                anchors.leftMargin: 0
                anchors.rightMargin: 0

                property real colorOffset: 0.0

                NumberAnimation on colorOffset {
                    from: 0.0
                    to: 1.0
                    duration: 3000 // Speed of the shifting wave
                    loops: Animation.Infinite
                    running: curveCanvas.visible && !root.isSilent
                }

                onColorOffsetChanged: {
                    if (curveCanvas.visible) curveCanvas.requestPaint()
                }

                // Trigger a repaint every time new data arrives.
                Connections {
                    target: root
                    function onBarValuesChanged() {
                        if (curveCanvas.visible) curveCanvas.requestPaint()
                    }
                    function onVizModeChanged() {
                        if (curveCanvas.visible) curveCanvas.requestPaint()
                    }
                    function onFgOpacityChanged() {
                        if (curveCanvas.visible) curveCanvas.requestPaint()
                    }
                    // Note: onBarColorChanged is no longer needed here since we are using a rainbow.
                }

                onPaint: {
                    const ctx  = getContext("2d")
                    const w    = width
                    const h    = root.height - 2
                    const vals = root.barValues
                    const n    = vals.length

                    ctx.clearRect(0, 0, w, h)

                    if (n < 2) return

                    // --------------------------------------------------
                    // Build screen-space point array based on orientation.
                    // --------------------------------------------------
                    const orient = root.orientation
                    const points = []

                    for (let i = 0; i < n; i++) {
                        const t   = i / (n - 1)
                        const amp = vals[i]

                        let px, py
                        px = t * w
                        py = (h - amp * h)
                        points.push({ x: px, y: py })
                    }

                    // --------------------------------------------------
                    // Draw the Catmull-Rom spline.
                    // --------------------------------------------------
                    function drawSpline(pts) {
                        const len = pts.length
                        ctx.beginPath()
                        ctx.moveTo(pts[0].x, pts[0].y)
                        for (let i = 0; i < len - 1; i++) {
                            const p0 = pts[Math.max(0, i - 1)]
                            const p1 = pts[i]
                            const p2 = pts[i + 1]
                            const p3 = pts[Math.min(len - 1, i + 2)]

                            const cp1x = p1.x + (p2.x - p0.x) / 6
                            const cp1y = p1.y + (p2.y - p0.y) / 6
                            const cp2x = p2.x - (p3.x - p1.x) / 6
                            const cp2y = p2.y - (p3.y - p1.y) / 6

                            ctx.bezierCurveTo(cp1x, cp1y, cp2x, cp2y, p2.x, p2.y)
                        }
                    }

                    // --------------------------------------------------
                    // Create the Shifting Two-Color Gradient
                    // --------------------------------------------------
                    const a = root.fgOpacity
                    const gradient = ctx.createLinearGradient(0, 0, w, 0)
                    
                    // Extract RGB values from our QML colors
                    const r1 = root.startColor.r, g1 = root.startColor.g, b1 = root.startColor.b
                    const r2 = root.endColor.r, g2 = root.endColor.g, b2 = root.endColor.b

                    const steps = 10
                    for (let i = 0; i <= steps; i++) {
                        let stopPos = i / steps
                        
                        // Use a sine wave to create a seamless looping back-and-forth gradient
                        // Math.sin returns -1 to 1. We add 1 and divide by 2 to map it to 0.0 -> 1.0
                        let wave = (Math.sin((stopPos * Math.PI * 2) + (curveCanvas.colorOffset * Math.PI * 2)) + 1) / 2
                        
                        // Interpolate the RGB values based on the wave
                        let currR = r1 + (r2 - r1) * wave
                        let currG = g1 + (g2 - g1) * wave
                        let currB = b1 + (b2 - b1) * wave
                        
                        gradient.addColorStop(stopPos, Qt.rgba(currR, currG, currB, a))
                    }

                    const isFilled = root.vizMode === "curve-filled"

                    if (orient === "horizontal") {
                        // Upper half
                        drawSpline(points)
                        // Mirror for the lower half
                        const mirrorH = points.map(p => ({ x: p.x, y: h - p.y }))
                        for (let i = mirrorH.length - 2; i >= 0; i--) {
                            const p0 = mirrorH[Math.min(mirrorH.length - 1, i + 2)]
                            const p1 = mirrorH[i + 1]
                            const p2 = mirrorH[i]
                            const p3 = mirrorH[Math.max(0, i - 1)]

                            const cp1x = p1.x + (p2.x - p0.x) / 6
                            const cp1y = p1.y + (p2.y - p0.y) / 6
                            const cp2x = p2.x - (p3.x - p1.x) / 6
                            const cp2y = p2.y - (p3.y - p1.y) / 6

                            ctx.bezierCurveTo(cp1x, cp1y, cp2x, cp2y, p2.x, p2.y)
                        }
                        ctx.closePath()

                        if (isFilled) {
                            ctx.fillStyle = root.rainbowMode ? gradient : root.barColor
                            ctx.fill()
                            if (root.curveLineWidth > 0) {
                                drawSpline(points)
                                ctx.strokeStyle = gradient
                                ctx.lineWidth   = root.curveLineWidth
                                ctx.lineJoin    = "round"
                                ctx.lineCap     = "round"
                                ctx.stroke()
                                drawSpline(mirrorH)
                                ctx.stroke()
                            }
                        } else {
                            ctx.strokeStyle = root.rainbowMode ? gradient : root.barColor
                            ctx.lineWidth   = root.curveLineWidth
                            ctx.lineJoin    = "round"
                            ctx.lineCap     = "round"
                            ctx.stroke()
                        }

                    } else if (isFilled) {
                        drawSpline(points)
                            const baselineY = orient === "top" ? 0 : h
                            ctx.lineTo(points[n - 1].x, baselineY)
                            ctx.lineTo(points[0].x,     baselineY)
                        ctx.closePath()
                        
                        ctx.fillStyle = root.rainbowMode ? gradient : root.barColor
                        ctx.fill()
                        
                        if (root.curveLineWidth > 0) {
                            drawSpline(points)
                            ctx.strokeStyle = root.rainbowMode ? gradient : root.barColor
                            ctx.lineWidth   = root.curveLineWidth
                            ctx.lineJoin    = "round"
                            ctx.lineCap     = "round"
                            ctx.stroke()
                        }

                    } else {
                        drawSpline(points)
                        ctx.strokeStyle = root.rainbowMode ? gradient : root.barColor
                        ctx.lineWidth   = root.curveLineWidth
                        ctx.lineJoin    = "round"
                        ctx.lineCap     = "round"
                        ctx.stroke()
                    }
                }
            }
        }

        ClippingRectangle {
            id: playerControlWrapper
            anchors.fill: parent
            visible: false
            opacity: 0
            color: "transparent"

            /*StyledTip {
                id: musTooltip
                visible: playerMouseArea.containsMouse
                delay: 2000
                anchors.horizontalCenter: playerControlWrapper.horizontalCenter
                anchors.verticalCenter: playerControlWrapper.verticalCenter
                anchors.topMargin: 20
                implicitWidth: trackTip.width + 8

                Text {
                    id: trackTip
                    color: Parameters.colorForeground
                    font.family: Parameters.fontFamily
                    font.pointSize: 10
                    text: PlayerUtils.trackArtist + " " + "-" + " " + PlayerUtils.trackName
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }*/

            Behavior on opacity {
                NumberAnimation {
                    duration: opacity > 0 ? 200 : 300
                    easing.type: opacity > 0 ? Easing.InCubic : Easing.InQuad
                }
            }

            Image {
                mipmap: true
                id: backgroundArt
                anchors.fill: parent
                source: PlayerUtils.artCoverPath ?? (Quickshell.env("XDG_DATA_HOME") || (Quickshell.env("HOME") + "/.local/share")) + "/wallpapers/lethethread.png"
                sourceSize: Qt.size(128, 128)
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                visible: true
            }

            MultiEffect {
                anchors.fill: parent
                source: backgroundArt
                // Only enable blur when there's content to blur (saves GPU)
                blurEnabled: (PlayerUtils.artCoverPath != undefined) && playerControlWrapper.visible
                blurMax: 32
                blur: 0.2
                opacity: ((PlayerUtils.artCoverPath != undefined) && playerControlWrapper.visible) ? 1.0 : 0.0
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 6
                anchors.rightMargin: 6

                Text {
                    id: playPause
                    color: playPauseMouseArea.containsMouse ? Parameters.colorHighlight : "#eeeeee"
                    //style: Text.Outline
                    //styleColor: '#b62c2c2c'
                    font.family: Parameters.iconFont
                    text: PlayerUtils.isCurrPlaying ? "" : ""
                    font.pointSize: 10
                    Layout.fillWidth: false
                    Layout.alignment: Qt.AlignVCenter

                    MouseArea {
                        id: playPauseMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        acceptedButtons: Qt.LeftButton
                        
                        onClicked: {
                            PlayerUtils.activePlayerID.togglePlaying()
                        }
                    }
                }

                Text {
                    id: prevB
                    color: prevBMouseArea.containsMouse ? Parameters.colorHighlight : "#eeeeee"
                    //style: Text.Outline
                    //styleColor: '#b62c2c2c'
                    font.family: Parameters.iconFont
                    text: ""
                    font.pointSize: 10
                    Layout.fillWidth: false
                    Layout.alignment: Qt.AlignVCenter

                    MouseArea {
                        id: prevBMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        acceptedButtons: Qt.LeftButton
                        
                        onClicked: {
                            if (Parameters.autoPlayOnChange && !PlayerUtils.isCurrPlaying) {
                                PlayerUtils.activePlayerID.togglePlaying()
                            }
                            PlayerUtils.activePlayerID.previous()
                        }
                    }
                }

                Slider {
                    id: trackLenControl
                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true
                    wheelEnabled: false
                    stepSize: 5
                    live: false
                    from: 0
                    to: PlayerUtils.trackLength
                    value: PlayerUtils.activePlayerID.position

                    FrameAnimation {
                        running: PlayerUtils.isCurrPlaying
                        onTriggered: PlayerUtils.activePlayerID.positionChanged()
                    }

                    onMoved: {
                        Qt.callLater(() => {
                            PlayerUtils.activePlayerID.position = parseFloat(trackLenControl.position * PlayerUtils.trackLength)
                        })
                    }

                    background: Rectangle {
                        y: trackLenControl.availableHeight / 2 - height / 2
                        width: parent.availableWidth
                        height: 6
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

                        HoverHandler {
                            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                            cursorShape: Qt.PointingHandCursor
                        }

                        Rectangle {
                            height: parent.height
                            radius: parent.radius
                            width: trackLenControl.visualPosition * parent.width

                            gradient: Gradient {
                                orientation: Gradient.Horizontal
                                GradientStop {position: 0.0; color: Qt.darker(Parameters.colorHighlight, 1.4)}
                                GradientStop {position: 0.3; color: Qt.darker(Parameters.colorHighlight, 1.2)}
                                GradientStop {position: 0.5; color: Qt.darker(Parameters.colorHighlight, 1.0)}
                                GradientStop {position: 0.7; color: Qt.darker(Parameters.colorHighlight, 1.1)}
                                GradientStop {position: 0.3; color: Qt.darker(Parameters.colorHighlight, 1.15)}
                                GradientStop {position: 0.9; color: Qt.darker(Parameters.colorHighlight, 1.2)}
                            }

                            HoverHandler {
                                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                                cursorShape: Qt.PointingHandCursor
                            }
                        }
                    }

                    handle: Rectangle {
                        x: trackLenControl.visualPosition * (trackLenControl.availableWidth - width)
                        y: trackLenControl.availableHeight / 2 - height / 2
                        color: Parameters.colorForeground
                        implicitWidth: implicitHeight * 0.5
                        radius: implicitWidth / 2
                        implicitHeight: 12

                        HoverHandler {
                            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                }

                Text {
                    id: nextB
                    color: nextBMouseArea.containsMouse ? Parameters.colorHighlight : "#eeeeee"
                    //style: Text.Outline
                    //styleColor: '#b62c2c2c'
                    font.family: Parameters.iconFont
                    text: ""
                    font.pointSize: 11
                    Layout.fillWidth: false
                    Layout.alignment: Qt.AlignVCenter

                    MouseArea {
                        id: nextBMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        acceptedButtons: Qt.LeftButton
                        
                        onClicked: {
                            if (Parameters.autoPlayOnChange && !PlayerUtils.isCurrPlaying) {
                                PlayerUtils.activePlayerID.togglePlaying()
                            }
                            PlayerUtils.activePlayerID.next()
                        }
                    }
                }
            }
        }
    }

    Timer {
        id: controlsFadeIn
        running: true
        repeat: false
        interval: 100
        onTriggered: {
            playerControlWrapper.visible = true
        }
    }

    Timer {
        id: controlsFadeOut
        running: true
        repeat: false
        interval: 200
        onTriggered: {
            playerControlWrapper.visible = false
        }
    }
}