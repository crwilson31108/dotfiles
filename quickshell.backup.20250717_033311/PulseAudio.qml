import QtQuick
import QtQuick.Controls
import Quickshell.Io

Item {
    property var rosePineTheme
    property real scaleFactor: 1.0
    
    implicitWidth: row.implicitWidth
    implicitHeight: 30 * scaleFactor
    
    property int volume: 0
    property bool muted: false
    property string icon: {
        if (muted) return ""
        else if (volume <= 0) return ""
        else if (volume <= 33) return ""
        else if (volume <= 66) return ""
        else return ""
    }
    
    Process {
        id: volumeProc
        command: ["sh", "-c", "pamixer --get-volume-human"]
        running: false
        
        onExited: {
            if (stdout) {
                let output = stdout.toString().trim()
                if (output === "muted") {
                    muted = true
                    volume = 0
                } else {
                    muted = false
                    let val = parseInt(output.replace("%", ""))
                    if (!isNaN(val)) volume = val
                }
            }
        }
    }
    
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: volumeProc.running = true
    }
    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
        
        onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                // Launch pavucontrol
                pavucontrolProc.running = true
            } else if (mouse.button === Qt.MiddleButton) {
                // Toggle mute on middle click  
                muteProc.running = true
                volumeProc.running = true
            }
        }
        
        onWheel: (wheel) => {
            if (wheel.angleDelta.y > 0) {
                volumeUpProc.running = true
            } else {
                volumeDownProc.running = true
            }
            volumeProc.running = true
        }
        
        Row {
            id: row
            spacing: 6
            anchors.centerIn: parent
            
            Text {
                text: icon
                color: rosePineTheme.foam
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 16
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Text {
                text: muted ? "Muted" : volume + "%"
                color: rosePineTheme.foam
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 13
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        
        Rectangle {
            anchors.fill: parent
            color: parent.containsMouse ? rosePineTheme.highlightLow : "transparent"
            radius: 6
            z: -1
            
            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }
    }
    
    Process {
        id: pavucontrolProc
        command: ["pavucontrol"]
        running: false
    }
    
    Process {
        id: muteProc
        command: ["pactl", "set-sink-mute", "@DEFAULT_SINK@", "toggle"]
        running: false
    }
    
    Process {
        id: volumeUpProc
        command: ["pactl", "set-sink-volume", "@DEFAULT_SINK@", "+5%"]
        running: false
    }
    
    Process {
        id: volumeDownProc
        command: ["pactl", "set-sink-volume", "@DEFAULT_SINK@", "-5%"]
        running: false
    }
}