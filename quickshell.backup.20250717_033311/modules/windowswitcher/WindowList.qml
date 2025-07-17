import "./../../widgets"
import "./../../services"
import "./../../config"
import "./../../utils"
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    readonly property int maxVisibleCards: 5
    readonly property bool needsSliding: WindowSwitcher.availableWindows.length > maxVisibleCards
    readonly property int startIndex: needsSliding ? 
        Math.max(0, Math.min(WindowSwitcher.currentIndex - Math.floor(maxVisibleCards / 2), 
                             WindowSwitcher.availableWindows.length - maxVisibleCards)) : 0
    readonly property var visibleWindows: needsSliding ? 
        WindowSwitcher.availableWindows.slice(startIndex, startIndex + maxVisibleCards) : 
        WindowSwitcher.availableWindows
    
    readonly property bool hasMore: WindowSwitcher.availableWindows.length > maxVisibleCards
    readonly property bool hasMoreBefore: hasMore && startIndex > 0
    readonly property bool hasMoreAfter: hasMore && (startIndex + maxVisibleCards) < WindowSwitcher.availableWindows.length
    
    implicitWidth: horizontalLayout.implicitWidth
    implicitHeight: horizontalLayout.implicitHeight

    // Single row layout - always horizontal
    RowLayout {
        id: horizontalLayout
        
        anchors.centerIn: parent
        spacing: Appearance.spacing.large

        // "More before" indicator
        Rectangle {
            visible: root.hasMoreBefore
            width: 8
            height: 60
            radius: 4
            color: Colours.alpha(Colours.palette.m3onSurface, 0.3)
            
            Rectangle {
                anchors.centerIn: parent
                width: 4
                height: 4
                radius: 2
                color: Colours.palette.m3onSurface
            }
        }

        Repeater {
            model: root.visibleWindows
            
            WindowCard {
                required property var modelData
                required property int index
                
                window: modelData
                selected: root.needsSliding ? 
                    WindowSwitcher.currentIndex === (root.startIndex + index) : 
                    WindowSwitcher.currentIndex === index
                showPreview: selected
                
                onClicked: WindowSwitcher.selectWindow(modelData)
                
                // Smooth sliding animation
                opacity: 1.0
                scale: 1.0
                
                Behavior on opacity {
                    NumberAnimation {
                        duration: Appearance.anim.durations.fast
                        easing.type: Easing.OutCubic
                    }
                }
                
                Behavior on scale {
                    NumberAnimation {
                        duration: Appearance.anim.durations.fast  
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }
        
        // "More after" indicator
        Rectangle {
            visible: root.hasMoreAfter
            width: 8
            height: 60
            radius: 4
            color: Colours.alpha(Colours.palette.m3onSurface, 0.3)
            
            Rectangle {
                anchors.centerIn: parent
                width: 4
                height: 4
                radius: 2
                color: Colours.palette.m3onSurface
            }
        }
    }
}