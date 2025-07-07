import QtQuick
import QtQuick.Controls
import Quickshell.Io

Item {
    property var rosePineTheme
    property real scaleFactor: 1.0
    
    implicitWidth: row.implicitWidth
    implicitHeight: 30 * scaleFactor
    
    property int capacity: 0
    property string status: "Unknown"
    property real power: 0
    property string icon: {
        if (status === "Charging" || status === "Fully charged") return ""
        else if (capacity <= 10) return ""
        else if (capacity <= 25) return ""
        else if (capacity <= 50) return ""
        else if (capacity <= 75) return ""
        else return ""
    }
    
    property color textColor: {
        if (capacity <= 15) return rosePineTheme.love
        else if (capacity <= 30) return rosePineTheme.gold
        else return rosePineTheme.foam
    }
    
    Process {
        id: batteryProc
        command: ["sh", "-c", "upower -i $(upower -e | grep 'BAT') | grep -E 'percentage|state|energy-rate'"]
        running: false
        
        onExited: {
            if (stdout) {
                let lines = stdout.toString().trim().split('\n')
                for (let line of lines) {
                    if (line.includes("percentage:")) {
                        let val = parseInt(line.split(":")[1].trim().replace("%", ""))
                        if (!isNaN(val)) capacity = val
                    } else if (line.includes("state:")) {
                        status = line.split(":")[1].trim()
                    } else if (line.includes("energy-rate:")) {
                        let val = parseFloat(line.split(":")[1].trim().replace("W", ""))
                        if (!isNaN(val)) power = val
                    }
                }
            }
        }
    }
    
    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: batteryProc.running = true
    }
    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        
        onClicked: {
            // Launch power settings
            powerStatsProc.running = true
        }
        
        Row {
            id: row
            spacing: 6
            anchors.centerIn: parent
            
            Text {
                text: icon
                color: textColor
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 16
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Text {
                text: capacity + "%"
                color: textColor
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
        id: powerStatsProc
        command: ["gnome-power-statistics"]
        running: false
    }
}