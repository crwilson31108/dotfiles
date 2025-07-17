import "./../../services"
import "./../../config"
import QtQuick
import QtQuick.Shapes

ShapePath {
    id: root

    required property Wrapper wrapper
    readonly property real rounding: Config.border.rounding
    readonly property bool flatten: wrapper.height < rounding * 2
    readonly property real roundingY: flatten ? wrapper.height / 2 : rounding

    strokeWidth: -1
    fillColor: Colours.palette.m3surface

    PathArc {
        relativeX: root.rounding
        relativeY: -root.roundingY  // Inverted: start going up (negative Y) for bottom drawer
        radiusX: root.rounding
        radiusY: Math.min(root.rounding, root.wrapper.height)
        direction: PathArc.Clockwise  // Bottom-left connects to bar
    }

    PathLine {
        relativeX: 0
        relativeY: -(root.wrapper.height - root.roundingY * 2)  // Inverted: go up instead of down
    }

    PathArc {
        relativeX: root.rounding
        relativeY: -root.roundingY  // Inverted: top corners are rounded
        radiusX: root.rounding
        radiusY: Math.min(root.rounding, root.wrapper.height)
        direction: PathArc.Clockwise  // Changed to Clockwise for outward curve
    }

    PathLine {
        relativeX: root.wrapper.width - root.rounding * 2
        relativeY: 0
    }

    PathArc {
        relativeX: root.rounding
        relativeY: root.roundingY  // Inverted: bottom corners connect to bar (positive Y)
        radiusX: root.rounding
        radiusY: Math.min(root.rounding, root.wrapper.height)
        direction: PathArc.Clockwise  // Changed to Clockwise for proper bar connection
    }

    PathLine {
        relativeX: 0
        relativeY: root.wrapper.height - root.roundingY * 2  // Inverted: go down to close the path
    }

    PathArc {
        relativeX: root.rounding
        relativeY: root.roundingY  // Inverted: bottom corner connects to bar
        radiusX: root.rounding
        radiusY: Math.min(root.rounding, root.wrapper.height)
    }

    Behavior on fillColor {
        ColorAnimation {
            duration: Appearance.anim.durations.normal
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Appearance.anim.curves.standard
        }
    }
}
