import "./../../../widgets"
import "./../../../services"
import "./../../../config"
import Quickshell

MaterialIcon {
    text: "power_settings_new"
    color: Colours.palette.m3error
    font.bold: true
    font.pointSize: Appearance.font.size.normal

    StateLayer {
        anchors.fill: undefined
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: 1

        implicitWidth: parent.implicitHeight + Appearance.padding.small * 2
        implicitHeight: implicitWidth

        radius: Appearance.rounding.full

        function onClicked(): void {
            PowerMenu.toggle();
        }
    }
}
