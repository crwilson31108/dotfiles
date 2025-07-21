pragma Singleton

import "./../utils/scripts/fuzzysort.js" as Fuzzy
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property list<DesktopEntry> desktopApps: getDesktopApps()
    property list<var> pathExecutables: getPathExecutables()
    property list<var> allApps: desktopApps.concat(pathExecutables)
    property list<var> preppedApps: allApps.map(a => ({
                name: Fuzzy.prepare(a.name || a.command),
                comment: Fuzzy.prepare(a.comment || a.command),
                entry: a
            }))

    // Monitor desktop application directories including Flatpak
    Process {
        running: true
        command: ["inotifywait", "-m", "-e", "close_write,moved_to,create,delete", 
                  "/usr/share/applications", 
                  "/var/lib/flatpak/exports/share/applications",
                  Quickshell.env("HOME") + "/.local/share/applications"]
        
        stdout: SplitParser {
            onRead: line => {
                if (line.includes(".desktop")) {
                    refreshApps()
                }
            }
        }
    }

    // Periodic fallback refresh
    Timer {
        interval: 60000 // Refresh every minute
        running: true
        repeat: true
        onTriggered: refreshApps()
    }

    function getDesktopApps() {
        return DesktopEntries.applications.values.filter(a => !a.noDisplay).sort((a, b) => a.name.localeCompare(b.name))
    }

    function getPathExecutables(): var {
        // Note: PATH executable scanning is disabled to avoid UI blocking
        // To enable, replace this with proper async scanning implementation
        return []
    }

    function refreshApps() {
        desktopApps = getDesktopApps()
        pathExecutables = getPathExecutables()
        allApps = desktopApps.concat(pathExecutables)
        preppedApps = allApps.map(a => ({
                    name: Fuzzy.prepare(a.name || a.command),
                    comment: Fuzzy.prepare(a.comment || a.command),
                    entry: a
                }))
    }

    function fuzzyQuery(search: string): var {
        return Fuzzy.go(search, preppedApps, {
            all: true,
            keys: ["name", "comment"],
            scoreFn: r => r[0].score > 0 ? r[0].score * 0.9 + r[1].score * 0.1 : 0
        }).map(r => r.obj.entry);
    }

    function launch(entry: DesktopEntry): void {
        try {
            if (entry.isExecutable) {
                Quickshell.execDetached(["sh", "-c", `app2unit -- "${entry.command}"`]);
            } else {
                const desktopId = entry.id || entry.execString
                Quickshell.execDetached(["sh", "-c", `app2unit -- "${desktopId}"`]);
            }
        } catch (error) {
            console.error("Failed to launch app:", entry.name, "Error:", error)
        }
    }
}