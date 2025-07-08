import "./../../widgets"
import "./../../services"
import "./../../config"
import Quickshell
import QtQuick

StyledRect {
    id: root

    property alias search: searchField.text
    signal searchTextChanged(string search)
    signal escapePressed()
    signal downPressed()
    
    function clear() {
        searchField.text = "";
    }
    
    function forceActiveFocus() {
        searchField.forceActiveFocus();
    }

    color: Colours.alpha(Colours.palette.m3surfaceContainer, 0.8)
    radius: Appearance.rounding.full

    implicitHeight: Math.max(searchIcon.implicitHeight, searchField.implicitHeight) + Appearance.padding.normal * 2
    implicitWidth: 600

    MaterialIcon {
        id: searchIcon

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: Appearance.padding.large

        text: "search"
        color: Colours.palette.m3onSurfaceVariant
        font.pointSize: Appearance.font.size.normal
    }

    StyledTextField {
        id: searchField

        anchors.left: searchIcon.right
        anchors.right: parent.right
        anchors.leftMargin: Appearance.spacing.small
        anchors.rightMargin: Appearance.padding.large
        anchors.verticalCenter: parent.verticalCenter

        placeholderText: qsTr("Search applications...")
        background: null
        
        font.pointSize: Appearance.font.size.large
        
        onTextChanged: root.searchTextChanged(text)
        
        Keys.onEscapePressed: root.escapePressed()
        
        Keys.onDownPressed: {
            root.downPressed();
        }
    }
}