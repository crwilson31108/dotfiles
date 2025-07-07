import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland

Button {
    property int workspace: 1
    property var rosePineTheme
    property real scaleFactor: 1.0
    
    width: 30 * scaleFactor
    height: 30 * scaleFactor
    
    property bool isActive: Hyprland.activeWorkspace ? Hyprland.activeWorkspace.id === workspace : false
    property bool hasWindows: {
        if (!Hyprland.workspaces) return false
        for (let i = 0; i < Hyprland.workspaces.length; i++) {
            if (Hyprland.workspaces[i].id === workspace) return true
        }
        return false
    }
    
    background: Rectangle {
        color: isActive ? rosePineTheme.iris : (hovered ? rosePineTheme.highlightMed : (hasWindows ? rosePineTheme.highlightLow : "transparent"))
        radius: 6 * scaleFactor
        
        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }
    
    contentItem: Text {
        text: workspace.toString()
        color: isActive ? rosePineTheme.base : rosePineTheme.text
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 13 * scaleFactor
        font.bold: isActive
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    
    onClicked: {
        Hyprland.dispatch("workspace " + workspace)
    }
}