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

    // Check if caffeinate is running
    function checkCaffeineState() {
        caffeineCheckProc.running = true
    }
    
    Process {
        id: caffeineCheckProc
        command: ["pgrep", "caffeinate"]
        
        onExited: (exitCode) => {
            // If exit code is 0, caffeinate is running
            root.caffeineActive = (exitCode === 0)
            console.log("Caffeinate check:", exitCode === 0 ? "running" : "not running")
        }
    }
    
    // Timer for delayed state checks
    Timer {
        id: stateCheckTimer
        interval: 500
        repeat: false
        onTriggered: checkCaffeineState()
    }
    
    // Start caffeinate detached
    Process {
        id: startCaffeineProc
        command: ["sh", "-c", "caffeinate -d &"]
        
        onExited: {
            // Check state after starting
            stateCheckTimer.start()
        }
    }
    
    // Kill all caffeinate processes
    Process {
        id: killCaffeineProc
        command: ["pkill", "caffeinate"]
        
        onExited: {
            // Check state after killing
            stateCheckTimer.start()
        }
    }
    
    Component.onCompleted: {
        // Check initial state
        checkCaffeineState()
    }
    
    // Check state when drawer opens
    Connections {
        target: root.visibilities
        
        function onDashboardChanged() {
            if (root.visibilities.dashboard) {
                checkCaffeineState()
            }
        }
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
                        if (root.caffeineActive) {
                            // Optimistically update state
                            root.caffeineActive = false
                            // Kill all caffeinate processes
                            killCaffeineProc.running = true
                            console.log("Stay Awake deactivated (optimistic)")
                        } else {
                            // Optimistically update state
                            root.caffeineActive = true
                            // Start caffeinate detached
                            startCaffeineProc.running = true
                            console.log("Stay Awake activated (optimistic)")
                        }
                    }
                }

                // Screenshot
                UtilityButton {
                    iconName: "screenshot"
                    text: qsTr("Screenshot")
                    onClicked: {
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