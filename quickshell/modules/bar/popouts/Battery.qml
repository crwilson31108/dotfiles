pragma ComponentBehavior: Bound

import "./../../../widgets"
import "./../../../services"
import "./../../../config"
import Quickshell.Services.UPower
import Quickshell.Io
import QtQuick

Column {
    id: root

    spacing: Appearance.spacing.normal
    width: Config.bar.sizes.batteryWidth

    property var batteryData: ({})

    Process {
        id: batteryHealthProcess
        command: ["/home/caseyw/.config/quickshell/scripts/battery-health.sh"]
        
        onExited: {
            if (exitCode === 0) {
                const lines = stdout.trim().split('\n')
                const data = {}
                for (const line of lines) {
                    const [key, value] = line.split(':')
                    if (key && value) {
                        data[key] = value.trim()
                    }
                }
                root.batteryData = data
            }
        }
    }

    Component.onCompleted: {
        batteryHealthProcess.start()
        // Refresh every 30 seconds
        batteryTimer.start()
    }

    Timer {
        id: batteryTimer
        interval: 30000 // 30 seconds
        repeat: true
        onTriggered: batteryHealthProcess.start()
    }

    StyledText {
        text: UPower.displayDevice.isLaptopBattery ? qsTr("Battery: %1%").arg(Math.round(UPower.displayDevice.percentage * 100)) : qsTr("No battery detected")
        font.weight: 600
    }

    StyledText {
        function formatSeconds(s: int, fallback: string): string {
            const day = Math.floor(s / 86400);
            const hr = Math.floor(s / 3600) % 60;
            const min = Math.floor(s / 60) % 60;

            let comps = [];
            if (day > 0)
                comps.push(`${day} days`);
            if (hr > 0)
                comps.push(`${hr} hours`);
            if (min > 0)
                comps.push(`${min} mins`);

            return comps.join(", ") || fallback;
        }

        text: UPower.displayDevice.isLaptopBattery ? qsTr("Time %1: %2").arg(UPower.onBattery ? "remaining" : "until charged").arg(UPower.onBattery ? formatSeconds(UPower.displayDevice.timeToEmpty, "Calculating...") : formatSeconds(UPower.displayDevice.timeToFull, "Fully charged!")) : qsTr("Power managed by TLP")
    }

    StyledRect {
        visible: UPower.displayDevice.isLaptopBattery
        anchors.horizontalCenter: parent.horizontalCenter
        implicitWidth: batteryInfo.implicitWidth + Appearance.padding.normal * 2
        implicitHeight: batteryInfo.implicitHeight + Appearance.padding.normal * 2
        
        color: Colours.palette.m3surfaceContainer
        radius: Appearance.rounding.normal

        Column {
            id: batteryInfo
            anchors.centerIn: parent
            spacing: Appearance.spacing.small

            StyledText {
                text: qsTr("Battery Details")
                font.weight: 600
                color: Colours.palette.m3primary
            }

            StyledText {
                text: qsTr("Health: %1%").arg(root.batteryData.HEALTH || "...")
                font.family: Appearance.font.family.mono
                font.pointSize: Appearance.font.size.small
            }

            StyledText {
                text: qsTr("Voltage: %1V").arg(root.batteryData.VOLTAGE || "...")
                font.family: Appearance.font.family.mono
                font.pointSize: Appearance.font.size.small
            }

            StyledText {
                text: qsTr("Cycles: %1").arg(root.batteryData.CYCLES || "...")
                font.family: Appearance.font.family.mono
                font.pointSize: Appearance.font.size.small
            }

            StyledText {
                text: qsTr("Model: %1 %2").arg(root.batteryData.MANUFACTURER || "").arg(root.batteryData.MODEL || "")
                font.family: Appearance.font.family.mono
                font.pointSize: Appearance.font.size.small
            }
        }
    }

    StyledRect {
        anchors.horizontalCenter: parent.horizontalCenter
        implicitWidth: tlpInfo.implicitWidth + Appearance.padding.normal * 2
        implicitHeight: tlpInfo.implicitHeight + Appearance.padding.normal * 2
        
        color: Colours.palette.m3surfaceContainer
        radius: Appearance.rounding.normal

        Column {
            id: tlpInfo
            anchors.centerIn: parent
            spacing: Appearance.spacing.small

            StyledText {
                text: qsTr("Power Management")
                font.weight: 600
                color: Colours.palette.m3primary
            }

            StyledText {
                text: qsTr("Mode: %1").arg(UPower.onBattery ? "Battery" : "AC Power")
                font.family: Appearance.font.family.mono
                font.pointSize: Appearance.font.size.small
            }

            StyledText {
                text: qsTr("Managed by: TLP")
                font.family: Appearance.font.family.mono
                font.pointSize: Appearance.font.size.small
            }

            StyledText {
                text: qsTr("Governor: powersave")
                font.family: Appearance.font.family.mono
                font.pointSize: Appearance.font.size.small
            }
        }
    }
}