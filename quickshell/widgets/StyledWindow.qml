import "./../utils"
import "./../config"
import Quickshell
import Quickshell.Wayland

PanelWindow {
    required property string name

    WlrLayershell.namespace: `caelestia-${name}`
    color: "transparent"
}
