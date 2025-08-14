pragma ComponentBehavior: Bound

import "./../../widgets"
import "./../../services"
import "./../../config"
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick

Item {
    id: root

    required property PersistentProperties visibilities
    readonly property int padding: Appearance.padding.large
    readonly property int rounding: Appearance.rounding.large
    readonly property int previewWidth: 700 // Larger preview width
    readonly property int previewHeight: 500 // Larger preview height
    readonly property int cardHeight: 120 // Window card height
    readonly property int totalHeight: previewHeight + cardHeight + Appearance.spacing.large + padding * 2 // Preview + cards + spacing + minimal padding

    implicitWidth: Math.max(listWrapper.implicitWidth + padding * 2, previewWidth + padding * 2)
    implicitHeight: totalHeight

    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter

    Item {
        id: listWrapper
        
        implicitWidth: list.implicitWidth
        implicitHeight: list.implicitHeight

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: padding

        WindowList {
            id: list
            anchors.centerIn: parent
        }
    }

    // Large modern preview above cards
    Item {
        id: previewContainer
        
        anchors.bottom: listWrapper.top
        anchors.bottomMargin: Appearance.spacing.large
        anchors.horizontalCenter: parent.horizontalCenter
        
        width: root.previewWidth
        height: root.previewHeight
        
        visible: WindowSwitcher.selectedWindow
        
        // Clean GTK/GNOME-style background
        Rectangle {
            anchors.fill: parent
            color: Colours.palette.m3surface
            radius: Appearance.rounding.large
            
            // Subtle drop shadow
            Rectangle {
                anchors.fill: parent
                anchors.margins: -2
                color: "transparent"
                radius: parent.radius + 2
                border.color: Colours.alpha(Colours.palette.m3shadow, 0.2)
                border.width: 1
                z: -1
            }
            
            // Clean border
            Rectangle {
                anchors.fill: parent
                color: "transparent"
                radius: parent.radius
                border.color: Colours.palette.m3outline
                border.width: 1
            }
        }
        
        // Window capture frame
        StyledClippingRect {
            id: captureFrame
            anchors.fill: parent
            anchors.margins: 8
            radius: Appearance.rounding.normal
            color: Colours.palette.m3surfaceContainerLow
            
            ScreencopyView {
                id: screenCapture
                anchors.fill: parent
                
                property var targetWindow: WindowSwitcher.selectedWindow?.wayland ?? null
                property var lastWindow: null
                property bool transitioning: false
                
                captureSource: transitioning ? null : targetWindow
                live: visible && !transitioning
                
                constraintSize.width: root.previewWidth - 16
                constraintSize.height: root.previewHeight - 16
                
                onTargetWindowChanged: {
                    if (lastWindow !== targetWindow) {
                        // Force a clean transition by nulling capture source first
                        transitioning = true
                        lastWindow = targetWindow
                        refreshTimer.restart()
                    }
                }
                
                Timer {
                    id: refreshTimer
                    interval: 50  // Longer delay to ensure buffer is fully cleared
                    onTriggered: {
                        screenCapture.transitioning = false
                    }
                }
                
                Rectangle {
                    anchors.fill: parent
                    color: Colours.palette.m3surfaceContainerLow
                    radius: Appearance.rounding.normal
                    visible: !screenCapture.captureSource || screenCapture.transitioning
                    
                    StyledText {
                        anchors.centerIn: parent
                        text: screenCapture.targetWindow ? "Loading preview..." : "Preview unavailable"
                        color: Colours.palette.m3onSurfaceVariant
                        font.pointSize: Appearance.font.size.normal
                    }
                }
            }
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