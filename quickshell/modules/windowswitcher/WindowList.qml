import "./../../widgets"
import "./../../services"
import "./../../config"
import "./../../utils"
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    readonly property int maxHorizontalItems: 6
    readonly property bool useGridLayout: WindowSwitcher.availableWindows.length > maxHorizontalItems
    
    implicitWidth: useGridLayout ? gridLayout.implicitWidth : horizontalLayout.implicitWidth
    implicitHeight: useGridLayout ? gridLayout.implicitHeight : horizontalLayout.implicitHeight

    // Horizontal layout for <= 6 windows
    RowLayout {
        id: horizontalLayout
        
        visible: !root.useGridLayout
        anchors.centerIn: parent
        spacing: Appearance.spacing.normal

        Repeater {
            model: WindowSwitcher.availableWindows
            
            WindowCard {
                required property var modelData
                required property int index
                
                window: modelData
                selected: WindowSwitcher.currentIndex === index
                
                onClicked: WindowSwitcher.selectWindow(modelData)
            }
        }
    }

    // Grid layout for > 6 windows  
    GridLayout {
        id: gridLayout
        
        visible: root.useGridLayout
        anchors.centerIn: parent
        
        columns: Math.min(4, Math.ceil(Math.sqrt(WindowSwitcher.availableWindows.length)))
        rows: Math.ceil(WindowSwitcher.availableWindows.length / columns)
        
        columnSpacing: Appearance.spacing.normal
        rowSpacing: Appearance.spacing.normal

        Repeater {
            model: WindowSwitcher.availableWindows
            
            WindowCard {
                required property var modelData
                required property int index
                
                window: modelData
                selected: WindowSwitcher.currentIndex === index
                compact: true  // Smaller size for grid
                
                onClicked: WindowSwitcher.selectWindow(modelData)
            }
        }
    }
}