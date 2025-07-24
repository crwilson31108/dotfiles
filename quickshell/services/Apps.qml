pragma Singleton

import "./../utils/scripts/fuzzysort.js" as Fuzzy
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property list<var> allApps: []
    property list<var> preppedApps: []
    property string dbPath: Quickshell.env("HOME") + "/.cache/quickshell/apps.json"

    // Manual refresh process - the only way to update the database
    Process {
        id: manualRefreshProc
        command: [Quickshell.env("HOME") + "/.config/quickshell/scripts/refresh-launcher.sh"]
        
        onExited: (exitCode, exitStatus) => {
            loadAppsFromDatabase()
        }
    }

    // Process to read database file with simpler approach
    Process {
        id: readProc
        command: ["sh", "-c", `cat "${root.dbPath}" 2>/dev/null || echo "FILE_NOT_FOUND"`]
        
        stdout: SplitParser {
            onRead: data => {
                if (!root.dbContent) root.dbContent = ""
                root.dbContent += data
            }
        }
        
        onExited: (exitCode, exitStatus) => {
            if (exitCode === 0 && root.dbContent && root.dbContent !== "FILE_NOT_FOUND") {
                parseDatabase(root.dbContent)
            } else {
                manualRefresh()
            }
            root.dbContent = "" // Clear for next read
        }
    }
    
    property string dbContent: ""

    Component.onCompleted: {
        loadAppsFromDatabase()
    }

    function loadAppsFromDatabase() {
        readProc.running = true
    }

    function parseDatabase(dbFile) {
        if (dbFile) {
            try {
                const apps = JSON.parse(dbFile)
                // Convert JSON objects to app entries compatible with launcher UI and sort alphabetically
                allApps = apps.map(app => ({
                    // Core properties the UI expects
                    name: app.name || "",
                    icon: app.icon || "",
                    comment: app.comment || "",
                    genericName: app.genericName || "",
                    
                    // Launch properties
                    id: app.id || "",
                    command: app.exec || "",
                    execString: app.exec || "",
                    isExecutable: false,
                    
                    // Additional metadata
                    categories: app.categories || "",
                    desktopFile: app.desktopFile || "",
                    noDisplay: false
                })).sort((a, b) => a.name.localeCompare(b.name))
                
                // Prepare for fuzzy search
                preppedApps = allApps.map(a => ({
                    name: Fuzzy.prepare(a.name || a.command),
                    comment: Fuzzy.prepare(a.comment || a.command),
                    entry: a
                }))
                
            } catch (error) {
                console.error("Failed to parse apps database:", error)
                allApps = []
                preppedApps = []
            }
        } else {
            console.error("Database file content is empty")
        }
    }

    function fuzzyQuery(search: string): var {
        return Fuzzy.go(search, preppedApps, {
            all: true,
            keys: ["name", "comment"],
            scoreFn: r => r[0].score > 0 ? r[0].score * 0.9 + r[1].score * 0.1 : 0
        }).map(r => r.obj.entry);
    }

    function manualRefresh(): void {
        manualRefreshProc.running = true
    }
    
    // Legacy function for backward compatibility
    function refreshApps(): void {
        manualRefresh()
    }

    function launch(entry): void {
        try {
            const execCmd = entry.command || entry.execString || entry.id
            
            if (entry.isExecutable) {
                Quickshell.execDetached(["sh", "-c", `app2unit -- "${execCmd}"`]);
            } else {
                // For complex commands (like flatpak), execute directly without app2unit
                if (execCmd.includes("flatpak run") || execCmd.includes("snap run")) {
                    Quickshell.execDetached(["sh", "-c", execCmd]);
                } else {
                    Quickshell.execDetached(["sh", "-c", `app2unit -- "${execCmd}"`]);
                }
            }
        } catch (error) {
            console.error("Failed to launch app:", entry.name, "Error:", error)
        }
    }
}