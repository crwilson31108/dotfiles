pragma ComponentBehavior: Bound

import "./../../widgets"
import "./../../services"
import "./../../config"
import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ColumnLayout {
    id: root

    required property PersistentProperties visibilities

    property bool caffeineActive: false
    property bool nightShiftActive: false
    property int updateCount: 0
    property string updateDetails: "Repo: 0, AUR: 0, Flatpak: 0"

    spacing: Appearance.padding.large

    // Check if caffeinate is running
    function checkCaffeineState() {
        caffeineCheckProc.running = true
    }
    
    // Check for system updates
    function checkSystemUpdates() {
        loadUpdates()
    }
    
    function loadUpdates() {
        const req = new XMLHttpRequest()
        req.onreadystatechange = function() {
            if (req.readyState === XMLHttpRequest.DONE) {
                if (req.status === 0 || req.status === 200) {
                    try {
                        const data = JSON.parse(req.responseText)
                        const repo = Number(data.repo) || 0
                        const aur = Number(data.aur) || 0
                        const flat = Number(data.flatpak) || 0
                        const total = Number(data.total) || repo + aur + flat
                        root.updateCount = total
                        root.updateDetails = `Repo: ${repo}, AUR: ${aur}, Flatpak: ${flat}`
                    } catch(e) {
                        root.updateCount = 0
                        root.updateDetails = "Repo: 0, AUR: 0, Flatpak: 0"
                    }
                } else {
                    root.updateCount = 0
                    root.updateDetails = "Repo: 0, AUR: 0, Flatpak: 0"
                }
            }
        }
        const updatesFile = "file:///run/user/1000/qs-updates.json"
        req.open("GET", updatesFile, true)
        req.send()
    }
    
    Process {
        id: caffeineCheckProc
        command: ["pgrep", "caffeinate"]
        
        onExited: (exitCode) => {
            // If exit code is 0, caffeinate is running
            root.caffeineActive = (exitCode === 0)
        }
    }
    
    
    // Timer for delayed state checks
    Timer {
        id: stateCheckTimer
        interval: 500
        repeat: false
        onTriggered: checkCaffeineState()
    }
    
    // Timer to periodically check for updates
    Timer {
        id: updateCheckTimer
        interval: 60000  // 1 minute - more frequent to catch updates quickly
        repeat: true
        running: true
        onTriggered: checkSystemUpdates()
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
        // Check for updates
        Qt.callLater(checkSystemUpdates)
    }
    
    // Check state when drawer opens
    Connections {
        target: root.visibilities
        
        function onDashboardChanged() {
            if (root.visibilities.dashboard) {
                checkCaffeineState()
                Qt.callLater(checkSystemUpdates)
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

    Timer {
        id: systemUpdateDelayTimer
        interval: 500  // Wait 500ms for drawer to close completely
        repeat: false
        onTriggered: {
            // Launch system updates in terminal
            quickLauncherProc.command = ["foot", "--title=System Updates", "bash", "-c", "/home/caseyw/.config/quickshell/scripts/run-system-updates.sh; read -p 'Press enter to close'"]
            quickLauncherProc.running = true
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
                        } else {
                            // Optimistically update state
                            root.caffeineActive = true
                            // Start caffeinate detached
                            startCaffeineProc.running = true
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

                // System Updates
                UtilityButton {
                    iconName: root.updateCount > 0 ? "system_update_alt" : "system_update"
                    text: qsTr("Updates") + (root.updateCount > 0 ? " (" + root.updateCount + ")" : "")
                    active: root.updateCount > 0
                    
                    onClicked: {
                        // Close drawer first, then wait for it to close
                        root.visibilities.dashboard = false
                        // Use timer to wait for drawer animation to complete
                        systemUpdateDelayTimer.start()
                    }
                    
                    // Show tooltip on hover with update details
                    Rectangle {
                        visible: parent.hovered && root.updateDetails && root.updateDetails !== "No updates available"
                        anchors.bottom: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottomMargin: 8
                        
                        width: tooltipText.width + 16
                        height: tooltipText.height + 12
                        color: Colours.palette.m3surfaceContainerHigh
                        radius: Appearance.rounding.small
                        
                        StyledText {
                            id: tooltipText
                            anchors.centerIn: parent
                            text: root.updateDetails
                            color: Colours.palette.m3onSurface
                            font.pointSize: Appearance.font.size.small
                        }
                        
                        // Tooltip arrow
                        Rectangle {
                            anchors.top: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.topMargin: -4
                            width: 8
                            height: 8
                            color: parent.color
                            rotation: 45
                        }
                    }
                }
        }
    }


    // Utility Button Component
    component UtilityButton: StyledRect {
        id: utilButton
        
        property string iconName: ""
        property string text: ""
        property bool active: false
        property bool hovered: mouseArea.containsMouse
        signal clicked()
        
        Layout.fillWidth: true
        Layout.preferredHeight: 80
        
        color: {
            if (utilButton.active) {
                return utilButton.hovered ? Colours.palette.m3primary : Colours.palette.m3primaryContainer
            } else {
                return utilButton.hovered ? Colours.palette.m3surfaceContainerHigh : Colours.palette.m3surfaceContainer
            }
        }
        radius: Appearance.rounding.normal
        
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: utilButton.clicked()
        }
        
        ColumnLayout {
            anchors.centerIn: parent
            spacing: Appearance.padding.small
            
            MaterialIcon {
                Layout.alignment: Qt.AlignHCenter
                
                text: utilButton.iconName
                color: {
                    if (utilButton.active && utilButton.hovered) {
                        return Colours.palette.m3onPrimary
                    } else if (utilButton.active) {
                        return Colours.palette.m3onPrimaryContainer
                    } else {
                        return Colours.palette.m3onSurface
                    }
                }
                font.pointSize: Appearance.font.size.extraLarge
            }
            
            StyledText {
                Layout.alignment: Qt.AlignHCenter
                
                text: utilButton.text
                color: {
                    if (utilButton.active && utilButton.hovered) {
                        return Colours.palette.m3onPrimary
                    } else if (utilButton.active) {
                        return Colours.palette.m3onPrimaryContainer
                    } else {
                        return Colours.palette.m3onSurfaceVariant
                    }
                }
                font.pointSize: Appearance.font.size.small
            }
        }
        
        Behavior on color {
            ColorAnimation { duration: Appearance.anim.durations.short }
        }
    }
}