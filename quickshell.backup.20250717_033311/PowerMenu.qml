import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io

Button {
    property var rosePineTheme
    property real scaleFactor: 1.0
    
    implicitWidth: 40 * scaleFactor
    implicitHeight: 30 * scaleFactor
    
    background: Rectangle {
        color: hovered ? rosePineTheme.highlightMed : "transparent"
        radius: 6 * scaleFactor
        
        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }
    
    contentItem: Text {
        text: "⏻"
        color: rosePineTheme.love
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 20 * scaleFactor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    
    onClicked: {
        // Launch wlogout power menu
        wlogoutProc.running = true
    }
    
    Process {
        id: wlogoutProc
        command: ["wlogout"]
        running: false
    }
}