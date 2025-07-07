pragma ComponentBehavior: Bound

import "./../../widgets"
import "./../../services"
import "./../../config"
import Quickshell
import QtQuick

Item {
    id: root

    required property PersistentProperties visibilities
    readonly property int padding: Appearance.padding.large
    readonly property int rounding: Appearance.rounding.large

    implicitWidth: listWrapper.width + padding * 2
    implicitHeight: listWrapper.height + padding * 2

    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter

    Item {
        id: listWrapper

        readonly property int minHeight: 100 + Appearance.spacing.normal * 2 // Card height + spacing
        
        implicitWidth: list.width
        implicitHeight: Math.max(list.height + root.padding, minHeight)

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        WindowList {
            id: list
            anchors.centerIn: parent
        }
    }

    // Key event handling for Alt release detection
    Keys.onReleased: event => {
        if (event.key === Qt.Key_Alt) {
            console.log("Alt key released in window switcher!");
            WindowSwitcher.hide();
        }
    }

    // Make sure we can receive key events
    Component.onCompleted: {
        forceActiveFocus();
    }

    // Ensure focus when window switcher becomes visible
    Connections {
        target: WindowSwitcher
        function onVisibleChanged() {
            if (WindowSwitcher.visible) {
                root.forceActiveFocus();
            }
        }
    }
}