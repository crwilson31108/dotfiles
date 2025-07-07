pragma ComponentBehavior: Bound

import "./../../widgets"
import "./../../config"
import Quickshell
import QtQuick

Scope {
    id: root

    required property ShellScreen screen
    required property Item bar

    ExclusionZone {
        anchors.top: true
        exclusiveZone: root.bar.implicitHeight + 8
    }

    ExclusionZone {
        anchors.left: true
        exclusiveZone: Config.border.thickness + 8
    }

    ExclusionZone {
        anchors.right: true
        exclusiveZone: Config.border.thickness + 8
    }

    ExclusionZone {
        anchors.bottom: true
        exclusiveZone: Config.border.thickness + 8
    }

    component ExclusionZone: StyledWindow {
        screen: root.screen
        name: "border-exclusion"
        exclusiveZone: Config.border.thickness
        mask: Region {}
    }
}
