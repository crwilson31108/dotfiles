import "./../../services"
import "./../../config"
import "./../../widgets"
import Quickshell
import Quickshell.Hyprland
import QtQuick

Rectangle {
    id: root

    required property var window
    
    signal dragStarted()
    signal dragEnded()

    color: dragArea.pressed ? Colours.palette.m3primaryContainer : Colours.palette.m3surfaceContainerHigh
    border.color: dragArea.containsMouse ? Colours.palette.m3primary : Colours.palette.m3outline
    border.width: dragArea.containsMouse ? 2 : 1
    radius: Appearance.rounding.small
    clip: true

    Behavior on color {
        ColorAnimation {
            duration: 150
            easing.type: Easing.InOutQuad
        }
    }

    // Window content preview (simplified - just show app info)
    Column {
        anchors.centerIn: parent
        spacing: 5

        // App icon
        MaterialIcon {
            anchors.horizontalCenter: parent.horizontalCenter
            text: WindowIconMapper.getIcon(window.class)
            font.pixelSize: Math.min(root.width, root.height) * 0.3
            color: Colours.palette.m3onSurface
        }

        // Window title
        StyledText {
            anchors.horizontalCenter: parent.horizontalCenter
            text: window.title || window.class
            color: Colours.palette.m3onSurface
            font.pixelSize: 10
            elide: Text.ElideRight
            width: root.width - 10
            horizontalAlignment: Text.AlignHCenter
        }
    }

    // Drag handling
    MouseArea {
        id: dragArea
        anchors.fill: parent
        hoverEnabled: true
        
        drag.target: dragItem
        drag.axis: Drag.XAndYAxis
        
        onPressed: {
            dragItem.startDrag()
            root.dragStarted()
        }
        
        onReleased: {
            dragItem.Drag.drop()
            root.dragEnded()
        }

        // Middle click to close
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
        onClicked: (mouse) => {
            if (mouse.button === Qt.MiddleButton) {
                Hyprland.exec(`closewindow address:${window.address}`)
            }
        }
    }

    // Draggable item
    Item {
        id: dragItem
        width: root.width
        height: root.height
        visible: Drag.active
        
        Drag.active: dragArea.drag.active
        Drag.hotSpot.x: width / 2
        Drag.hotSpot.y: height / 2
        
        function startDrag() {
            // Create a visual copy for dragging
            dragVisual.window = root.window
            dragVisual.visible = true
            parent = root.parent.parent.parent.parent // Move to overview level
            z = 9999
        }
        
        Rectangle {
            id: dragVisual
            property var window: null
            
            anchors.fill: parent
            color: Colours.alpha(Colours.palette.m3primaryContainer, 0.8)
            border.color: Colours.palette.m3primary
            border.width: 2
            radius: Appearance.rounding.small
            visible: false
            
            Column {
                anchors.centerIn: parent
                spacing: 5

                MaterialIcon {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: WindowIconMapper.getIcon(dragVisual.window ? dragVisual.window.class : "")
                    font.pixelSize: 32
                    color: Colours.palette.m3onPrimaryContainer
                }

                StyledText {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: dragVisual.window ? (dragVisual.window.title || dragVisual.window.class) : ""
                    color: Colours.palette.m3onPrimaryContainer
                    font.pixelSize: 12
                    elide: Text.ElideRight
                    width: dragVisual.width - 10
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }

    // XWayland indicator
    Rectangle {
        visible: window.xwayland
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 4
        width: 20
        height: 20
        radius: 10
        color: Colours.palette.m3error
        
        StyledText {
            anchors.centerIn: parent
            text: "X"
            color: Colours.palette.m3onError
            font.pixelSize: 12
            font.weight: Font.Bold
        }
    }
}