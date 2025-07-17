pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import "./../../config"

Item {
    id: root

    required property PersistentProperties visibilities
    readonly property PersistentProperties state: PersistentProperties {
        property int currentTab
    }

    visible: height > 0
    implicitHeight: 0
    implicitWidth: content.implicitWidth

    states: State {
        name: "visible"
        when: root.visibilities.dashboard

        PropertyChanges {
            root.implicitHeight: content.implicitHeight
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

    Loader {
        id: content

        Component.onCompleted: active = Qt.binding(() => root.visibilities.dashboard || root.visible)
        
        clip: true  // Clip content that extends beyond the animated height
        
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.top: parent.top  // Make content fill the animated height area

        sourceComponent: Content {
            visibilities: root.visibilities
            state: root.state
        }
    }
}
