import "./../../services"
import "./../../config"
import "./../../widgets"
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    required property PersistentProperties visibilities

    // Configuration
    readonly property int gridColumns: 2
    readonly property int gridRows: 2
    readonly property int workspaceSpacing: 20  // Reduced spacing
    readonly property real windowScale: 0.25
    
    // Get actual workspaces
    readonly property var actualWorkspaces: {
        // Force reactivity
        HyprlandWindows.workspaceList
        return HyprlandWindows.workspaceList.sort((a, b) => a.id - b.id)
    }
    readonly property int maxWorkspaces: actualWorkspaces.length
    readonly property var windows: HyprlandWindows.windowList
    readonly property var windowByAddress: HyprlandWindows.windowByAddress

    // Drag state
    property int draggingFromWorkspace: -1
    property int draggingTargetWorkspace: -1

    // Rose Pine Dark theme colors
    color: "#191724"  // Rose Pine base (dark background)
    radius: Appearance.rounding.normal

    // Calculate workspace dimensions exactly like end4
    readonly property var monitor: Hyprland.focusedMonitor
    readonly property real monitorScale: monitor ? monitor.scale : 1.0
    readonly property real scale: 0.4  // Increased from 0.25 for better visibility
    
    // end4's exact formula (simplified since we're single monitor)
    readonly property real workspaceImplicitWidth: monitor ? (monitor.width * scale / monitorScale) : 400
    readonly property real workspaceImplicitHeight: monitor ? (monitor.height * scale / monitorScale) : 300
    
    // Use calculated dimensions
    readonly property real workspaceWidth: workspaceImplicitWidth
    readonly property real workspaceHeight: workspaceImplicitHeight

    // Main content area - end4 style centering
    Item {
        id: contentArea
        anchors.centerIn: parent
        width: gridColumns * workspaceImplicitWidth + (gridColumns - 1) * workspaceSpacing
        height: gridRows * workspaceImplicitHeight + (gridRows - 1) * workspaceSpacing

        // Workspace backgrounds
        ColumnLayout {
            id: workspaceLayout
            anchors.centerIn: parent
            spacing: workspaceSpacing

            Repeater {
                model: gridRows
                delegate: RowLayout {
                    property int rowIndex: index
                    spacing: workspaceSpacing
                    Layout.fillHeight: true

                    Repeater {
                        model: gridColumns
                        delegate: Rectangle {
                            property int colIndex: index
                            property int workspaceId: rowIndex * gridColumns + colIndex + 1
                            property bool isActive: Hyprland.focusedWorkspace.id === workspaceId
                            property bool workspaceExists: workspaceId <= root.maxWorkspaces

                            width: workspaceWidth
                            height: workspaceHeight
                            radius: Appearance.rounding.normal
                            color: "#1f1d2e"  // Rose Pine surface (slightly lighter than base)
                            border.color: isActive ? "#c4a7e7" : "#6e6a86"  // Rose Pine iris (active) / muted (inactive)
                            border.width: isActive ? 3 : 1
                            visible: workspaceExists

                            Behavior on border.color {
                                ColorAnimation {
                                    duration: 200
                                    easing.type: Easing.InOutQuad
                                }
                            }


                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    console.log(`Clicking workspace ${workspaceId}, current: ${Hyprland.focusedWorkspace.id}`)
                                    Hyprland.dispatch(`workspace ${workspaceId}`)
                                    root.visibilities.workspacemanager = false
                                }
                            }

                            DropArea {
                                anchors.fill: parent
                                onEntered: (drag) => {
                                    console.log(`[DropArea] Window entered workspace ${workspaceId}`)
                                    root.draggingTargetWorkspace = workspaceId
                                    parent.border.color = "#ebbcba"  // Rose Pine rose (hover state)
                                    parent.border.width = 3
                                }
                                onExited: {
                                    console.log(`[DropArea] Window exited workspace ${workspaceId}`)
                                    if (root.draggingTargetWorkspace === workspaceId) {
                                        root.draggingTargetWorkspace = -1
                                    }
                                    parent.border.color = isActive ? "#c4a7e7" : "#6e6a86"  // Rose Pine iris / muted
                                    parent.border.width = isActive ? 3 : 1
                                }
                                onDropped: (drop) => {
                                    console.log(`[DropArea] Window dropped on workspace ${workspaceId}`)
                                    root.draggingTargetWorkspace = workspaceId
                                }
                            }
                        }
                    }
                }
            }
        }

        // Windows layer
        Item {
            id: windowsLayer
            anchors.fill: parent
            z: 100

            Repeater {
                model: {
                    // Force reactivity
                    HyprlandWindows.windowList
                    return HyprlandWindows.windowList.filter(win => win.workspace.id <= root.maxWorkspaces)
                }

                delegate: OverviewWindow {
                    id: windowItem
                    required property var modelData

                    windowData: modelData
                    availableWorkspaceWidth: workspaceWidth
                    availableWorkspaceHeight: workspaceHeight
                    windowScale: root.windowScale
                    
                    // Calculate position within workspace grid
                    property int workspaceIndex: modelData.workspace.id - 1
                    property int workspaceRow: Math.floor(workspaceIndex / gridColumns)
                    property int workspaceCol: workspaceIndex % gridColumns

                    // end4's exact positioning approach
                    property int workspaceColIndex: (modelData.workspace.id - 1) % gridColumns
                    property int workspaceRowIndex: Math.floor((modelData.workspace.id - 1) / gridColumns)
                    
                    // end4's workspace offset calculation
                    property real xOffset: (root.workspaceImplicitWidth + root.workspaceSpacing) * workspaceColIndex
                    property real yOffset: (root.workspaceImplicitHeight + root.workspaceSpacing) * workspaceRowIndex
                    
                    // end4's exact position formula (simplified for single monitor)
                    property real windowX: Math.round(Math.max(modelData.at[0] * root.scale, 0) + xOffset)
                    property real windowY: Math.round(Math.max(modelData.at[1] * root.scale, 0) + yOffset)
                    
                    // end4's exact size formula
                    property real windowWidth: modelData.size[0] * root.scale
                    property real windowHeight: modelData.size[1] * root.scale

                    // Set position and size
                    property real initX: windowX
                    property real initY: windowY

                    x: initX
                    y: initY
                    width: windowWidth
                    height: windowHeight

                }
            }
        }
    }

    // Keyboard navigation
    Keys.onPressed: (event) => {
        const current = Hyprland.focusedWorkspace.id
        let target = current

        switch(event.key) {
            case Qt.Key_Left:
                if ((current - 1) % gridColumns !== 0) target = current - 1
                break
            case Qt.Key_Right:
                if (current % gridColumns !== 0) target = current + 1
                break
            case Qt.Key_Up:
                if (current > gridColumns) target = current - gridColumns
                break
            case Qt.Key_Down:
                if (current <= maxWorkspaces - gridColumns) target = current + gridColumns
                break
            case Qt.Key_Return:
            case Qt.Key_Enter:
                root.visibilities.workspacemanager = false
                return
        }

        if (target !== current && target > 0 && target <= maxWorkspaces) {
            Hyprland.dispatch(`workspace ${target}`)
        }
    }
}