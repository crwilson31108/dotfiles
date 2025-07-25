pragma Singleton

import "./../config"
import "./../utils/scripts/fuzzysort.js" as Fuzzy
import "./../utils"
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property string currentNamePath: Paths.strip(`${Paths.state}/wallpaper/path.txt`)
    
    Component.onCompleted: {
        // Ensure state directory exists
        Quickshell.execDetached(["mkdir", "-p", `${Paths.strip(Paths.state)}/wallpaper`]);
    }
    readonly property list<string> extensions: ["jpg", "jpeg", "png", "webp", "tif", "tiff"]

    readonly property list<Wallpaper> list: wallpapers.instances
    property bool showPreview: false
    readonly property string current: showPreview ? previewPath : actualCurrent
    property string previewPath
    property string actualCurrent
    property bool previewColourLock

    readonly property list<var> preppedWalls: list.map(w => ({
                name: Fuzzy.prepare(w.name),
                path: Fuzzy.prepare(w.path),
                wall: w
            }))

    function fuzzyQuery(search: string): var {
        return Fuzzy.go(search, preppedWalls, {
            all: true,
            keys: ["name", "path"],
            scoreFn: r => r[0].score * 0.9 + r[1].score * 0.1
        }).map(r => r.obj.wall);
    }

    function setWallpaper(path: string): void {
        actualCurrent = path;
    }

    function setRandomWallpaper(): void {
        if (list.length > 0) {
            // Filter out the current wallpaper to ensure we always change
            const availableWallpapers = list.filter(w => w.path !== actualCurrent);
            
            if (availableWallpapers.length > 0) {
                const randomIndex = Math.floor(Math.random() * availableWallpapers.length);
                const randomWallpaper = availableWallpapers[randomIndex].path;
                setWallpaper(randomWallpaper);
            } else {
                // Fallback if somehow all wallpapers are current (shouldn't happen)
                const randomIndex = Math.floor(Math.random() * list.length);
                const randomWallpaper = list[randomIndex].path;
                setWallpaper(randomWallpaper);
            }
        }
    }

    function preview(path: string): void {
        previewPath = path;
        showPreview = true;

        // Color extraction disabled for now - no longer using caelestia
        // if (Colours.scheme === "dynamic")
        //     getPreviewColoursProc.running = true;
    }

    function stopPreview(): void {
        showPreview = false;
        if (!previewColourLock)
            Colours.showPreview = false;
    }

    reloadableId: "wallpapers"

    IpcHandler {
        target: "wallpaper"

        function get(): string {
            return root.actualCurrent;
        }

        function set(path: string): void {
            root.setWallpaper(path);
        }

        function list(): string {
            return root.list.map(w => w.path).join("\n");
        }

        function random(): void {
            root.setRandomWallpaper();
        }
    }

    FileView {
        path: root.currentNamePath
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            root.actualCurrent = text().trim();
            root.previewColourLock = false;
        }
    }

    // Color extraction process disabled - no longer using caelestia
    // Process {
    //     id: getPreviewColoursProc
    //
    //     command: ["caelestia", "wallpaper", "-p", root.previewPath]
    //     stdout: StdioCollector {
    //         onStreamFinished: {
    //             Colours.load(text, true);
    //             Colours.showPreview = true;
    //         }
    //     }
    // }

    Process {
        id: getWallsProc

        running: true
        command: ["find", Paths.expandTilde(Config.paths.wallpaperDir), "-type", "d", "-path", '*/.*', "-prune", "-o", "-not", "-name", '.*', "-type", "f", "-print"]
        stdout: StdioCollector {
            onStreamFinished: wallpapers.model = text.trim().split("\n").filter(w => root.extensions.includes(w.slice(w.lastIndexOf(".") + 1))).sort()
        }
    }

    Process {
        id: watchWallsProc

        running: true
        command: ["inotifywait", "-r", "-e", "close_write,moved_to,create", "-m", Paths.expandTilde(Config.paths.wallpaperDir)]
        stdout: SplitParser {
            onRead: data => {
                if (root.extensions.includes(data.slice(data.lastIndexOf(".") + 1)))
                    getWallsProc.running = true;
            }
        }
    }

    Connections {
        target: Config.paths

        function onWallpaperDirChanged(): void {
            getWallsProc.running = true;
            watchWallsProc.running = false;
            watchWallsProc.running = true;
        }
    }

    Variants {
        id: wallpapers

        Wallpaper {}
    }

    component Wallpaper: QtObject {
        required property string modelData
        readonly property string path: modelData
        readonly property string name: path.slice(path.lastIndexOf("/") + 1, path.lastIndexOf("."))
    }
}
