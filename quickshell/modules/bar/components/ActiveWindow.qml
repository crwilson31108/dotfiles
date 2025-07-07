pragma ComponentBehavior: Bound

import "./../../../widgets"
import "./../../../services"
import "./../../../utils"
import "./../../../config"
import QtQuick

Item {
    id: root

    required property Brightness.Monitor monitor
    property color colour: Colours.palette.m3primary
    readonly property Item child: child

    implicitWidth: child.implicitWidth
    implicitHeight: child.implicitHeight

    MouseArea {
        anchors.fill: parent

        onWheel: event => {
            if (event.angleDelta.y > 0)
                Audio.setVolume(Audio.volume + 0.1);
            else if (event.angleDelta.y < 0)
                Audio.setVolume(Audio.volume - 0.1);
        }
    }

    Item {
        id: child

        property Item current: text1

        anchors.centerIn: parent

        clip: true
        implicitWidth: icon.implicitWidth + current.implicitWidth + current.anchors.leftMargin + Appearance.padding.small
        implicitHeight: Math.max(icon.implicitHeight, current.implicitHeight)

        MaterialIcon {
            id: icon

            animate: true
            text: Icons.getAppCategoryIcon(Hyprland.activeToplevel?.lastIpcObject.class, "desktop_windows")
            color: root.colour

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
        }

        Title {
            id: text1
        }

        Title {
            id: text2
        }

        TextMetrics {
            id: metrics

            text: Hyprland.activeToplevel?.title ?? qsTr("Desktop")
            font.pointSize: Appearance.font.size.smaller
            font.family: Appearance.font.family.mono
            elide: Qt.ElideRight
            elideWidth: root.width - icon.width - Appearance.spacing.normal - Appearance.padding.normal * 2

            onTextChanged: {
                const next = child.current === text1 ? text2 : text1;
                next.text = elidedText;
                child.current = next;
            }
            onElideWidthChanged: child.current.text = elidedText
        }

        Behavior on implicitWidth {
            NumberAnimation {
                duration: Appearance.anim.durations.normal
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.anim.curves.emphasized
            }
        }

        Behavior on implicitHeight {
            NumberAnimation {
                duration: Appearance.anim.durations.normal
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.anim.curves.emphasized
            }
        }
    }

    component Title: StyledText {
        id: text

        anchors.verticalCenter: icon.verticalCenter
        anchors.left: icon.right
        anchors.leftMargin: Appearance.spacing.normal

        font.pointSize: metrics.font.pointSize
        font.family: metrics.font.family
        color: root.colour
        opacity: child.current === this ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: Appearance.anim.durations.normal
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.anim.curves.standard
            }
        }
    }
}
