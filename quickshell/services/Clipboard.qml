pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property var history: []
    property string currentClip: ""

    // Timer to periodically check clipboard
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: checkClipboard()
    }

    // Process to get current clipboard content
    Process {
        id: getClipboard
        command: ["wl-paste", "-n"]
        
        onExited: {
            if (stdout) {
                const content = stdout.trim()
                if (content && content !== root.currentClip) {
                    root.currentClip = content
                    addToHistory(content)
                }
            }
        }
    }

    // Process to get clipboard history from cliphist
    Process {
        id: getHistory
        command: ["cliphist", "list"]
        
        onExited: {
            if (stdout) {
                const lines = stdout.split('\n').filter(line => line.trim())
                root.history = lines.slice(0, 20).map(line => {
                    // cliphist format is: "id\tcontent"
                    const parts = line.split('\t')
                    return parts.slice(1).join('\t')
                })
            }
        }
    }

    function checkClipboard() {
        getClipboard.running = true
    }

    function refreshHistory() {
        getHistory.running = true
    }

    function addToHistory(text) {
        // Remove duplicates
        const filtered = root.history.filter(item => item !== text)
        // Add to beginning
        root.history = [text, ...filtered].slice(0, 20)
    }

    function copyToClipboard(text) {
        Process.startDetached("sh", ["-c", `echo -n "${text.replace(/"/g, '\\"')}" | wl-copy`])
        root.currentClip = text
        addToHistory(text)
    }

    function clearHistory() {
        Process.startDetached("cliphist", ["wipe"])
        root.history = []
        root.currentClip = ""
    }

    Component.onCompleted: {
        refreshHistory()
    }
}