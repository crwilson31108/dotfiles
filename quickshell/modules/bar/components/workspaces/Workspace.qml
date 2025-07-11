import "./../../../../widgets"
import "./../../../../services"
import "./../../../../utils"
import "./../../../../config"
import Quickshell
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    required property int index
    required property var occupied
    required property int groupOffset

    readonly property bool isWorkspace: true // Flag for finding workspace children
    // Unanimated prop for others to use as reference
    readonly property real size: childrenRect.width + (hasWindows ? Appearance.padding.smaller : 0)

    readonly property int ws: groupOffset + index + 1
    readonly property bool isOccupied: occupied[ws] ?? false
    readonly property bool hasWindows: false // Disabled window icons

    Layout.preferredWidth: size
    Layout.preferredHeight: childrenRect.height

    StyledText {
        id: indicator

        readonly property string label: Config.bar.workspaces.label || root.ws.toString()
        readonly property string occupiedLabel: Config.bar.workspaces.occupiedLabel || label
        readonly property string activeLabel: Config.bar.workspaces.activeLabel || label

        animate: true
        text: Hyprland.activeWsId === root.ws ? activeLabel : root.isOccupied ? occupiedLabel : label
        color: Config.bar.workspaces.occupiedBg || root.isOccupied || Hyprland.activeWsId === root.ws ? Colours.palette.m3onSurface : Colours.palette.m3outlineVariant
        horizontalAlignment: StyledText.AlignHCenter
        verticalAlignment: StyledText.AlignVCenter
        
        width: Config.bar.sizes.innerHeight
        height: Config.bar.sizes.innerHeight
    }

    Loader {
        id: windows

        active: hasWindows
        asynchronous: true

        anchors.verticalCenter: indicator.verticalCenter
        anchors.left: indicator.right
        anchors.leftMargin: -Config.bar.sizes.innerHeight / 10

        sourceComponent: Row {
            spacing: 0

            add: Transition {
                Anim {
                    properties: "scale"
                    from: 0
                    to: 1
                    easing.bezierCurve: Appearance.anim.curves.standardDecel
                }
            }

            move: Transition {
                Anim {
                    properties: "scale"
                    to: 1
                    easing.bezierCurve: Appearance.anim.curves.standardDecel
                }
                Anim {
                    properties: "x,y"
                }
            }

            Repeater {
                model: ScriptModel {
                    values: Hyprland.toplevels.values.filter(c => c.workspace?.id === root.ws)
                }

                MaterialIcon {
                    required property var modelData

                    grade: 0
                    text: Icons.getAppCategoryIcon(modelData.lastIpcObject.class, "terminal")
                    color: Colours.palette.m3onSurfaceVariant
                }
            }
        }
    }

    Behavior on Layout.preferredWidth {
        Anim {}
    }

    Behavior on Layout.preferredHeight {
        Anim {}
    }

    component Anim: NumberAnimation {
        duration: Appearance.anim.durations.normal
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Appearance.anim.curves.standard
    }
}
