import "./../../widgets"
import "./../../services"
import "./../../config"
import Quickshell
import Quickshell.Widgets
import QtQuick

Item {
    id: root

    required property var modelData
    
    signal clicked()
    

    Rectangle {
        id: background
        
        anchors.fill: parent
        anchors.margins: Appearance.spacing.tiny
        
        radius: Appearance.rounding.large
        color: {
            if (mouseArea.pressed) {
                return Colours.alpha(Colours.palette.m3primary, 0.16);
            } else if (mouseArea.containsMouse) {
                return Colours.alpha(Colours.palette.m3primary, 0.08);
            } else {
                return "transparent";
            }
        }
        
        Behavior on color {
            ColorAnimation {
                duration: Appearance.anim.durations.small
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.anim.curves.standard
            }
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: Appearance.spacing.small

        Item {
            id: iconContainer
            
            width: 64
            height: 64
            anchors.horizontalCenter: parent.horizontalCenter

            IconImage {
                id: appIcon
                
                anchors.centerIn: parent
                width: parent.width
                height: parent.height
                
                source: Quickshell.iconPath(root.modelData?.icon || (root.modelData?.isExecutable ? "application-x-executable" : ""), "image-missing")
                
                scale: mouseArea.pressed ? 0.9 : 1.0
                
                Behavior on scale {
                    NumberAnimation {
                        duration: Appearance.anim.durations.small
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Appearance.anim.curves.standard
                    }
                }
            }
        }

        StyledText {
            id: appName
            
            anchors.horizontalCenter: parent.horizontalCenter
            width: root.width - Appearance.padding.normal * 2
            
            text: root.modelData?.name || root.modelData?.command || ""
            color: {
                // Use high contrast white text when this item is selected (keyboard highlight)
                if (root.GridView.isCurrentItem) {
                    return "#ffffff"
                } else {
                    return Colours.palette.m3onSurface
                }
            }
            font.pointSize: Appearance.font.size.smaller
            font.weight: root.GridView.isCurrentItem ? Font.Medium : Font.Normal
            
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
            maximumLineCount: 2
            wrapMode: Text.WordWrap
            
            Behavior on color {
                ColorAnimation {
                    duration: Appearance.anim.durations.small
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Appearance.anim.curves.standard
                }
            }
        }
    }

    MouseArea {
        id: mouseArea
        
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        
        onClicked: root.clicked()
        
        onEntered: {
            // Sync keyboard selection with mouse hover
            if (root.GridView.view) {
                root.GridView.view.currentIndex = root.GridView.view.indexAt(root.x + root.width/2, root.y + root.height/2);
            }
        }
    }
}