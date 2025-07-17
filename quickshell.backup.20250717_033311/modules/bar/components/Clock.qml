import "./../../../widgets"
import "./../../../services"
import "./../../../config"
import QtQuick
import Quickshell

MouseArea {
    id: root

    property color colour: Colours.palette.m3tertiary

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight
    cursorShape: Qt.PointingHandCursor
    
    onClicked: {
        Quickshell.execDetached(["merkuro-calendar"])
    }

    Row {
        id: content
        
        spacing: Appearance.spacing.small

        MaterialIcon {
            id: icon

            text: "calendar_month"
            color: root.colour

            anchors.verticalCenter: parent.verticalCenter
        }

        StyledText {
            id: text

            anchors.verticalCenter: parent.verticalCenter

            text: Time.format("h:mm AP")
            font.pointSize: Appearance.font.size.smaller
            font.family: Appearance.font.family.mono
            color: root.colour
        }
    }
}
