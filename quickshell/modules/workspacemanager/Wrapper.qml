import "./../../services"
import "./../../config"
import "./../../widgets"
import Quickshell
import QtQuick

Item {
    id: root

    required property PersistentProperties visibilities

    // Only take up space when visible (like Overview)
    visible: height > 0
    enabled: height > 0
    implicitHeight: 0
    implicitWidth: parent.width
    clip: true

    states: State {
        name: "visible"
        when: root.visibilities.workspacemanager

        PropertyChanges {
            root.implicitHeight: parent.height
        }
    }

    transitions: [
        Transition {
            from: ""
            to: "visible"

            NumberAnimation {
                target: root
                property: "implicitHeight"
                duration: Appearance.anim.durations.expressiveDefaultSpatial
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.anim.curves.expressiveDefaultSpatial
            }
        },
        Transition {
            from: "visible"
            to: ""

            NumberAnimation {
                target: root
                property: "implicitHeight"
                duration: Appearance.anim.durations.normal
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.anim.curves.emphasized
            }
        }
    ]

    // Background with integrated click handling (like Overview)
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.7)
        radius: Appearance.rounding.normal
        opacity: visibilities.workspacemanager ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: 250
                easing.type: Easing.OutCubic
            }
        }

        MouseArea {
            anchors.fill: parent
            enabled: root.visibilities.workspacemanager
            visible: root.visibilities.workspacemanager
            propagateComposedEvents: true  // Always allow events to propagate to children
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