import "./../../services"
import "./../../config"
import "./../../widgets"
import Quickshell
import QtQuick

Item {
    id: root

    required property PersistentProperties visibilities

    // Only take up space when visible
    width: visibilities.workspacemanager ? parent.width : 0
    height: visibilities.workspacemanager ? parent.height : 0
    
    // Completely disable when not visible
    visible: visibilities.workspacemanager

    // Semi-transparent background overlay
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.7)
        opacity: visibilities.workspacemanager ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: 250
                easing.type: Easing.OutCubic
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.visibilities.workspacemanager = false
        }
    }

    // Main workspace overview container
    WorkspaceOverview {
        id: overview
        anchors.centerIn: parent
        width: Math.min(parent.width * 0.95, 1200)
        height: Math.min(parent.height * 0.9, 800)
        visibilities: root.visibilities
        opacity: visibilities.workspacemanager ? 1 : 0
        
        transform: Scale {
            xScale: visibilities.workspacemanager ? 1 : 0.8
            yScale: visibilities.workspacemanager ? 1 : 0.8
            origin.x: overview.width / 2
            origin.y: overview.height / 2
            
            Behavior on xScale {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.OutBack
                }
            }
            
            Behavior on yScale {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.OutBack
                }
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 250
                easing.type: Easing.OutCubic
            }
        }
    }

    // ESC key handling
    Keys.onEscapePressed: root.visibilities.workspacemanager = false
    focus: visibilities.workspacemanager
}