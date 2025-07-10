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
    readonly property int baseHeight: 120 + padding * 2 // Normal card height + padding

    implicitWidth: listWrapper.implicitWidth + padding * 2
    implicitHeight: Math.max(listWrapper.implicitHeight + padding * 2, baseHeight)

    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter

    Item {
        id: listWrapper
        
        implicitWidth: list.implicitWidth
        implicitHeight: list.implicitHeight

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