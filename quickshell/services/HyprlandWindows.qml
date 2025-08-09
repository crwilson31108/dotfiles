pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick

Singleton {
    id: root

    property var windowList: []
    property var windowByAddress: ({})
    property var workspaceList: []
    
    readonly property var clientsProcess: Process {
        id: getClients
        command: ["bash", "-c", "hyprctl clients -j"]
        
        stdout: StdioCollector {
            id: clientsCollector
            onStreamFinished: {
                try {
                    root.windowList = JSON.parse(clientsCollector.text)
                    
                    // Build address lookup
                    let lookup = {}
                    for (var i = 0; i < root.windowList.length; ++i) {
                        var win = root.windowList[i]
                        lookup[win.address] = win
                    }
                    root.windowByAddress = lookup
                    
                    console.log(`Updated window list: ${root.windowList.length} windows`)
                } catch (e) {
                    console.error("Failed to parse hyprctl clients:", e)
                }
            }
        }
    }
    
    readonly property var workspacesProcess: Process {
        id: getWorkspaces
        command: ["bash", "-c", "hyprctl workspaces -j"]
        
        stdout: StdioCollector {
            id: workspacesCollector
            onStreamFinished: {
                try {
                    root.workspaceList = JSON.parse(workspacesCollector.text)
                    console.log(`Updated workspace list: ${root.workspaceList.length} workspaces`)
                } catch (e) {
                    console.error("Failed to parse hyprctl workspaces:", e)
                }
            }
        }
    }
    
    function refresh() {
        getClients.running = true
        getWorkspaces.running = true
    }
    
    function getWindowsForWorkspace(workspaceId) {
        return windowList.filter(w => w.workspace.id === workspaceId)
    }
    
    Component.onCompleted: refresh()
    
    // Auto-refresh on Hyprland events
    Connections {
        target: Hyprland
        
        function onRawEvent(event) {
            refresh()
        }
    }
    
    // Periodic refresh as fallback
    Timer {
        interval: 2000
        repeat: true
        running: true
        onTriggered: refresh()
    }
}