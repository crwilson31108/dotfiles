pragma Singleton

import "./../utils/scripts/fuzzysort.js" as Fuzzy
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property list<DesktopEntry> desktopApps: getDesktopApps()
    readonly property list<var> pathExecutables: getPathExecutables()
    readonly property list<var> allApps: desktopApps.concat(pathExecutables)
    readonly property list<var> preppedApps: allApps.map(a => ({
                name: Fuzzy.prepare(a.name || a.command),
                comment: Fuzzy.prepare(a.comment || a.command),
                entry: a
            }))

    Process {
        running: true
        command: ["inotifywait", "-m", "-e", "close_write,moved_to,create,delete", 
                  "/usr/share/applications", Quickshell.env("HOME") + "/.local/share/applications"]
        
        stdout: StdioCollector {
            onStreamFinished: {
                if (text.includes(".desktop")) {
                    refreshApps()
                }
            }
        }
    }

    function getDesktopApps() {
        return DesktopEntries.applications.values.filter(a => !a.noDisplay).sort((a, b) => a.name.localeCompare(b.name))
    }

    function refreshApps() {
        desktopApps = getDesktopApps()
    }

    function getPathExecutables(): var {
        const result = Quickshell.execSync("bash", ["-c", "echo $PATH | tr ':' '\\n' | xargs -I {} find {} -maxdepth 1 -type f -executable 2>/dev/null | sort -u | head -200"]);
        if (result.exitCode !== 0) return [];
        
        const executables = result.stdout.trim().split('\n').filter(path => path.length > 0);
        return executables.map(path => {
            const name = path.split('/').pop();
            return {
                name: name,
                command: name,
                execString: name,
                isExecutable: true,
                path: path
            };
        });
    }

    function fuzzyQuery(search: string): var {
        return Fuzzy.go(search, preppedApps, {
            all: true,
            keys: ["name", "comment"],
            scoreFn: r => r[0].score > 0 ? r[0].score * 0.9 + r[1].score * 0.1 : 0
        }).map(r => r.obj.entry);
    }

    function launch(entry: DesktopEntry): void {
        if (entry.isExecutable) {
            Quickshell.execDetached(["sh", "-c", `app2unit -- ${entry.command}`]);
        } else if (entry.execString.startsWith("sh -c")) {
            Quickshell.execDetached(["sh", "-c", `app2unit -- ${entry.execString}`]);
        } else {
            Quickshell.execDetached(["sh", "-c", `app2unit -- '${entry.id}.desktop' || app2unit -- ${entry.execString}`]);
        }
    }
}
