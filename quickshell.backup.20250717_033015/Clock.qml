import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io

Button {
    property var rosePineTheme
    property real scaleFactor: 1.0
    
    implicitWidth: contentItem.implicitWidth + (20 * scaleFactor)
    implicitHeight: 30 * scaleFactor
    
    property bool showDate: true
    property string timeFormat: showDate ? "ddd MMM d  h:mm AP" : "h:mm AP"
    
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            timeText.text = Qt.formatDateTime(new Date(), timeFormat)
        }
    }
    
    background: Rectangle {
        color: hovered ? rosePineTheme.highlightLow : "transparent"
        radius: 6 * scaleFactor
        
        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }
    
    contentItem: Text {
        id: timeText
        text: Qt.formatDateTime(new Date(), timeFormat)
        color: rosePineTheme.text
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 14 * scaleFactor
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        
        MouseArea {
            anchors.fill: parent
            onClicked: {
                showDate = !showDate
            }
        }
    }
    
    onClicked: {
        // Launch calendar
        calendarProc.running = true
    }
    
    Process {
        id: calendarProc
        command: ["gnome-calendar"]
        running: false
    }
}