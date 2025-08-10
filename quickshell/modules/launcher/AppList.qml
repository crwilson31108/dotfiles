pragma ComponentBehavior: Bound

import "./../../widgets"
import "./../../services"
import "./../../config"
import Quickshell
import QtQuick
import QtQuick.Controls

ListView {
    id: root

    required property TextField search
    required property PersistentProperties visibilities

    property bool isAction: search.text.startsWith(Config.launcher.actionPrefix)
    property bool isCalc: search.text.startsWith(`${Config.launcher.actionPrefix}calc `)
    property bool isScheme: search.text.startsWith(`${Config.launcher.actionPrefix}scheme `)
    property bool isVariant: search.text.startsWith(`${Config.launcher.actionPrefix}variant `)

    function getModelValues() {
        let text = search.text;
        if (isCalc)
            return [0];
        if (isScheme)
            return Schemes.fuzzyQuery(text);
        if (isVariant)
            return M3Variants.fuzzyQuery(text);
        if (isAction)
            return Actions.fuzzyQuery(text);
        if (text.startsWith(Config.launcher.actionPrefix))
            text = search.text.slice(Config.launcher.actionPrefix.length);
        return Apps.fuzzyQuery(text);
    }

    model: ScriptModel {
        values: root.getModelValues()
        onValuesChanged: root.currentIndex = 0
    }

    spacing: Appearance.spacing.small
    orientation: Qt.Vertical
    implicitHeight: (Config.launcher.sizes.itemHeight + spacing) * Math.min(Config.launcher.maxShown, count) - spacing

    highlightMoveDuration: Appearance.anim.durations.normal
    highlightResizeDuration: 0

    highlight: StyledRect {
        radius: Appearance.rounding.full
        color: Colours.palette.m3onSurface
        opacity: 0.08
    }

    delegate: {
        if (isCalc)
            return calcItem;
        if (isScheme)
            return schemeItem;
        if (isVariant)
            return variantItem;
        if (isAction)
            return actionItem;
        return appItem;
    }

    ScrollBar.vertical: StyledScrollBar {
        id: scrollBar
        stepSize: 0.5  // Much larger step size for faster scrolling
    }
    
    // Momentum scrolling variables
    property real velocity: 0
    property real lastWheelTime: 0
    property real targetContentY: contentY
    
    // Smooth scrolling behavior using Behavior animation
    Behavior on contentY {
        SmoothedAnimation {
            velocity: 4000  // Pixels per second - faster and more responsive
            duration: -1    // Use velocity-based timing
        }
    }
    
    // Momentum physics with smoother updates
    Timer {
        id: momentumTimer
        interval: 8  // 120fps for extra smoothness
        repeat: true
        onTriggered: {
            if (Math.abs(root.velocity) > 0.05) {  // Lower threshold for longer momentum
                // Calculate new target position
                const maxY = Math.max(0, root.contentHeight - root.height)
                root.targetContentY = Math.max(0, Math.min(root.targetContentY - root.velocity, maxY))
                
                // Update contentY (will be smoothed by Behavior)
                root.contentY = root.targetContentY
                
                // Apply friction - more gradual
                root.velocity *= 0.97
            } else {
                // Stop momentum when velocity is too low
                root.velocity = 0
                stop()
            }
        }
    }
    
    // Enhanced mouse wheel handling with momentum
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        onWheel: event => {
            const currentTime = Date.now()
            const deltaTime = Math.max(1, currentTime - root.lastWheelTime)
            root.lastWheelTime = currentTime
            
            // Calculate scroll amount
            const scrollDelta = event.angleDelta.y * 1.5  // Increased for more speed
            
            // Add to velocity for momentum
            const accelerationFactor = Math.min(1.8, 80 / deltaTime)
            root.velocity += (scrollDelta * accelerationFactor) * 0.08
            
            // Immediate response to wheel - more responsive
            const immediateScroll = scrollDelta * 0.25
            const maxY = Math.max(0, root.contentHeight - root.height)
            root.targetContentY = Math.max(0, Math.min(root.targetContentY - immediateScroll, maxY))
            root.contentY = root.targetContentY  // Smoothed by Behavior
            
            // Start momentum if not already running
            if (!momentumTimer.running) {
                momentumTimer.start()
            }
        }
    }

    add: Transition {
        Anim {
            properties: "opacity,scale"
            from: 0
            to: 1
        }
    }

    remove: Transition {
        Anim {
            properties: "opacity,scale"
            from: 1
            to: 0
        }
    }

    move: Transition {
        Anim {
            property: "y"
        }
        Anim {
            properties: "opacity,scale"
            to: 1
        }
    }

    addDisplaced: Transition {
        Anim {
            property: "y"
            duration: Appearance.anim.durations.small
        }
        Anim {
            properties: "opacity,scale"
            to: 1
        }
    }

    displaced: Transition {
        Anim {
            property: "y"
        }
        Anim {
            properties: "opacity,scale"
            to: 1
        }
    }

    Component {
        id: appItem

        AppItem {
            visibilities: root.visibilities
        }
    }

    Component {
        id: actionItem

        ActionItem {
            list: root
        }
    }

    Component {
        id: calcItem

        CalcItem {
            list: root
        }
    }

    Component {
        id: schemeItem

        SchemeItem {
            list: root
        }
    }

    Component {
        id: variantItem

        VariantItem {
            list: root
        }
    }

    Behavior on isAction {
        ChangeAnim {}
    }

    Behavior on isCalc {
        ChangeAnim {}
    }

    Behavior on isScheme {
        ChangeAnim {}
    }

    Behavior on isVariant {
        ChangeAnim {}
    }

    component ChangeAnim: SequentialAnimation {
        ParallelAnimation {
            Anim {
                target: root
                property: "opacity"
                from: 1
                to: 0
                duration: Appearance.anim.durations.small
                easing.bezierCurve: Appearance.anim.curves.standardAccel
            }
            Anim {
                target: root
                property: "scale"
                from: 1
                to: 0.9
                duration: Appearance.anim.durations.small
                easing.bezierCurve: Appearance.anim.curves.standardAccel
            }
        }
        PropertyAction {}
        ParallelAnimation {
            Anim {
                target: root
                property: "opacity"
                from: 0
                to: 1
                duration: Appearance.anim.durations.small
                easing.bezierCurve: Appearance.anim.curves.standardDecel
            }
            Anim {
                target: root
                property: "scale"
                from: 0.9
                to: 1
                duration: Appearance.anim.durations.small
                easing.bezierCurve: Appearance.anim.curves.standardDecel
            }
        }
    }

    component Anim: NumberAnimation {
        duration: Appearance.anim.durations.normal
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Appearance.anim.curves.standard
    }
}
