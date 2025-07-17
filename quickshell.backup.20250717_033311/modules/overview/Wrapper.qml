import "./../../config"
import Quickshell
import QtQuick

Item {
    id: root

    required property PersistentProperties visibilities

    visible: height > 0
    enabled: height > 0
    implicitHeight: 0
    implicitWidth: parent.width
    clip: true

    states: State {
        name: "visible"
        when: root.visibilities.overview

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

    Content {
        id: content
        
        anchors.fill: parent
        visibilities: root.visibilities
        
        opacity: root.visibilities.overview ? 1 : 0
        
        Behavior on opacity {
            NumberAnimation {
                duration: Appearance.anim.durations.normal
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.anim.curves.standard
            }
        }
    }
}