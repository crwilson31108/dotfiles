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
        
        ScrollBar.vertical: StyledScrollBar {
            id: scrollBar
            stepSize: 0.5  // Much larger step size for faster scrolling
        }
        
        // Momentum scrolling variables
        property real velocity: 0
        property real lastWheelTime: 0
        property real targetContentY: contentY
        
        // Smooth scrolling behavior using Behavior animation
        Behavior on contentY {
            SmoothedAnimation {
                velocity: 4000  // Pixels per second - faster and more responsive
                duration: -1    // Use velocity-based timing
            }
        }
        
        // Momentum physics with smoother updates
        Timer {
            id: momentumTimer
            interval: 8  // 120fps for extra smoothness
            repeat: true
            onTriggered: {
                if (Math.abs(gridView.velocity) > 0.05) {  // Lower threshold for longer momentum
                    // Calculate new target position
                    const maxY = Math.max(0, gridView.contentHeight - gridView.height)
                    gridView.targetContentY = Math.max(0, Math.min(gridView.targetContentY - gridView.velocity, maxY))
                    
                    // Update contentY (will be smoothed by Behavior)
                    gridView.contentY = gridView.targetContentY
                    
                    // Apply friction - more gradual
                    gridView.velocity *= 0.97
                } else {
                    // Stop momentum when velocity is too low
                    gridView.velocity = 0
                    stop()
                }
            }
        }
        
        // Enhanced mouse wheel handling with momentum
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.NoButton
            onWheel: event => {
                const currentTime = Date.now()
                const deltaTime = Math.max(1, currentTime - gridView.lastWheelTime)
                gridView.lastWheelTime = currentTime
                
                // Calculate scroll amount
                const scrollDelta = event.angleDelta.y * 1.5  // Increased for more speed
                
                // Add to velocity for momentum
                const accelerationFactor = Math.min(1.8, 80 / deltaTime)
                gridView.velocity += (scrollDelta * accelerationFactor) * 0.08
                
                // Immediate response to wheel - more responsive
                const immediateScroll = scrollDelta * 0.25
                const maxY = Math.max(0, gridView.contentHeight - gridView.height)
                gridView.targetContentY = Math.max(0, Math.min(gridView.targetContentY - immediateScroll, maxY))
                gridView.contentY = gridView.targetContentY  // Smoothed by Behavior
                
                // Start momentum if not already running
                if (!momentumTimer.running) {
                    momentumTimer.start()
                }
            }
        }
        
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