import QtQuick
import QtQuick.Controls
import Quickshell.Io

Item {
    property var rosePineTheme
    
    implicitWidth: row.implicitWidth
    implicitHeight: 30
    
    property int brightness: 50
    property string icon: {
        if (brightness <= 0) return ""
        else if (brightness <= 12) return ""
        else if (brightness <= 25) return ""
        else if (brightness <= 37) return ""
        else if (brightness <= 50) return ""
        else if (brightness <= 62) return ""
        else if (brightness <= 75) return ""
        else if (brightness <= 87) return ""
        else return ""
    }
    
    Process {
        id: brightnessProc
        command: ["sh", "-c", "brightnessctl | grep 'Current brightness:' | awk '{print $3}' | tr -d '()'"]
        running: false
        
        onExited: {
            if (stdout) {
                let val = parseInt(stdout.toString().trim().replace('%', ''))
                if (!isNaN(val)) brightness = val
            }
        }
    }
    
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: brightnessProc.running = true
    }
    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        
        onClicked: {
            // Open brightness settings
            brightnessSettingsProc.running = true
        }
        
        onWheel: (wheel) => {
            if (wheel.angleDelta.y > 0) {
                brightnessUpProc.running = true
            } else {
                brightnessDownProc.running = true
            }
            brightnessProc.running = true
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
                text: brightness + "%"
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
        id: brightnessSettingsProc
        command: ["gnome-control-center", "display"]
        running: false
    }
    
    Process {
        id: brightnessUpProc
        command: ["brightnessctl", "set", "+5%"]
        running: false
    }
    
    Process {
        id: brightnessDownProc
        command: ["brightnessctl", "set", "5%-"]
        running: false
    }
}