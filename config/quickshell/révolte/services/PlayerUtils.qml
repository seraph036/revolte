pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Services.Mpris
import qs.properties

Singleton {
    id: playerState

    property var livePlayers: Mpris.players.values

    property var playersAmount: livePlayers.length

    
    property var activePlayerID
    property string activePlayerName: ""
    property bool isCurrPlaying: activePlayerID.isPlaying
    property string trackName: activePlayerID.trackTitle
    property string trackAlbum: activePlayerID.trackAlbum
    property string trackArtist: activePlayerID.trackArtist
    property string artCoverPath: activePlayerID.trackArtUrl
    property bool isShuffling: activePlayerID.shuffle
    property real trackLength: activePlayerID.length

    property bool playerOSDTrigger: false

    onPlayersAmountChanged: {
        if (playersAmount > 0) {
            activePlayerID = livePlayers[playersAmount - 1]
            activePlayerName = livePlayers[playersAmount - 1].dbusName
        }
    }

    Timer {
        running: true
        repeat: false
        interval: 10
        onTriggered: activePlayerName = livePlayers[playersAmount - 1].dbusName
    }
}