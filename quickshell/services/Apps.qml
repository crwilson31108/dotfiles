pragma Singleton

import "./../utils/scripts/fuzzysort.js" as Fuzzy
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    // Use built-in DesktopEntries like end4's implementation
    readonly property list<DesktopEntry> allApps: Array.from(DesktopEntries.applications.values)
        .sort((a, b) => a.name.localeCompare(b.name))

    readonly property var preppedApps: allApps.map(a => ({
        name: Fuzzy.prepare(a.name),
        comment: Fuzzy.prepare(a.comment || a.name),
        entry: a
    }))

    function fuzzyQuery(search: string): var {
        return Fuzzy.go(search, preppedApps, {
            all: true,
            keys: ["name", "comment"],
            scoreFn: r => r[0].score > 0 ? r[0].score * 0.9 + r[1].score * 0.1 : 0
        }).map(r => r.obj.entry);
    }

    function launch(entry): void {
        try {
            // Use the built-in DesktopEntry execute method like end4's implementation
            entry.execute();
        } catch (error) {
            console.error("Failed to launch app:", entry.name, "Error:", error)
        }
    }
}