pragma ComponentBehavior: Bound

import "./../../../widgets"
import "./../../../services"
import "./../../../config"
import Quickshell.Services.UPower
import QtQuick

Column {
    id: root

    spacing: Appearance.spacing.normal
    width: Config.bar.sizes.batteryWidth

    StyledText {
        text: UPower.displayDevice.isLaptopBattery ? qsTr("Remaining: %1%").arg(Math.round(UPower.displayDevice.percentage * 100)) : qsTr("No battery detected")
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

    // Battery health information
    if (UPower.displayDevice.isLaptopBattery) {
        StyledRect {
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
                    text: qsTr("Battery Health")
                    font.weight: 600
                    color: Colours.palette.m3primary
                }

                StyledText {
                    text: qsTr("Energy: %1 / %2").arg(UPower.displayDevice.energy.toFixed(1) + " Wh").arg(UPower.displayDevice.energyFull.toFixed(1) + " Wh")
                    font.family: Appearance.font.family.mono
                    font.pointSize: Appearance.font.size.small
                }

                StyledText {
                    text: qsTr("Capacity: %1%").arg(Math.round(UPower.displayDevice.capacity))
                    font.family: Appearance.font.family.mono
                    font.pointSize: Appearance.font.size.small
                }

                StyledText {
                    text: qsTr("Voltage: %1V").arg(UPower.displayDevice.voltage.toFixed(2))
                    font.family: Appearance.font.family.mono
                    font.pointSize: Appearance.font.size.small
                }
            }
        }
    }

    // TLP Power Management Info
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
                text: qsTr("Power Management (TLP)")
                font.weight: 600
                color: Colours.palette.m3primary
            }

            StyledText {
                text: UPower.onBattery ? qsTr("Mode: Battery") : qsTr("Mode: AC Power")
                font.family: Appearance.font.family.mono
                font.pointSize: Appearance.font.size.small
            }

            StyledText {
                text: qsTr("Governor: powersave")
                font.family: Appearance.font.family.mono
                font.pointSize: Appearance.font.size.small
            }

            StyledText {
                text: qsTr("EPP: power")
                font.family: Appearance.font.family.mono
                font.pointSize: Appearance.font.size.small
            }

            // Action buttons
            Row {
                spacing: Appearance.spacing.small
                anchors.horizontalCenter: parent.horizontalCenter

                StyledButton {
                    text: qsTr("TLP Status")
                    font.pointSize: Appearance.font.size.small
                    onClicked: Quickshell.execDetached(["sh", "-c", "foot -e bash -c 'sudo tlp-stat -s; read -p \"Press Enter to close...\"'"])
                }

                StyledButton {
                    text: qsTr("Power Top")
                    font.pointSize: Appearance.font.size.small
                    onClicked: Quickshell.execDetached(["sh", "-c", "foot -e sudo powertop"])
                }
            }
        }
    }
}