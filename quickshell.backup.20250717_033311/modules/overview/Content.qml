import "./../../widgets"
import "./../../services"
import "./../../config"
import Quickshell
import QtQuick

Rectangle {
    id: root

    required property PersistentProperties visibilities

    color: Colours.alpha(Colours.palette.m3surface, 0.9)
    
    MouseArea {
        anchors.fill: parent
        enabled: root.visibilities.overview
        visible: root.visibilities.overview
        propagateComposedEvents: !root.visibilities.overview
        onClicked: root.visibilities.overview = false
    }

    Column {
        anchors.fill: parent
        anchors.margins: Appearance.padding.huge
        spacing: Appearance.spacing.huge

        SearchBar {
            id: searchBar
            
            anchors.horizontalCenter: parent.horizontalCenter
            width: Math.min(parent.width, 600)
            
            onSearchTextChanged: function(searchText) { appGrid.filterText = searchText; }
            onEscapePressed: root.visibilities.overview = false
            onDownPressed: {
                appGrid.forceActiveFocus();
            }
            
            Component.onCompleted: {
                if (root.visibilities.overview) {
                    forceActiveFocus();
                }
            }
            
            Connections {
                target: root.visibilities
                
                function onOverviewChanged() {
                    if (root.visibilities.overview) {
                        searchBar.forceActiveFocus();
                        searchBar.clear();
                    }
                }
            }
        }

        AppGrid {
            id: appGrid
            
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            height: parent.height - searchBar.height - parent.spacing
            
            visibilities: root.visibilities
            
            onAppLaunched: {
                root.visibilities.overview = false;
            }
        }
    }
}