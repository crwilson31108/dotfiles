import "./../../services"
import "./../../config"
import "./../../widgets"
import Quickshell
import Quickshell.Wayland
import QtQuick

Variants {
    model: Quickshell.screens

    Scope {
        id: scope
        required property ShellScreen modelData

        property bool visible: false

        LazyLoader {
            active: scope.visible
            

            StyledWindow {
                id: powerWindow
                screen: modelData
                name: "powermenu"
                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
                WlrLayershell.exclusionMode: ExclusionMode.Ignore

                anchors.top: true
                anchors.bottom: true
                anchors.left: true
                anchors.right: true
                

                // Semi-transparent background overlay covering entire desktop
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 0
                    color: Qt.rgba(0, 0, 0, 0.6)

                    MouseArea {
                        anchors.fill: parent
                        onClicked: PowerMenu.hide()
                    }
                }

                // Drop shadow
                Rectangle {
                    id: dropShadow
                    anchors.centerIn: parent
                    width: menuContainer.width + 20
                    height: menuContainer.height + 20
                    radius: menuContainer.radius + 10
                    color: Qt.rgba(0, 0, 0, 0.3)
                    z: -1
                }

                // Main power menu container
                Rectangle {
                    id: menuContainer
                    anchors.centerIn: parent
                    width: 480
                    height: 360
                    radius: Appearance.rounding.large
                    color: Colours.palette.m3surface

                    // Subtle border
                    border.width: 1
                    border.color: Qt.rgba(1, 1, 1, 0.1)

                    // 2x2 Grid of power options
                    Grid {
                        anchors.centerIn: parent
                        columns: 2
                        rows: 2
                        columnSpacing: 30
                        rowSpacing: 30

                        // Shutdown
                        PowerButton {
                            icon: "󰐥"
                            label: "Shutdown"
                            buttonColor: Colours.palette.m3errorContainer
                            iconColor: Colours.palette.m3onErrorContainer
                            hoverColor: Qt.lighter(Colours.palette.m3errorContainer, 1.3)
                            onClicked: {
                                Quickshell.execDetached(["systemctl", "poweroff"])
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
                                Quickshell.execDetached(["/home/caseyw/.config/hypr/scripts/hyprlock-gpu-fast.sh"])
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
                                Quickshell.execDetached(["hyprctl", "dispatch", "exit"])
                            }
                        }
                    }
                }

                // ESC key handling  
                Keys.onEscapePressed: PowerMenu.hide()

                // Power button component
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

        Component.onCompleted: {
            PowerMenu.currentMenu = scope;
        }
    }
}