pragma ComponentBehavior: Bound

import "./../../widgets"
import "./../../services"
import "./../../config"
import "./../bar"
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Effects

Variants {
    model: Quickshell.screens

    Scope {
        id: scope

        required property ShellScreen modelData

        Exclusions {
            screen: scope.modelData
            bar: bar
        }

        StyledWindow {
            id: win

            screen: scope.modelData
            name: "drawers"
            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            WlrLayershell.keyboardFocus: visibilities.launcher || visibilities.session || visibilities.windowswitcher || visibilities.overview ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

            mask: Region {
                x: Config.border.thickness
                y: bar.implicitHeight
                width: win.width - Config.border.thickness * 2
                height: win.height - bar.implicitHeight - Config.border.thickness
                intersection: Intersection.Xor

                regions: regions.instances
            }

            anchors.top: true
            anchors.bottom: true
            anchors.left: true
            anchors.right: true

            Variants {
                id: regions

                model: panels.children

                Region {
                    required property Item modelData

                    x: modelData.x + Config.border.thickness
                    y: modelData.y + bar.implicitHeight
                    width: modelData.width
                    height: modelData.height
                    intersection: Intersection.Subtract
                }
            }

            HyprlandFocusGrab {
                active: visibilities.launcher || visibilities.session || visibilities.windowswitcher || visibilities.overview
                windows: [win]
                onCleared: {
                    visibilities.launcher = false;
                    visibilities.session = false;
                    visibilities.windowswitcher = false;
                    visibilities.overview = false;
                }
            }

            StyledRect {
                anchors.fill: parent
                opacity: visibilities.session ? 0.5 : 0
                color: Colours.palette.m3scrim

                Behavior on opacity {
                    NumberAnimation {
                        duration: Appearance.anim.durations.normal
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Appearance.anim.curves.standard
                    }
                }
            }

            Item {
                anchors.fill: parent

                Border {
                    bar: bar
                }

                Backgrounds {
                    panels: panels
                    bar: bar
                }

                // Visual cues for hover trigger areas
                Rectangle {
                    id: osdTriggerCue
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    width: 4
                    height: 60
                    color: "#663399"
                    opacity: 0.7
                    radius: 2
                }

                Rectangle {
                    id: dashboardTriggerCue
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 60
                    height: 4
                    color: "#663399"
                    opacity: 0.7
                    radius: 2
                }
            }

            PersistentProperties {
                id: visibilities

                property bool osd
                property bool session
                property bool launcher
                property bool dashboard
                property bool windowswitcher
                property bool overview

                Component.onCompleted: Visibilities.screens[scope.modelData] = this
            }

            Interactions {
                screen: scope.modelData
                popouts: panels.popouts
                visibilities: visibilities
                panels: panels
                bar: bar

                Panels {
                    id: panels

                    screen: scope.modelData
                    visibilities: visibilities
                    bar: bar
                }
            }

            Bar {
                id: bar

                screen: scope.modelData
                popouts: panels.popouts
                visibilities: visibilities
            }
        }
    }
}