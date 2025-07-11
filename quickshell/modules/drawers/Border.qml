pragma ComponentBehavior: Bound

import "./../../widgets"
import "./../../services"
import "./../../config"
import QtQuick
import QtQuick.Effects

Item {
    id: root

    required property Item bar

    anchors.fill: parent

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
            anchors.topMargin: root.bar.implicitHeight
            radius: Config.border.rounding
        }
    }
}
