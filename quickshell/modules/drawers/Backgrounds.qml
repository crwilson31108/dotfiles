import "./../../services"
import "./../../config"
import "./../osd" as Osd
import "./../notifications" as Notifications
// import "./../session" as Session // Module not available
import "./../launcher" as Launcher
import "./../dashboard" as Dashboard
import "./../windowswitcher" as WindowSwitcherModule
import "./../bar/popouts" as BarPopouts
import QtQuick
import QtQuick.Shapes

Shape {
    id: root

    required property Panels panels
    required property Item bar
    readonly property real rounding: Config.border.rounding

    anchors.fill: parent
    anchors.margins: Config.border.thickness
    anchors.topMargin: bar.implicitHeight
    preferredRendererType: Shape.CurveRenderer
    opacity: Colours.transparency.enabled ? Colours.transparency.base : 1

    Osd.Background {
        wrapper: panels.osd

        startX: root.width
        startY: (root.height - wrapper.height) / 2 - rounding
    }

    Notifications.Background {
        wrapper: panels.notifications

        startX: root.width
        startY: 0
    }

    // Session.Background {
    //     wrapper: panels.session
    //
    //     startX: root.width
    //     startY: (root.height - wrapper.height) / 2 - rounding
    // }

    Launcher.Background {
        wrapper: panels.launcher

        startX: (root.width - wrapper.width) / 2 - rounding
        startY: root.height
    }

    Dashboard.Background {
        wrapper: panels.dashboard

        startX: (root.width - wrapper.width) / 2 - rounding
        startY: root.height  // Start at the bottom of the screen for bottom drawer
    }

    WindowSwitcherModule.Background {
        wrapper: panels.windowSwitcher

        startX: (root.width - wrapper.width) / 2 - rounding
        startY: root.height  // Start at the bottom of the screen for bottom drawer
    }

    BarPopouts.Background {
        wrapper: panels.popouts
        invertBottomRounding: false  // For horizontal top bar: always round bottom corners, keep top corners sharp

        startX: wrapper.x
        startY: wrapper.y  // No vertical offset needed since popup connects to top bar
    }
}
