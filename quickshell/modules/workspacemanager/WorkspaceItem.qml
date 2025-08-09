import "./../../services"
import "./../../config"
import "./../../widgets"
import Quickshell
import Quickshell.Hyprland
import QtQuick

Rectangle {
    id: root

    required property int workspaceId
    property bool isActive: false
    
    signal windowDragStarted(var window)
    signal windowDragEnded()
    signal dropEntered()
    signal dropExited()
    signal clicked()

    color: Colours.alpha(Colours.palette.m3surfaceContainer, dropArea.containsDrag ? 0.9 : 0.7)
    border.color: isActive ? Colours.palette.m3primary : Colours.palette.m3outline
    border.width: isActive ? 3 : 1
    radius: Appearance.rounding.normal

    Behavior on color {
        ColorAnimation {
            duration: 200
            easing.type: Easing.InOutQuad
        }
    }

    Behavior on border.color {
        ColorAnimation {
            duration: 200
            easing.type: Easing.InOutQuad
        }
    }

    // Workspace label
    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 10
        width: 30
        height: 30
        radius: 15
        color: isActive ? Colours.palette.m3primary : Colours.palette.m3secondaryContainer
        
        StyledText {
            anchors.centerIn: parent
            text: workspaceId.toString()
            color: isActive ? Colours.palette.m3onPrimary : Colours.palette.m3onSecondaryContainer
            font.weight: Font.Medium
            font.pixelSize: 14
        }
    }

    // Drop area for dragged windows
    DropArea {
        id: dropArea
        anchors.fill: parent
        
        onEntered: root.dropEntered()
        onExited: root.dropExited()
    }

    // Window previews
    Item {
        anchors.fill: parent
        anchors.margins: 10
        clip: true

        // Simple grid layout for windows
        Grid {
            anchors.fill: parent
            columns: Math.ceil(Math.sqrt(windowRepeater.count))
            spacing: 5

            Repeater {
                id: windowRepeater
                model: {
                    // Force reactivity by referencing the windowList
                    HyprlandWindows.windowList
                    return HyprlandWindows.getWindowsForWorkspace(workspaceId)
                }

                WindowPreview {
                    required property var modelData
                    
                    window: modelData
                    width: (parent.width - parent.spacing * (parent.columns - 1)) / parent.columns
                    height: (parent.height - parent.spacing * (Math.ceil(windowRepeater.count / parent.columns) - 1)) / Math.ceil(windowRepeater.count / parent.columns)
                    
                    onDragStarted: root.windowDragStarted(window)
                    onDragEnded: root.windowDragEnded()
                }
            }
        }
    }

    // Empty workspace indicator
    StyledText {
        anchors.centerIn: parent
        text: "Empty"
        color: Colours.alpha(Colours.palette.m3onSurfaceVariant, 0.5)
        font.pixelSize: 16
        visible: windowRepeater.count === 0
    }

    MouseArea {
        anchors.fill: parent
        enabled: !dropArea.containsDrag
        onClicked: root.clicked()
    }
}