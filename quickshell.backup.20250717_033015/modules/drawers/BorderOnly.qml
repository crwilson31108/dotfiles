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

        StyledWindow {
            id: borderWin

            screen: scope.modelData
            name: "border"
            WlrLayershell.layer: WlrLayer.Bottom
            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

            anchors.top: true
            anchors.bottom: true
            anchors.left: true
            anchors.right: true

            Item {
                anchors.fill: parent
                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    blurMax: 15
                    shadowColor: Qt.alpha(Colours.palette.m3shadow, 0.7)
                }

                StyledRect {
                    anchors.fill: parent
                    color: Colours.alpha(Colours.palette.m3surface, false)

                    layer.enabled: true
                    layer.effect: MultiEffect {
                        maskSource: mask
                        maskEnabled: true
                        maskInverted: true
                        maskThresholdMin: 0.5
                        maskSpreadAtMin: 1
                    }
                }

                Item {
                    id: mask

                    anchors.fill: parent
                    layer.enabled: true
                    visible: false

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: Config.border.thickness
                        anchors.topMargin: 32 // Approximate bar height
                        radius: Config.border.rounding
                    }
                }
            }
        }
    }
}