import "./../widgets"
import "./../services"
import Quickshell
import Quickshell.Io

Scope {
    id: root

    property bool launcherInterrupted

    CustomShortcut {
        name: "showall"
        description: "Toggle launcher, dashboard and osd"
        onPressed: {
            const v = Visibilities.getForActive();
            v.launcher = v.dashboard = v.osd = !(v.launcher || v.dashboard || v.osd);
        }
    }

    CustomShortcut {
        name: "session"
        description: "Toggle session menu"
        onPressed: {
            const visibilities = Visibilities.getForActive();
            visibilities.session = !visibilities.session;
        }
    }

    CustomShortcut {
        name: "launcher"
        description: "Toggle launcher"
        onPressed: root.launcherInterrupted = false
        onReleased: {
            if (!root.launcherInterrupted) {
                const visibilities = Visibilities.getForActive();
                visibilities.launcher = !visibilities.launcher;
            }
            root.launcherInterrupted = false;
        }
    }

    CustomShortcut {
        name: "launcherInterrupt"
        description: "Interrupt launcher keybind"
        onPressed: root.launcherInterrupted = true
    }

    CustomShortcut {
        name: "windowswitcher"
        description: "Alt+Tab window switcher"
        onPressed: WindowSwitcher.onTabPressed()
    }

    CustomShortcut {
        name: "overview"
        description: "Toggle overview (activities)"
        onPressed: {
            const visibilities = Visibilities.getForActive();
            visibilities.overview = !visibilities.overview;
        }
    }


    IpcHandler {
        target: "drawers"

        function toggle(drawer: string): void {
            if (list().split("\n").includes(drawer)) {
                const visibilities = Visibilities.getForActive();
                
                // Special case for windowswitcher - don't toggle, just trigger
                if (drawer === "windowswitcher") {
                    WindowSwitcher.onNext();
                } else {
                    // For overview, ensure we properly track state
                    if (drawer === "overview") {
                        // If it's currently true, set to false
                        // If it's currently false or undefined, set to true
                        visibilities[drawer] = visibilities[drawer] ? false : true;
                    } else {
                        visibilities[drawer] = !visibilities[drawer];
                    }
                }
            } else {
                console.warn(`[IPC] Drawer "${drawer}" does not exist`);
            }
        }

        function dismiss(drawer: string): void {
            if (list().split("\n").includes(drawer)) {
                const visibilities = Visibilities.getForActive();
                visibilities[drawer] = false;
            } else {
                console.warn(`[IPC] Drawer "${drawer}" does not exist`);
            }
        }

        function list(): string {
            const visibilities = Visibilities.getForActive();
            const drawerList = Object.keys(visibilities).filter(k => typeof visibilities[k] === "boolean");
            return drawerList.join("\n");
        }
    }


}
