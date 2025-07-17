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
    readonly property bool isActive: Hyprland.activeWsId === root.ws

    Layout.preferredWidth: size
    Layout.preferredHeight: childrenRect.height

    StyledRect {
        id: background
        
        anchors.fill: indicator
        radius: indicator.width / 2  // Full circle
        color: root.isActive ? Qt.alpha(Colours.palette.m3primary, 0.2) : "transparent"
        
        Behavior on color {
            ColorAnimation {
                duration: Appearance.anim.durations.fast
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.anim.curves.standard
            }
        }
    }

    StyledText {
        id: indicator

        readonly property string label: Config.bar.workspaces.label || root.ws.toString()
        readonly property string occupiedLabel: Config.bar.workspaces.occupiedLabel || label
        readonly property string activeLabel: Config.bar.workspaces.activeLabel || label

        animate: true
        text: root.isActive ? activeLabel : root.isOccupied ? occupiedLabel : label
        color: root.isActive ? Colours.palette.m3primary : root.isOccupied ? Colours.palette.m3onSurface : Colours.palette.m3outlineVariant
        horizontalAlignment: StyledText.AlignHCenter
        verticalAlignment: StyledText.AlignVCenter
        font.weight: root.isActive ? Font.Medium : Font.Normal
        
        width: Config.bar.sizes.innerHeight
        height: Config.bar.sizes.innerHeight
        
        scale: stateLayer.pressed ? 0.95 : 1.0
        
        Behavior on scale {
            NumberAnimation {
                duration: Appearance.anim.durations.fast
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.anim.curves.standard
            }
        }
    }
    
    StateLayer {
        id: stateLayer
        
        color: Colours.palette.m3primary
        radius: indicator.width / 2  // Full circle
        disabled: false
        
        onClicked: {
            if (Hyprland.activeWsId !== root.ws)
                Hyprland.dispatch(`workspace ${root.ws}`);
        }
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
