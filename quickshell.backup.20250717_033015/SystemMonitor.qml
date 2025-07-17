import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Button {
    property var rosePineTheme
    property real scaleFactor: 1.0
    
    implicitWidth: contentLayout.implicitWidth + (16 * scaleFactor)
    implicitHeight: 30 * scaleFactor
    
    property real cpuUsage: 0
    property real memoryUsage: 0
    property real temperature: 0
    
    // CPU and Memory monitoring
    Process {
        id: sysMonitor
        command: ["bash", "-c", "top -bn1 | grep 'Cpu(s)' | awk '{print $2}' | cut -d'%' -f1; free | grep Mem | awk '{printf \"%.1f\", $3/$2 * 100.0}'; sensors | grep 'Package id 0:' | awk '{print $4}' | cut -d'+' -f2 | cut -d'°' -f1 || echo '0'"]
        running: true
        
        onExited: {
            if (exitCode === 0) {
                let lines = stdout.trim().split('\n')
                if (lines.length >= 2) {
                    cpuUsage = parseFloat(lines[0]) || 0
                    memoryUsage = parseFloat(lines[1]) || 0
                    if (lines.length >= 3) {
                        temperature = parseFloat(lines[2]) || 0
                    }
                }
            }
        }
    }
    
    Timer {
        interval: 3000  // Update every 3 seconds
        running: true
        repeat: true
        onTriggered: sysMonitor.running = true
    }
    
    background: Rectangle {
        color: hovered ? rosePineTheme.highlightLow : "transparent"
        radius: 6 * scaleFactor
        
        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }
    
    contentItem: RowLayout {
        id: contentLayout
        spacing: 8 * scaleFactor
        
        Text {
            text: "󰍛"
            color: rosePineTheme.foam
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 14 * scaleFactor
        }
        
        Text {
            text: Math.round(cpuUsage) + "%"
            color: cpuUsage > 80 ? rosePineTheme.love : rosePineTheme.text
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 12 * scaleFactor
            font.bold: true
        }
        
        Text {
            text: "󰆼"
            color: rosePineTheme.rose
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 14 * scaleFactor
        }
        
        Text {
            text: Math.round(memoryUsage) + "%"
            color: memoryUsage > 80 ? rosePineTheme.love : rosePineTheme.text
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 12 * scaleFactor
            font.bold: true
        }
        
        Text {
            text: "󰔏"
            color: rosePineTheme.gold
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 14 * scaleFactor
            visible: temperature > 0
        }
        
        Text {
            text: Math.round(temperature) + "°"
            color: temperature > 70 ? rosePineTheme.love : rosePineTheme.text
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 12 * scaleFactor
            font.bold: true
            visible: temperature > 0
        }
    }
    
    onClicked: {
        // Launch system monitor
        Process.exec(["gnome-system-monitor"])
    }
}