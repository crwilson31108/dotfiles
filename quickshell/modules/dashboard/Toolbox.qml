pragma ComponentBehavior: Bound

import "./../../widgets"
import "./../../services"
import "./../../config"
import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: root

    required property PersistentProperties visibilities

    property bool caffeineActive: false
    property bool nightShiftActive: false

    spacing: Appearance.padding.large

    // hyprsunset doesn't provide status query, so we track state manually
    // Assume it starts disabled (identity/normal temperature)

    // Process for checking caffeine/hypridle status
    Process {
        id: hypridleCheck
        command: ["pgrep", "hypridle"]
        running: true
        
        onExited: {
            caffeineActive = stdout.trim() === ""
            hypridleCheck.running = false
        }
    }

    // Process components for utility functions
    Process {
        id: hypridleStartProc
        command: ["hypridle"]
    }

    Process {
        id: hypridleKillProc
        command: ["pkill", "hypridle"]
    }

    Process {
        id: screenshotProc
        command: ["/home/caseyw/.config/quickshell/scripts/screenshot.sh"]
    }

    Process {
        id: nightShiftEnableProc
        command: ["hyprctl", "hyprsunset", "temperature", "4000"]
        
        onExited: {
            root.nightShiftActive = true
        }
    }
    
    Process {
        id: nightShiftDisableProc
        command: ["hyprctl", "hyprsunset", "identity"]
        
        onExited: {
            root.nightShiftActive = false
        }
    }

    Process {
        id: colorPickerProc
        command: ["/home/caseyw/.config/quickshell/scripts/color-picker.sh"]
    }

    Process {
        id: clipboardRofiProc
        command: ["/home/caseyw/.config/quickshell/scripts/clipboard-rofi.sh"]
    }

    Timer {
        id: colorPickerDelayTimer
        interval: 500  // Wait 500ms for drawer to close completely
        repeat: false
        onTriggered: {
            console.log("Timer triggered, launching color picker")
            // Use sh -c to launch without Process reinitialization
            quickLauncherProc.command = ["sh", "-c", "hyprpicker -a &"]
            quickLauncherProc.running = true
        }
    }

    Timer {
        id: screenshotDelayTimer
        interval: 500  // Wait 500ms for drawer to close completely
        repeat: false
        onTriggered: {
            console.log("Screenshot timer triggered")
            // Launch screenshot with drawer closed
            quickLauncherProc.command = ["sh", "-c", "grim -g \"$(slurp)\" - | swappy -f - &"]
            quickLauncherProc.running = true
        }
    }

    Timer {
        id: clipboardDelayTimer
        interval: 500  // Wait 500ms for drawer to close completely
        repeat: false
        onTriggered: {
            console.log("Clipboard timer triggered")
            // Launch clipboard rofi selector
            clipboardRofiProc.running = true
        }
    }

    // Lightweight process launcher that doesn't cause refresh
    Process {
        id: quickLauncherProc
    }

    // Title
    StyledText {
        Layout.alignment: Qt.AlignHCenter

        text: qsTr("Toolbox")
        color: Colours.palette.m3onSurface
        font.pointSize: Appearance.font.size.extraLarge
        font.weight: Font.Medium
    }

    // Utilities Grid in a container
    StyledRect {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredWidth: 600
        Layout.preferredHeight: 300

        color: Colours.palette.m3surfaceContainerLow
        radius: Appearance.rounding.small

        GridLayout {
            anchors.fill: parent
            anchors.margins: Appearance.padding.large

            columns: 3
            columnSpacing: Appearance.padding.normal
            rowSpacing: Appearance.padding.normal

                // Stay Awake / Caffeine
                UtilityButton {
                    iconName: root.caffeineActive ? "coffee" : "coffee_maker"
                    text: qsTr("Stay Awake")
                    active: root.caffeineActive
                    onClicked: {
                        console.log("Stay Awake clicked, current state:", root.caffeineActive)
                        if (root.caffeineActive) {
                            // Enable hypridle again
                            hypridleStartProc.running = true
                        } else {
                            // Kill hypridle to prevent screen lock
                            hypridleKillProc.running = true
                        }
                        root.caffeineActive = !root.caffeineActive
                    }
                }

                // Screenshot
                UtilityButton {
                    iconName: "screenshot"
                    text: qsTr("Screenshot")
                    onClicked: {
                        console.log("Screenshot clicked")
                        // Close drawer first, then wait for it to close
                        root.visibilities.dashboard = false
                        // Use timer to wait for drawer animation to complete
                        screenshotDelayTimer.start()
                    }
                }

                // Night Shift
                UtilityButton {
                    iconName: root.nightShiftActive ? "brightness_4" : "brightness_7"
                    text: qsTr("Night Shift")
                    active: root.nightShiftActive
                    onClicked: {
                        console.log("Night Shift clicked, current state:", root.nightShiftActive)
                        if (root.nightShiftActive) {
                            // Turn off - reset to identity
                            nightShiftDisableProc.running = true
                        } else {
                            // Turn on - set warm temperature
                            nightShiftEnableProc.running = true
                        }
                    }
                }

                // Color Picker
                UtilityButton {
                    iconName: "colorize"
                    text: qsTr("Color Picker")
                    onClicked: {
                        console.log("Color Picker clicked")
                        // Close drawer first, then wait for it to close
                        root.visibilities.dashboard = false
                        // Use timer to wait for drawer animation to complete
                        colorPickerDelayTimer.start()
                    }
                }

                // Clipboard Manager
                UtilityButton {
                    iconName: "content_paste"
                    text: qsTr("Clipboard")
                    onClicked: {
                        console.log("Clipboard clicked")
                        // Close drawer first, then wait for it to close
                        root.visibilities.dashboard = false
                        // Use timer to wait for drawer animation to complete
                        clipboardDelayTimer.start()
                    }
                }

            // Empty slot for alignment
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }


    // Utility Button Component
    component UtilityButton: StyledRect {
        id: utilButton
        
        property string iconName: ""
        property string text: ""
        property bool active: false
        signal clicked()
        
        Layout.fillWidth: true
        Layout.preferredHeight: 80
        
        color: utilButton.active ? Colours.palette.m3primaryContainer : Colours.palette.m3surfaceContainer
        radius: Appearance.rounding.normal
        
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: utilButton.clicked()
        }
        
        ColumnLayout {
            anchors.centerIn: parent
            spacing: Appearance.padding.small
            
            MaterialIcon {
                Layout.alignment: Qt.AlignHCenter
                
                text: utilButton.iconName
                color: utilButton.active ? Colours.palette.m3onPrimaryContainer : Colours.palette.m3onSurface
                font.pointSize: Appearance.font.size.extraLarge
            }
            
            StyledText {
                Layout.alignment: Qt.AlignHCenter
                
                text: utilButton.text
                color: utilButton.active ? Colours.palette.m3onPrimaryContainer : Colours.palette.m3onSurfaceVariant
                font.pointSize: Appearance.font.size.small
            }
        }
        
        Behavior on color {
            ColorAnimation { duration: Appearance.anim.durations.short }
        }
    }
}