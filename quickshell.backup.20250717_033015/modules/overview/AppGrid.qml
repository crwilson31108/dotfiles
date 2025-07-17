import "./../../widgets"
import "./../../services"
import "./../../config"
import Quickshell
import QtQuick
import QtQuick.Controls

Item {
    id: root

    required property PersistentProperties visibilities
    property string filterText: ""
    
    signal appLaunched()

    property alias currentIndex: gridView.currentIndex
    
    function forceActiveFocus() {
        gridView.forceActiveFocus();
        if (gridView.currentIndex === -1 && gridView.count > 0) {
            gridView.currentIndex = 0;
        }
    }

    GridView {
        id: gridView

        anchors.fill: parent
        anchors.margins: Appearance.padding.normal
        
        // Ensure proper scroll handling
        interactive: true
        clip: true
        
        readonly property int itemSize: 128
        readonly property int spacing: Appearance.spacing.large
        
        cellWidth: itemSize + spacing
        cellHeight: itemSize + spacing
        
        function getModelValues() {
            return Apps.fuzzyQuery(root.filterText);
        }

        model: ScriptModel {
            values: gridView.getModelValues()
            onValuesChanged: gridView.currentIndex = -1
        }

        delegate: AppIcon {
            width: gridView.itemSize
            height: gridView.itemSize
            
            onClicked: {
                Apps.launch(modelData);
                root.appLaunched();
            }
        }
        
        ScrollBar.vertical: StyledScrollBar {}
        
        highlight: Rectangle {
            color: Colours.alpha(Colours.palette.m3primary, 0.12)
            radius: Appearance.rounding.large
            visible: gridView.currentIndex >= 0
        }
        
        Keys.onPressed: function(event) {
            // Handle arrow keys first to ensure they work
            if (event.key === Qt.Key_Up || event.key === Qt.Key_Down || 
                event.key === Qt.Key_Left || event.key === Qt.Key_Right) {
                
                // If no current selection, start at first item for any arrow key
                if (gridView.currentIndex === -1 && gridView.count > 0) {
                    gridView.currentIndex = 0;
                    event.accepted = true;
                    return;
                }
                
                // Let GridView handle normal navigation
                event.accepted = false;
                return;
            }
            
            // Handle other keys
            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                if (gridView.currentItem) {
                    gridView.currentItem.clicked();
                    event.accepted = true;
                }
            } else if (event.key === Qt.Key_Escape) {
                root.visibilities.overview = false;
                event.accepted = true;
            }
        }
    }
}