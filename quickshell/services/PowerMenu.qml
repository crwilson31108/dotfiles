pragma Singleton

import QtQuick

QtObject {
    property var currentMenu: null
    
    function toggle() {
        if (currentMenu) {
            currentMenu.visible = !currentMenu.visible;
        }
    }
    
    function show() {
        if (currentMenu) {
            currentMenu.visible = true;
        }
    }
    
    function hide() {
        if (currentMenu) {
            currentMenu.visible = false;
        }
    }
}