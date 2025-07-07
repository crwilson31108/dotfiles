import "./../../../widgets"
import "./../../../services"
import "./../../../config"
import "./../../../utils"
import QtQuick

Item {
    id: root

    anchors.centerIn: parent

    implicitWidth: icon.implicitWidth + info.implicitWidth + info.anchors.leftMargin

    Component.onCompleted: Weather.reload()

    MaterialIcon {
        id: icon

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left

        animate: true
        text: {
            // Check if it's nighttime (8 PM to 6 AM)
            const hour = new Date().getHours();
            const isNight = hour >= 20 || hour < 6;
            
            if (isNight) {
                // Show moon icons during night
                const baseIcon = Weather.icon || "cloud_alert";
                if (baseIcon === "clear_day") return "nights_stay";
                if (baseIcon === "partly_cloudy_day") return "clear_night";
                if (baseIcon.includes("cloud")) return "cloud";
                // For weather conditions, keep original icon
                return baseIcon;
            }
            
            return Weather.icon || "cloud_alert";
        }
        color: Colours.palette.m3secondary
        font.pointSize: Appearance.font.size.extraLarge * 2
    }

    Column {
        id: info

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: icon.right
        anchors.leftMargin: Appearance.spacing.large

        spacing: Appearance.spacing.small

        StyledText {
            anchors.horizontalCenter: parent.horizontalCenter

            animate: true
            text: Config.dashboard.useFahrenheit ? Weather.tempF : Weather.tempC
            color: Colours.palette.m3primary
            font.pointSize: Appearance.font.size.extraLarge
            font.weight: 500
        }

        StyledText {
            anchors.horizontalCenter: parent.horizontalCenter

            animate: true
            text: Weather.description || qsTr("No weather")

            elide: Text.ElideRight
            width: Math.min(implicitWidth, root.parent.width - icon.implicitWidth - info.anchors.leftMargin - Appearance.padding.large * 2)
        }
    }
}
