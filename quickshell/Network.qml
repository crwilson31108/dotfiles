import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io

Button {
    property var rosePineTheme
    property real scaleFactor: 1.0
    
    implicitWidth: contentItem.implicitWidth + (20 * scaleFactor)
    implicitHeight: 30 * scaleFactor
    
    property string networkIcon: "󰈀"
    property string networkText: "Network"
    property bool isConnected: false
    
    // Network status check
    Process {
        id: networkCheck
        command: ["bash", "-c", "nmcli -t -f active,ssid dev wifi | awk -F: '/^yes/ {print $2}' | head -1 || echo 'ethernet'"]
        running: false
        
        onExited: {
            if (stdout) {
                const output = stdout.toString().trim()
                if (output && output !== "") {
                    isConnected = true
                    if (output === "ethernet") {
                        networkIcon = "󰈀"
                        networkText = "Ethernet"
                    } else {
                        networkIcon = "󰤨"
                        networkText = output.length > 10 ? output.substring(0, 10) + "..." : output
                    }
                } else {
                    isConnected = false
                    networkIcon = "󰖪"
                    networkText = "Disconnected"
                }
            } else {
                isConnected = false
                networkIcon = "󰖪"
                networkText = "Disconnected"
            }
        }
    }
    
    Timer {
        interval: 5000  // Check every 5 seconds
        running: true
        repeat: true
        onTriggered: networkCheck.running = true
    }
    
    background: Rectangle {
        color: hovered ? rosePineTheme.highlightLow : "transparent"
        radius: 6 * scaleFactor
        
        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }
    
    contentItem: Row {
        spacing: 6 * scaleFactor
        anchors.centerIn: parent
        
        Text {
            text: networkIcon
            color: isConnected ? rosePineTheme.foam : rosePineTheme.love
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 16 * scaleFactor
            anchors.verticalCenter: parent.verticalCenter
        }
        
        Text {
            text: networkText
            color: isConnected ? rosePineTheme.text : rosePineTheme.subtle
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 13 * scaleFactor
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    
    onClicked: {
        // Launch network settings
        networkSettingsProc.running = true
    }
    
    Process {
        id: networkSettingsProc
        command: ["gnome-control-center", "network"]
        running: false
    }
}