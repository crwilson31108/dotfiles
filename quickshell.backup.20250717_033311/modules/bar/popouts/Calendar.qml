import "./../../../widgets"
import "./../../../services"
import "./../../../config"
import QtQuick
import QtQuick.Controls

Column {
    id: root
    
    spacing: Appearance.spacing.normal
    
    // Header with month and year
    Row {
        width: parent.width
        spacing: Appearance.spacing.normal
        
        StyledText {
            text: calendar.monthName + " " + calendar.year
            font.pointSize: Appearance.font.size.normal
            font.weight: Font.DemiBold
            color: Colours.palette.m3onSurface
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    
    // Day of week headers
    Grid {
        columns: 7
        spacing: Appearance.spacing.small
        
        Repeater {
            model: ["S", "M", "T", "W", "T", "F", "S"]
            
            StyledText {
                text: modelData
                font.pointSize: Appearance.font.size.smaller
                color: Colours.palette.m3onSurfaceVariant
                horizontalAlignment: Text.AlignHCenter
                width: 32
            }
        }
    }
    
    // Calendar grid
    Grid {
        id: calendar
        
        property int year: new Date().getFullYear()
        property int month: new Date().getMonth()
        property int day: new Date().getDate()
        property string monthName: new Date(year, month, 1).toLocaleString(Qt.locale(), "MMMM")
        property int daysInMonth: new Date(year, month + 1, 0).getDate()
        property int firstDayOfMonth: new Date(year, month, 1).getDay()
        
        columns: 7
        spacing: Appearance.spacing.small
        
        // Empty cells for days before month starts
        Repeater {
            model: calendar.firstDayOfMonth
            
            Item {
                width: 32
                height: 32
            }
        }
        
        // Days of the month
        Repeater {
            model: calendar.daysInMonth
            
            StyledRect {
                width: 32
                height: 32
                radius: Appearance.rounding.small
                color: (modelData + 1) === calendar.day ? 
                    Colours.palette.m3primary : 
                    hovered ? Colours.palette.m3surfaceContainerHighest : "transparent"
                
                property bool hovered: false
                
                StyledText {
                    anchors.centerIn: parent
                    text: modelData + 1
                    font.pointSize: Appearance.font.size.smaller
                    color: (modelData + 1) === calendar.day ? 
                        Colours.palette.m3onPrimary : 
                        Colours.palette.m3onSurface
                }
                
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: parent.hovered = true
                    onExited: parent.hovered = false
                }
            }
        }
    }
}