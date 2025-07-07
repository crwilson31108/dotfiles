import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

ShellRoot {
    id: root
    
    property real scaleFactor: 1.0  // Let Hyprland handle scaling
    
    property var rosePine: QtObject {
        property color base: "#191724"
        property color surface: "#1f1d2e"
        property color overlay: "#26233a"
        property color muted: "#6e6a86"
        property color subtle: "#908caa"
        property color text: "#e0def4"
        property color love: "#eb6f92"
        property color gold: "#f6c177"
        property color rose: "#ebbcba"
        property color pine: "#31748f"
        property color foam: "#9ccfd8"
        property color iris: "#c4a7e7"
        property color highlightLow: "#21202e"
        property color highlightMed: "#403d52"
        property color highlightHigh: "#524f67"
    }

    PanelWindow {
        id: bar
        
        anchors {
            top: true
            left: true
            right: true
        }
        
        implicitHeight: 40 * root.scaleFactor
        color: Qt.rgba(root.rosePine.surface.r, root.rosePine.surface.g, root.rosePine.surface.b, 0.9)
        
        exclusionMode: ExclusionMode.Normal
        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.exclusiveZone: implicitHeight
        
        RowLayout {
            anchors.fill: parent
            anchors.margins: 8 * root.scaleFactor
            spacing: 4 * root.scaleFactor
            
            // Left section - Workspaces
            RowLayout {
                Layout.alignment: Qt.AlignLeft
                spacing: 4 * root.scaleFactor
                
                Repeater {
                    model: 4  // Persistent workspaces 1-4
                    delegate: WorkspaceButton {
                        workspace: index + 1
                        rosePineTheme: root.rosePine
                        scaleFactor: root.scaleFactor
                    }
                }
            }
            
            // Spacer
            Item { Layout.fillWidth: true }
            
            // Center section - Clock
            Clock {
                Layout.alignment: Qt.AlignCenter
                rosePineTheme: root.rosePine
                scaleFactor: root.scaleFactor
            }
            
            // Spacer
            Item { Layout.fillWidth: true }
            
            // Right section - System modules
            RowLayout {
                Layout.alignment: Qt.AlignRight
                spacing: 12 * root.scaleFactor
                
                Network {
                    rosePineTheme: root.rosePine
                    scaleFactor: root.scaleFactor
                }
                
                Backlight {
                    rosePineTheme: root.rosePine
                }
                
                PulseAudio {
                    rosePineTheme: root.rosePine
                }
                
                Battery {
                    rosePineTheme: root.rosePine
                }
                
                PowerMenu {
                    rosePineTheme: root.rosePine
                    scaleFactor: root.scaleFactor
                }
            }
        }
    }
}