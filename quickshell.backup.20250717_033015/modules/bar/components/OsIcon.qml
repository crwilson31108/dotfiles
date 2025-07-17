import "./../../../widgets"
import "./../../../services"
import "./../../../utils"
import "./../../../config"
import Quickshell
import QtQuick

StyledText {
    id: root
    
    required property PersistentProperties visibilities
    
    text: Icons.osIcon
    font.pointSize: Appearance.font.size.smaller
    font.family: Appearance.font.family.mono
    color: mouseArea.containsMouse ? Colours.palette.m3primary : Colours.palette.m3tertiary
    
    Behavior on color {
        ColorAnimation {
            duration: Appearance.anim.durations.small
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Appearance.anim.curves.standard
        }
    }
    
    MouseArea {
        id: mouseArea
        
        anchors.fill: parent
        anchors.margins: -Appearance.padding.small
        
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        
        onClicked: {
            root.visibilities.overview = !root.visibilities.overview;
        }
    }
}
