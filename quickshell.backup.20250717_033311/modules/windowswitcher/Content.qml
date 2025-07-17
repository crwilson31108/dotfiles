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
            anchors.bottomMargin: 64 // Leave space for title bar
            radius: Appearance.rounding.normal
            color: Colours.palette.m3surfaceContainerLow
            
            ScreencopyView {
                id: screenCapture
                anchors.fill: parent
                
                captureSource: WindowSwitcher.selectedWindow?.wayland ?? null
                live: visible
                
                constraintSize.width: root.previewWidth - 16
                constraintSize.height: root.previewHeight - 80
                
                Rectangle {
                    anchors.fill: parent
                    color: Colours.palette.m3surfaceContainerLow
                    radius: Appearance.rounding.normal
                    visible: !screenCapture.captureSource
                    
                    StyledText {
                        anchors.centerIn: parent
                        text: "Preview unavailable"
                        color: Colours.palette.m3onSurfaceVariant
                        font.pointSize: Appearance.font.size.normal
                    }
                }
            }
        }
        
        // Clean title bar with app info
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            anchors.bottomMargin: 8
            height: 48
            color: Colours.palette.m3surfaceContainerHigh
            radius: Appearance.rounding.normal
            
            // Subtle top border
            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 1
                color: Colours.alpha(Colours.palette.m3outline, 0.3)
            }
            
            Item {
                anchors.fill: parent
                anchors.margins: Appearance.padding.normal
                
                // App icon
                IconImage {
                    id: appIcon
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    source: Quickshell.iconPath(AppMatching.getWindowIcon(WindowSwitcher.selectedWindow), "image-missing")
                    implicitSize: 24
                }
                
                // Title and app name container with proper bounds
                Item {
                    anchors.left: appIcon.right
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: Appearance.spacing.normal
                    anchors.topMargin: 4
                    anchors.bottomMargin: 4
                    
                    // App name (primary)
                    StyledText {
                        id: appName
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        
                        text: AppMatching.getWindowAppName(WindowSwitcher.selectedWindow)
                        color: Colours.palette.m3onSurface
                        font.pointSize: Appearance.font.size.normal
                        font.weight: Font.Medium
                        elide: Text.ElideRight
                        maximumLineCount: 1
                    }
                    
                    // Window title (secondary)
                    StyledText {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: appName.bottom
                        anchors.topMargin: 2
                        visible: anchors.topMargin + implicitHeight <= parent.height - appName.height
                        
                        text: WindowIconMapper.getWindowTitle(WindowSwitcher.selectedWindow)
                        color: Colours.palette.m3onSurfaceVariant
                        font.pointSize: Appearance.font.size.small
                        elide: Text.ElideRight
                        maximumLineCount: 1
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