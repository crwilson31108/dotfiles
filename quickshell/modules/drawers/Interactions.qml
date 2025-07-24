import "./../../services"
import "./../../config"
import "./../bar/popouts" as BarPopouts
import "./../osd" as Osd
import Quickshell
import QtQuick

MouseArea {
    id: root

    required property ShellScreen screen
    required property BarPopouts.Wrapper popouts
    required property PersistentProperties visibilities
    required property Panels panels
    required property Item bar

    property bool osdHovered
    property point dragStart
    property bool dashboardShortcutActive
    property bool osdShortcutActive


    function withinPanelHeight(panel: Item, x: real, y: real): bool {
        const panelY = Config.border.thickness + panel.y;
        return y >= panelY - Config.border.rounding && y <= panelY + panel.height + Config.border.rounding;
    }

    function withinPanelWidth(panel: Item, x: real, y: real): bool {
        const panelX = Config.border.thickness + panel.x;
        return x >= panelX - Config.border.rounding && x <= panelX + panel.width + Config.border.rounding;
    }

    function inRightPanel(panel: Item, x: real, y: real): bool {
        return x > bar.implicitHeight + panel.x && withinPanelHeight(panel, x, y);
    }

    function inTopPanel(panel: Item, x: real, y: real): bool {
        const panelX = Config.border.thickness + panel.x;
        return y < bar.implicitHeight + panel.y + panel.height && x >= panelX - Config.border.rounding && x <= panelX + panel.width + Config.border.rounding;
    }

    function inBottomPanel(panel: Item, x: real, y: real): bool {
        const panelX = Config.border.thickness + panel.x;
        return y > panel.y && x >= panelX - Config.border.rounding && x <= panelX + panel.width + Config.border.rounding;
    }

    anchors.fill: parent
    hoverEnabled: true
    acceptedButtons: Qt.NoButton


    onContainsMouseChanged: {
        if (!containsMouse) {
            // Only hide if not activated by shortcut
            if (!osdShortcutActive) {
                visibilities.osd = false;
                osdHovered = false;
            }
            if (!dashboardShortcutActive) {
                visibilities.dashboard = false;
            }
            // Always dismiss popouts when mouse leaves the interaction area
            popouts.hasCurrent = false;
        }
    }

    onPositionChanged: event => {
        const x = event.x;
        const y = event.y;
        

        // Show osd on hover - custom right-side trigger for horizontal bar
        const rightEdgeStart = root.width - 100; // Trigger area 100px from right edge
        const osdPanelTop = panels.osd.y;
        const osdPanelBottom = panels.osd.y + panels.osd.height;
        const showOsd = x >= rightEdgeStart && y >= osdPanelTop && y <= osdPanelBottom;

        // Always update visibility based on hover if not in shortcut mode
        if (!osdShortcutActive) {
            visibilities.osd = showOsd;
            osdHovered = showOsd;
        } else if (showOsd) {
            // If hovering over OSD area while in shortcut mode, transition to hover control
            osdShortcutActive = false;
            osdHovered = true;
        }


        
        // Show dashboard on hover - bottom edge trigger OR content hover
        const bottomEdgeStart = root.height - 100 - Config.border.thickness;
        const dashboardPanelLeft = panels.dashboard.x || 0;
        const dashboardPanelRight = (panels.dashboard.x || 0) + (panels.dashboard.width || root.width);
        
        // Bottom edge trigger
        const bottomEdgeTrigger = y >= bottomEdgeStart && x >= dashboardPanelLeft && x <= dashboardPanelRight;
        
        // Dashboard content hover (when visible) - use expanded area to catch tab zones
        const dashboardContentTrigger = visibilities.dashboard && 
            y >= panels.dashboard.y && y <= root.height - Config.border.thickness && // Extend to bottom edge
            x >= panels.dashboard.x && x <= (panels.dashboard.x + panels.dashboard.width);
        
        const showDashboard = bottomEdgeTrigger || dashboardContentTrigger;
        

        // Always update visibility based on hover if not in shortcut mode
        if (!dashboardShortcutActive) {
            visibilities.dashboard = showDashboard;
        } else if (showDashboard) {
            // If hovering over dashboard area while in shortcut mode, transition to hover control
            dashboardShortcutActive = false;
        }

        // Show popouts on hover - adapted for horizontal bar
        const popout = panels.popouts;
        
        // For horizontal bar: popouts are positioned at y=0 relative to the panels area
        // which starts at bar.implicitHeight. So the actual popout area is:
        // bar.implicitHeight (top of panels) + popout.height
        const popoutBottomY = bar.implicitHeight + popout.height;
        
        if (y < popoutBottomY) {
            if (y < bar.implicitHeight) {
                // Handle like part of bar
                bar.checkPopout(x);
            } else {
                // Keep on hover in popup area - don't change hasCurrent
                // Only keep visible if there's actually a current popup
                if (popouts.hasCurrent) {
                    // Do nothing - keep it visible
                } else {
                    // Mouse is in popup area but no popup is active, dismiss
                    popouts.hasCurrent = false;
                }
            }
        } else {
            popouts.hasCurrent = false;
        }
    }

    // Monitor individual visibility changes
    Connections {
        target: root.visibilities

        function onLauncherChanged() {
            // If launcher is hidden, clear shortcut flags for dashboard and OSD
            if (!root.visibilities.launcher) {
                root.dashboardShortcutActive = false;
                root.osdShortcutActive = false;

                // Also hide dashboard and OSD if they're not being hovered
                const bottomEdgeStart = root.height - 100 - Config.border.thickness;
                const dashboardPanelLeft = root.panels.dashboard.x || 0;
                const dashboardPanelRight = (root.panels.dashboard.x || 0) + (root.panels.dashboard.width || root.width);
                
                // Check both bottom edge and dashboard content - extend to bottom edge
                const bottomEdgeTrigger = root.mouseY >= bottomEdgeStart && root.mouseX >= dashboardPanelLeft && root.mouseX <= dashboardPanelRight;
                const dashboardContentTrigger = root.visibilities.dashboard && 
                    root.mouseY >= root.panels.dashboard.y && root.mouseY <= root.height - Config.border.thickness &&
                    root.mouseX >= root.panels.dashboard.x && root.mouseX <= (root.panels.dashboard.x + root.panels.dashboard.width);
                
                const inDashboardArea = bottomEdgeTrigger || dashboardContentTrigger;
                const inOsdArea = root.inRightPanel(root.panels.osd, root.mouseX, root.mouseY);

                if (!inDashboardArea) {
                    root.visibilities.dashboard = false;
                }
                if (!inOsdArea) {
                    root.visibilities.osd = false;
                    root.osdHovered = false;
                }
            }
        }

        function onDashboardChanged() {
            if (root.visibilities.dashboard) {
                // Dashboard became visible, immediately check if this should be shortcut mode
                const inDashboardArea = root.inBottomPanel(root.panels.dashboard, root.mouseX, root.mouseY);
                if (!inDashboardArea) {
                    root.dashboardShortcutActive = true;
                }
            } else {
                // Dashboard hidden, clear shortcut flag
                root.dashboardShortcutActive = false;
            }
        }

        function onOsdChanged() {
            if (root.visibilities.osd) {
                // OSD became visible, immediately check if this should be shortcut mode
                const inOsdArea = root.inRightPanel(root.panels.osd, root.mouseX, root.mouseY);
                if (!inOsdArea) {
                    root.osdShortcutActive = true;
                }
            } else {
                // OSD hidden, clear shortcut flag
                root.osdShortcutActive = false;
            }
        }
    }

    Osd.Interactions {
        screen: root.screen
        visibilities: root.visibilities
        hovered: root.osdHovered
    }
}
