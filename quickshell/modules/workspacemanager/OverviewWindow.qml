import "./../../services"
import "./../../config"
import "./../../widgets"
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick

Rectangle {
    id: root

    required property var windowData
    property real availableWorkspaceWidth: 300
    property real availableWorkspaceHeight: 200
    property real windowScale: 0.15


    // Window properties
    property bool hovered: dragArea.containsMouse
    property bool pressed: dragArea.pressed
    property bool compactMode: width < 100 || height < 100
    property bool atInitPosition: true

    // Drag properties  
    property bool isDragging: Drag.active
    property real initX: x
    property real initY: y

    // Rose Pine Dark theme colors for windows
    color: pressed ? "#c4a7e780" :   // Rose Pine iris with transparency (pressed)
           hovered ? "#31748f60" :   // Rose Pine pine with transparency (hovered)
           "#26233a60"              // Rose Pine overlay with transparency (default)
    
    border.color: hovered ? "#c4a7e7" : "#6e6a8680"  // Rose Pine iris (hovered) / muted (default)
    border.width: hovered ? 2 : 1
    radius: Appearance.rounding.small

    // Higher z-index when dragging
    z: isDragging ? 999 : 1

    // Drag properties
    Drag.active: dragArea.drag.active
    Drag.hotSpot.x: width / 2
    Drag.hotSpot.y: height / 2
    Drag.source: root

    Behavior on color {
        ColorAnimation {
            duration: 150
            easing.type: Easing.InOutQuad
        }
    }

    Behavior on border.color {
        ColorAnimation {
            duration: 150
            easing.type: Easing.InOutQuad
        }
    }

    // Smooth return to position
    Behavior on x {
        enabled: !isDragging
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }

    Behavior on y {
        enabled: !isDragging
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }

    // Live window preview
    ScreencopyView {
        id: windowPreview
        anchors.fill: parent
        anchors.margins: 2
        
        // Find the toplevel for this window
        captureSource: {
            const toplevels = ToplevelManager.toplevels.values
            for (let toplevel of toplevels) {
                const address = `0x${toplevel.HyprlandToplevel.address}`
                if (address === windowData.address) {
                    return toplevel
                }
            }
            return null
        }
        
        live: root.parent.parent.parent.visibilities.workspacemanager
        
        Rectangle {
            anchors.fill: parent
            radius: parent.parent.radius - 2
            color: "transparent"
            border.color: root.border.color
            border.width: 1
            visible: !windowPreview.captureSource
        }
    }

    // App icon and title overlay
    Item {
        anchors.fill: parent
        anchors.margins: 4
        visible: compactMode || !windowPreview.captureSource

        Column {
            anchors.centerIn: parent
            spacing: 4

            // App icon
            IconImage {
                anchors.horizontalCenter: parent.horizontalCenter
                source: Quickshell.iconPath(WindowIconMapper.getIconForWindow(windowData), "image-missing")
                implicitSize: Math.min(root.width, root.height) * 0.4
            }

            // Window title
            StyledText {
                anchors.horizontalCenter: parent.horizontalCenter
                text: windowData.title || windowData.class
                color: "#e0def4"  // Rose Pine text
                font.pixelSize: 10
                elide: Text.ElideRight
                width: root.width - 8
                horizontalAlignment: Text.AlignHCenter
                visible: root.height > 40
            }
        }
    }

    // XWayland indicator
    Rectangle {
        visible: windowData.xwayland
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 4
        width: 16
        height: 16
        radius: 8
        color: "#eb6f92"  // Rose Pine love (error/warning color)
        
        StyledText {
            anchors.centerIn: parent
            text: "X"
            color: "#191724"  // Rose Pine base (dark text on light background)
            font.pixelSize: 10
            font.weight: Font.Bold
        }
    }

    // Position update timer - similar to end4's implementation
    Timer {
        id: updateWindowPosition
        interval: 50
        repeat: false
        running: false
        onTriggered: {
            // Force position refresh after window move
            HyprlandWindows.refresh()
        }
    }

    // Snap-back animation
    ParallelAnimation {
        id: snapBackAnimation
        NumberAnimation {
            target: root
            property: "x"
            to: root.initX
            duration: 200
            easing.type: Easing.OutQuad
        }
        NumberAnimation {
            target: root
            property: "y" 
            to: root.initY
            duration: 200
            easing.type: Easing.OutQuad
        }
    }

    // Drag handling - following end4's exact approach
    MouseArea {
        id: dragArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
        
        // Enable dragging
        drag.target: root
        drag.axis: Drag.XAndYAxis

        onPressed: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                // Find the WorkspaceOverview component (our root)
                var workspaceOverview = root
                while (workspaceOverview && !workspaceOverview.hasOwnProperty('draggingFromWorkspace')) {
                    workspaceOverview = workspaceOverview.parent
                }
                
                if (workspaceOverview) {
                    workspaceOverview.draggingFromWorkspace = windowData.workspace.id
                    workspaceOverview.draggingTargetWorkspace = -1  // Reset target
                }
                
                root.pressed = true
                root.Drag.active = true
                root.Drag.source = root
                root.Drag.hotSpot.x = mouse.x
                root.Drag.hotSpot.y = mouse.y
                root.atInitPosition = false
                
                console.log(`[OverviewWindow] Dragging window ${windowData.address} from workspace ${windowData.workspace.id}`)
            }
        }

        onReleased: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                // Find the WorkspaceOverview component 
                var workspaceOverview = root
                while (workspaceOverview && !workspaceOverview.hasOwnProperty('draggingTargetWorkspace')) {
                    workspaceOverview = workspaceOverview.parent
                }
                
                const targetWorkspace = workspaceOverview ? workspaceOverview.draggingTargetWorkspace : -1
                root.pressed = false
                root.Drag.active = false
                
                if (workspaceOverview) {
                    workspaceOverview.draggingFromWorkspace = -1
                }
                
                console.log(`[OverviewWindow] Released. Target: ${targetWorkspace}, Current: ${windowData.workspace.id}`)
                
                if (targetWorkspace !== -1 && targetWorkspace !== windowData.workspace.id) {
                    console.log(`[OverviewWindow] Moving window ${windowData.address} to workspace ${targetWorkspace}`)
                    Hyprland.dispatch(`movetoworkspacesilent ${targetWorkspace}, address:${windowData.address}`)
                    updateWindowPosition.restart()
                } else if (targetWorkspace === windowData.workspace.id) {
                    console.log(`[OverviewWindow] Dropped in same workspace ${targetWorkspace} - returning to original position`)
                    // Animate snap-back
                    snapBackAnimation.restart()
                } else {
                    console.log(`[OverviewWindow] Dropped outside valid area (target: ${targetWorkspace}) - snapping back`)
                    // Animate snap-back  
                    snapBackAnimation.restart()
                }
                
                root.atInitPosition = true
            }
        }

        onClicked: (mouse) => {
            if (mouse.button === Qt.MiddleButton) {
                // Close window
                Hyprland.dispatch(`closewindow address:${windowData.address}`)
            } else if (mouse.button === Qt.LeftButton && !dragArea.drag.active) {
                // Focus window and close overview
                Hyprland.dispatch(`focuswindow address:${windowData.address}`)
                root.parent.parent.parent.visibilities.workspacemanager = false
            }
        }
    }
}