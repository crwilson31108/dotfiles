import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

RowLayout {
    property var rosePineTheme
    property real scaleFactor: 1.0
    
    spacing: 4 * scaleFactor
    
    Repeater {
        model: SystemTray.items
        
        Button {
            implicitWidth: 24 * scaleFactor
            implicitHeight: 24 * scaleFactor
            
            background: Rectangle {
                color: hovered ? rosePineTheme.highlightLow : "transparent"
                radius: 4 * scaleFactor
                
                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }
            
            contentItem: Image {
                source: modelData.icon || ""
                fillMode: Image.PreserveAspectFit
                smooth: true
            }
            
            onClicked: {
                if (modelData.menu) {
                    modelData.menu.open()
                } else {
                    modelData.activate()
                }
            }
            
            onPressAndHold: {
                if (modelData.menu) {
                    modelData.menu.open()
                }
            }
        }
    }
}