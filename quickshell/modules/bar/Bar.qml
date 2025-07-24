import "./../../widgets"
import "./../../services"
import "./../../config"
import "./popouts" as BarPopouts
import "components"
import "components/workspaces"
import Quickshell
import QtQuick

Item {
    id: root

    required property ShellScreen screen
    required property BarPopouts.Wrapper popouts
    required property PersistentProperties visibilities

    function checkPopout(x: real): void {
        const spacing = Appearance.spacing.small;
        const aw = activeWindow.child;
        const awx = activeWindow.x + aw.x;

        const tx = tray.x;
        const tw = tray.implicitWidth;
        const trayItems = tray.items;

        const n = statusIconsInner.network;
        const nx = statusIcons.x + statusIconsInner.x + n.x - spacing / 2;

        const bls = statusIcons.x + statusIconsInner.x + statusIconsInner.bs - spacing / 2;
        const ble = statusIcons.x + statusIconsInner.x + statusIconsInner.be + spacing / 2;

        const b = statusIconsInner.battery;
        const bx = statusIcons.x + statusIconsInner.x + b.x - spacing / 2;

        const cx = clock.x - spacing / 2;


        if (x >= awx && x <= awx + aw.implicitWidth) {
            popouts.currentName = "activewindow";
            popouts.currentCenter = Qt.binding(() => activeWindow.x + aw.x + aw.implicitWidth / 2);
            popouts.hasCurrent = true;
        } else if (x > tx && x < tx + tw) {
            const index = Math.floor(((x - tx) / tw) * trayItems.count);
            const item = trayItems.itemAt(index);

            popouts.currentName = `traymenu${index}`;
            popouts.currentCenter = Qt.binding(() => tray.x + item.x + item.implicitWidth / 2);
            popouts.hasCurrent = true;
        } else if (x >= nx && x <= nx + n.implicitWidth + spacing) {
            popouts.currentName = "network";
            popouts.currentCenter = Qt.binding(() => statusIcons.x + statusIconsInner.x + n.x + n.implicitWidth / 2);
            popouts.hasCurrent = true;
        } else if (x >= bls && x <= ble) {
            popouts.currentName = "bluetooth";
            popouts.currentCenter = Qt.binding(() => statusIcons.x + statusIconsInner.x + statusIconsInner.bs + (statusIconsInner.be - statusIconsInner.bs) / 2);
            popouts.hasCurrent = true;
        } else if (x >= bx && x <= bx + b.implicitWidth + spacing) {
            popouts.currentName = "battery";
            popouts.currentCenter = Qt.binding(() => statusIcons.x + statusIconsInner.x + b.x + b.implicitWidth / 2);
            popouts.hasCurrent = true;
        } else if (x >= cx && x <= cx + clock.implicitWidth + spacing) {
            popouts.currentName = "calendar";
            popouts.currentCenter = Qt.binding(() => clock.x + clock.implicitWidth / 2);
            popouts.hasCurrent = true;
        } else {
            popouts.hasCurrent = false;
        }
    }


    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right

    implicitHeight: child.implicitHeight + Config.border.thickness / 2

    Item {
        id: child

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        implicitHeight: Math.max(osIcon.implicitHeight, workspaces.implicitHeight, activeWindow.implicitHeight, tray.implicitHeight, clock.implicitHeight, statusIcons.implicitHeight, power.implicitHeight)

        OsIcon {
            id: osIcon

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: Appearance.padding.large
            
            visibilities: root.visibilities
        }

        StyledRect {
            id: workspaces

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: osIcon.right
            anchors.leftMargin: Appearance.spacing.normal

            radius: Appearance.rounding.full
            color: Colours.palette.m3surfaceContainer

            implicitWidth: workspacesInner.implicitWidth + Appearance.padding.small * 2
            implicitHeight: workspacesInner.implicitHeight + Appearance.padding.small * 2

            MouseArea {
                anchors.fill: parent
                anchors.leftMargin: -Config.border.thickness
                anchors.rightMargin: -Config.border.thickness
                acceptedButtons: Qt.NoButton
                propagateComposedEvents: true

                property bool scrollCooldown: false
                property int scrollAccumulator: 0

                Timer {
                    id: scrollTimer
                    interval: 200  // 200ms cooldown
                    repeat: false
                    onTriggered: parent.scrollCooldown = false
                }

                Timer {
                    id: accumulatorTimer
                    interval: 50  // Reset accumulator after 50ms of no scrolling
                    repeat: false
                    onTriggered: parent.scrollAccumulator = 0
                }

                onWheel: event => {
                    if (scrollCooldown) return;
                    
                    const activeWs = Hyprland.activeToplevel?.workspace?.name;
                    if (activeWs?.startsWith("special:")) {
                        Hyprland.dispatch(`togglespecialworkspace ${activeWs.slice(8)}`);
                        return;
                    }
                    
                    // Accumulate scroll delta
                    scrollAccumulator += event.angleDelta.y;
                    accumulatorTimer.restart();
                    
                    // Only switch workspace if we've accumulated enough scroll distance
                    const threshold = 120; // Standard scroll wheel click is 120 units
                    if (Math.abs(scrollAccumulator) >= threshold) {
                        const currentWs = Hyprland.activeWsId;
                        let nextWs;
                        
                        if (scrollAccumulator > 0) {
                            // Scroll up - go to previous workspace
                            nextWs = currentWs <= 1 ? 4 : currentWs - 1;
                        } else {
                            // Scroll down - go to next workspace
                            nextWs = currentWs >= 4 ? 1 : currentWs + 1;
                        }
                        
                        Hyprland.dispatch(`workspace ${nextWs}`);
                        scrollCooldown = true;
                        scrollAccumulator = 0;
                        scrollTimer.start();
                    }
                }
            }

            Workspaces {
                id: workspacesInner

                anchors.centerIn: parent
            }
        }

        ActiveWindow {
            id: activeWindow

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: workspaces.right
            anchors.leftMargin: Appearance.spacing.larger
            anchors.right: tray.left
            anchors.rightMargin: Appearance.spacing.large

            monitor: Brightness.getMonitorForScreen(root.screen)
        }

        Tray {
            id: tray

            anchors.verticalCenter: parent.verticalCenter
            anchors.right: clock.left
            anchors.rightMargin: Appearance.spacing.larger
        }

        Clock {
            id: clock

            anchors.verticalCenter: parent.verticalCenter
            anchors.right: statusIcons.left
            anchors.rightMargin: Appearance.spacing.normal
        }

        StyledRect {
            id: statusIcons

            anchors.verticalCenter: parent.verticalCenter
            anchors.right: power.left
            anchors.rightMargin: Appearance.spacing.normal

            radius: Appearance.rounding.full
            color: Colours.palette.m3surfaceContainer

            implicitWidth: statusIconsInner.implicitWidth + Appearance.padding.normal * 2
            implicitHeight: statusIconsInner.implicitHeight + Appearance.padding.normal * 2

            StatusIcons {
                id: statusIconsInner

                anchors.centerIn: parent
            }
        }

        Power {
            id: power

            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: Appearance.padding.large
        }
    }
}
