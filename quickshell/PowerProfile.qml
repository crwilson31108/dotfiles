import QtQuick
import QtQuick.Controls
import Quickshell.Io

Button {
    property var rosePineTheme
    
    implicitWidth: contentItem.implicitWidth + 16
    implicitHeight: 30
    
    property string currentProfile: "balanced"
    property string profileIcon: {
        switch(currentProfile) {
            case "power-saver": return ""
            case "balanced": return ""
            case "performance": return ""
            default: return ""
        }
    }
    
    Process {
        id: profileProc
        command: ["powerprofilesctl", "get"]
        running: true
        
        onStdoutChanged: {
            currentProfile = stdout.trim()
        }
    }
    
    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: profileProc.running = true
    }
    
    background: Rectangle {
        color: hovered ? rosePineTheme.highlightLow : "transparent"
        radius: 6
        
        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }
    
    contentItem: Text {
        text: profileIcon + " " + currentProfile
        color: rosePineTheme.foam
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 13
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    
    onClicked: {
        // Cycle through profiles
        Process.exec(["sh", "-c", `
            current=$(powerprofilesctl get)
            case "$current" in
                "power-saver") powerprofilesctl set balanced ;;
                "balanced") powerprofilesctl set performance ;;
                "performance") powerprofilesctl set power-saver ;;
            esac
        `])
        profileProc.running = true
    }
}