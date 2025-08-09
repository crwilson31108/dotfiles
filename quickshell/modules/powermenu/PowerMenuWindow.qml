pragma ComponentBehavior: Bound

import "../../services"
import "../../config"  
import "../../widgets"
import Quickshell
import Quickshell.Wayland
import QtQuick

Scope {
    required property PersistentProperties visibilities
    
    Component.onCompleted: console.log("PowerMenuWindow created")
    
    Connections {
        target: visibilities
        function onSessionChanged() {
            console.log("PowerMenu session visibility changed:", visibilities.session)
        }
    }

    LazyLoader {
        id: loader
        active: visibilities.session
        
        Component.onCompleted: console.log("PowerMenu loader created")
        onActiveChanged: console.log("PowerMenu loader active:", active)

        StyledWindow {
            screen: Quickshell.screens[0]
            name: "power-menu"
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

            anchors.top: true
            anchors.bottom: true
            anchors.left: true
            anchors.right: true

            // Semi-transparent background overlay
            Rectangle {
                anchors.fill: parent
                color: Qt.rgba(0, 0, 0, 0.6)

                MouseArea {
                    anchors.fill: parent
                    onClicked: visibilities.session = false
                }
            }

            // Main power menu container
            Rectangle {
                anchors.centerIn: parent
                width: 480
                height: 360
                radius: Appearance.rounding.large
                color: Colours.palette.m3surface

                // 2x2 Grid of power options
                Grid {
                    anchors.centerIn: parent
                    columns: 2
                    rows: 2
                    columnSpacing: 30
                    rowSpacing: 30

                    // Power Off
                    PowerButton {
                        icon: "󰐥"
                        label: "Shutdown"
                        buttonColor: Colours.palette.m3errorContainer
                        iconColor: Colours.palette.m3onErrorContainer
                        hoverColor: Qt.lighter(Colours.palette.m3errorContainer, 1.3)
                        onClicked: {
                            Quickshell.execDetached(["systemctl", "poweroff"])
                            visibilities.session = false
                        }
                    }

                    // Reboot
                    PowerButton {
                        icon: "󰜉"
                        label: "Restart"
                        buttonColor: Colours.palette.m3tertiaryContainer
                        iconColor: Colours.palette.m3onTertiaryContainer
                        hoverColor: Qt.lighter(Colours.palette.m3tertiaryContainer, 1.3)
                        onClicked: {
                            Quickshell.execDetached(["systemctl", "reboot"])
                            visibilities.session = false
                        }
                    }

                    // Lock Screen
                    PowerButton {
                        icon: "󰌾"
                        label: "Lock"
                        buttonColor: Colours.palette.m3secondaryContainer
                        iconColor: Colours.palette.m3onSecondaryContainer
                        hoverColor: Qt.lighter(Colours.palette.m3secondaryContainer, 1.3)
                        onClicked: {
                            Quickshell.execDetached(["hyprlock"])
                            visibilities.session = false
                        }
                    }

                    // Log Out
                    PowerButton {
                        icon: "󰍃"
                        label: "Logout"
                        buttonColor: Colours.palette.m3primaryContainer
                        iconColor: Colours.palette.m3onPrimaryContainer
                        hoverColor: Qt.lighter(Colours.palette.m3primaryContainer, 1.3)
                        onClicked: {
                            Quickshell.execDetached(["loginctl", "terminate-user", ""])
                            visibilities.session = false
                        }
                    }
                }
            }

            // ESC key handling
            Keys.onEscapePressed: visibilities.session = false
            Component.onCompleted: forceActiveFocus()

            // Polished power button component
            component PowerButton: Rectangle {
                property string icon
                property string label
                property color buttonColor
                property color iconColor
                property color hoverColor
                signal clicked()

                width: 140
                height: 100
                radius: Appearance.rounding.normal
                color: mouseArea.containsMouse ? hoverColor : buttonColor

                // Smooth color transitions
                Behavior on color {
                    ColorAnimation { 
                        duration: 250
                        easing.type: Easing.OutCubic
                    }
                }

                // Scale effect on hover
                scale: mouseArea.containsMouse ? 1.05 : 1.0
                Behavior on scale {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.OutBack
                    }
                }

                // Inner content
                Column {
                    anchors.centerIn: parent
                    spacing: 12

                    // Icon
                    StyledText {
                        text: parent.parent.icon
                        font.pixelSize: 40
                        color: parent.parent.iconColor
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    // Label text
                    StyledText {
                        text: parent.parent.label
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        color: parent.parent.iconColor
                        anchors.horizontalCenter: parent.horizontalCenter
                        opacity: 0.9
                    }
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: parent.clicked()
                }
            }
        }
    }
}