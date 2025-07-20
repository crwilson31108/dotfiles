import QtQuick
import Quickshell
import Quickshell.Wayland

PersistentWindow {
    id: overlay
    
    property bool loaded: false
    
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    color: "black"
    visible: !loaded
    
    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true
    
    Timer {
        id: hideTimer
        interval: 500
        running: loaded
        onTriggered: overlay.visible = false
    }
    
    Behavior on opacity {
        NumberAnimation {
            duration: 300
            easing.type: Easing.InOutQuad
        }
    }
    
    states: State {
        name: "hidden"
        when: loaded
        PropertyChanges {
            target: overlay
            opacity: 0
        }
    }
}