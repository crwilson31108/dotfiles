import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Row {
    property var rosePine
    
    spacing: 12
    
    // Volume
    Text {
        id: volumeText
        color: rosePine.foam
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 12
        text: "\udb81\udd7e " + volumeProc.stdout.trim()
        
        Process {
            id: volumeProc
            command: ["pamixer", "--get-volume-human"]
            running: true
        }
        
        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: volumeProc.running = true
        }
    }
    
    // Brightness
    Text {
        id: brightnessText
        color: rosePine.foam
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 12
        text: "\udb80\udce0 " + brightnessProc.stdout.trim() + "%"
        
        Process {
            id: brightnessProc
            command: ["sh", "-c", "brightnessctl get | awk '{ print int($1/255*100) }'"]
            running: true
        }
        
        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: brightnessProc.running = true
        }
    }
    
    // Battery
    Text {
        id: batteryText
        color: rosePine.foam
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 12
        text: "\udb80\udc79 " + batteryProc.stdout.trim()
        
        Process {
            id: batteryProc
            command: ["sh", "-c", "upower -i $(upower -e | grep BAT) | grep -E 'percentage' | awk '{print $2}'"]
            running: true
        }
        
        Timer {
            interval: 10000
            running: true
            repeat: true
            onTriggered: batteryProc.running = true
        }
    }
    
    // Power profile
    Text {
        id: profileText
        color: rosePine.foam
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 12
        text: "\udb82\udd04 " + profileProc.stdout.trim()
        
        Process {
            id: profileProc
            command: ["powerprofilesctl", "get"]
            running: true
        }
        
        Timer {
            interval: 5000
            running: true
            repeat: true
            onTriggered: profileProc.running = true
        }
    }
}