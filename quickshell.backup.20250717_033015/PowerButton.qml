import QtQuick
import QtQuick.Controls
import Quickshell.Io

Button {
    property string command
    property var rosePine
    
    width: 130
    height: 32
    
    background: Rectangle {
        color: hovered ? rosePine.highlightMed : rosePine.highlightLow
        radius: 8
        
        Behavior on color {
            ColorAnimation { duration: 150 }
        }
    }
    
    contentItem: Text {
        text: parent.text
        color: rosePine.text
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 13
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        leftPadding: 12
    }
    
    onClicked: {
        Process.exec(["sh", "-c", command])
    }
}