import "./../../services"
import "./../../config"
import "./../../widgets"
import Quickshell
import QtQuick
import QtQuick.Effects

Item {
    id: root

    required property PersistentProperties visibilities

    anchors.fill: parent

    // Semi-transparent background overlay
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.6)

        MouseArea {
            anchors.fill: parent
            onClicked: root.visibilities.session = false
        }
    }

    // ESC key handling
    Keys.onEscapePressed: root.visibilities.session = false
    focus: true
    
    Component.onCompleted: forceActiveFocus()

    // Main power menu container
    Rectangle {
        id: menuContainer
        anchors.centerIn: parent
        width: 480
        height: 360
        radius: Appearance.rounding.large
        color: Colours.palette.m3surface

        // Subtle glow effect
        Rectangle {
            anchors.fill: parent
            anchors.margins: -3
            radius: parent.radius + 3
            color: "transparent"
            border.color: Qt.rgba(Colours.palette.m3primary.r, Colours.palette.m3primary.g, Colours.palette.m3primary.b, 0.3)
            border.width: 1
            z: -1
        }

        // Soft drop shadow
        Rectangle {
            anchors.fill: parent
            anchors.margins: -6
            radius: parent.radius + 6
            color: Qt.rgba(0, 0, 0, 0.4)
            z: -2
        }

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
                    root.visibilities.session = false
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
                    root.visibilities.session = false
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
                    root.visibilities.session = false
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
                    Quickshell.execDetached(["loginctl", "terminate-user", "caseyw"])
                    root.visibilities.session = false
                }
            }
        }
    }

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

            // Icon with subtle glow
            StyledText {
                text: parent.parent.icon
                font.pixelSize: 40
                color: parent.parent.iconColor
                anchors.horizontalCenter: parent.horizontalCenter
                
                // Subtle text glow on hover
                opacity: mouseArea.containsMouse ? 1.0 : 0.9
                Behavior on opacity {
                    NumberAnimation { duration: 200 }
                }
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

        // Ripple effect on click
        Rectangle {
            id: ripple
            anchors.centerIn: parent
            width: 0
            height: 0
            radius: width / 2
            color: Qt.rgba(1, 1, 1, 0.3)
            opacity: 0
            
            PropertyAnimation {
                id: rippleAnimation
                target: ripple
                properties: "width,height,opacity"
                from: 0
                to: parent.width * 1.5
                duration: 300
                easing.type: Easing.OutCubic
                onFinished: {
                    ripple.width = 0
                    ripple.height = 0
                    ripple.opacity = 0
                }
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                // Trigger ripple effect
                ripple.opacity = 0.6
                rippleAnimation.start()
                
                // Emit clicked signal with slight delay for visual feedback
                Qt.callLater(function() {
                    parent.clicked()
                })
            }
        }
    }
}