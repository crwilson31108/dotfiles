pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import "./../utils/scripts/fuzzysort.js" as Fuzzy

QtObject {
    id: root

    // Whitelist by Flatpak ID, desktop ID, and name fragments
    readonly property var allowIds: new Set([
        "io.github.shiftey.Desktop",   // Flatpak GitHub Desktop
        "github-desktop"               // AUR or non-Flatpak variant
    ])
    readonly property var allowNameFragments: [
        "github desktop"               // safety net by name
    ]

    // Conservative system categories to hide
    readonly property var systemCategories: new Set([
        "system", "settings", "systemsettings",
        "x-gnome-settings-panel", "x-gnome-systemmaintenance",
        "x-gnome-systemsettings", "x-kde-system-settings",
        "x-xfce-settingsdialog", "screensaver", "x-screensaver",
        "system;monitor", "system;filesystem", "system;security"
    ])

    // Very specific skip regexes. Use word boundaries to avoid nuking legit apps.
    readonly property var skipRegexes: [
        // Build tools
        /\bcmake-?gui\b/i, /\bqmake\b/i, /\bmake\b/i, /\bninja\b/i, /\bmeson\b/i,

        // Qt tools
        /\bqt( |\-)?assistant\b/i, /\bqt( |\-)?designer\b/i, /\bqt( |\-)?linguist\b/i,
        /\bqdbusviewer\b/i, /\bqt( |\-)?qdbusviewer\b/i, /\bqv4l2\b/i,

        // Archive tools
        /\bfile-?roller\b/i, /\barchive manager\b/i, /\bengrampa\b/i, /\bark\b/i,
        /\b7-?zip\b/i, /\bzip\b/i, /\bunzip\b/i, /\btar\b/i, /\bgzip\b/i,

        // Hardware info
        /\bxgps\b/i, /\bgpsd\b/i, /\blshw\b/i, /\bhwinfo\b/i, /\bsensors\b/i,
        /\bhardinfo\b/i, /\bdevice manager\b/i,

        // Fonts
        /\bfont viewer\b/i, /\bfont manager\b/i, /\bcharacter map\b/i, /\bgucharmap\b/i,

        // System monitoring
        /\bsystem monitor\b/i, /\btask manager\b/i, /\bprocess viewer\b/i,
        /\bbaobab\b/i, /\bresource monitor\b/i, /\bactivity monitor\b/i,

        // Package managers
        /\bsoftware updater\b/i, /\bupdate manager\b/i, /\bpackage manager\b/i,
        /\bsynaptic\b/i, /\baptitude\b/i, /\bdnf\b/i, /\byum\b/i, /\bpacman\b/i,
        /\bsoftware center\b/i, /\bapp store\b/i, /\bflatpak\b/i, /\bsnap\b/i,

        // Disks and partitions
        /\bgparted\b/i, /\bpartition editor\b/i, /\bdisk utility\b/i, /\bfdisk\b/i,
        /\bpartition manager\b/i, /\bdisks\b/i,

        // Config editors
        /\bdconf editor\b/i, /\bconfiguration editor\b/i, /\bregistry editor\b/i,
        /\bgsettings\b/i, /\bgconf\b/i, /\bregedit\b/i, /\babout:config\b/i,

        // About dialogs
        /\babout (xfce|gnome|kde|plasma)\b/i,
        /\babout this computer\b/i,

        // Logs and debug
        /\blog viewer\b/i, /\bsystem log\b/i, /\bjournalctl\b/i, /\bdmesg\b/i,
        /\bdebug(ger)?\b/i, /\bvalgrind\b/i, /\bgdb\b/i,

        // Net analysis
        /\bwireshark\b/i, /\btcpdump\b/i, /\bnmap\b/i, /\bnetstat\b/i,
        /\btraceroute\b/i,

        // Terminals
        /\bxterm\b/i, /\bgnome-?terminal\b/i, /\bkonsole\b/i, /\bkitty\b/i,
        /\balacritty\b/i, /\bterminator\b/i, /\btilix\b/i, /\bmate-?terminal\b/i,
        /\blxterminal\b/i
    ]

    // Applications list filtered and sorted
    readonly property list<DesktopEntry> allApps: Array
        .from(DesktopEntries.applications.values)
        .filter(app => shouldShowApp(app))
        .sort((a, b) => a.name.localeCompare(b.name))

    function isWhitelisted(app): bool {
        const id = (app.id || "").toLowerCase()
        const name = (app.name || "").toLowerCase()
        if (allowIds.has(id)) return true
        if (allowNameFragments.some(frag => name.includes(frag))) return true
        return false
    }

    function shouldShowApp(app): bool {
        // Hard allow first
        if (isWhitelisted(app)) return true

        // Basic hygiene
        if (!app || app.noDisplay) return false
        if (!app.name || app.name.trim() === "") return false

        // Category based filtering
        const categories = (app.categories || [])
            .map(c => (c || "").toLowerCase())

        // If any category is clearly system focused, hide
        if (categories.some(c => systemCategories.has(c))) return false

        // Avoid hiding general Development apps
        // Many legit apps, including Git clients, are in Development
        // so do not filter by Development at all.

        // Name based precise filters
        const name = app.name
        for (let i = 0; i < skipRegexes.length; i++) {
            if (skipRegexes[i].test(name)) return false
        }

        // Utilities that are just wrappers around a shell
        const lname = name.toLowerCase()
        if (categories.includes("utility") &&
            (lname.includes("command") || lname.includes("terminal") || lname.includes("console"))) {
            return false
        }

        return true
    }

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
        }).map(r => r.obj.entry)
    }

    function launch(entry): void {
        try {
            entry.execute()
        } catch (error) {
            console.error("Failed to launch app:", entry?.name, "Error:", error)
        }
    }
}