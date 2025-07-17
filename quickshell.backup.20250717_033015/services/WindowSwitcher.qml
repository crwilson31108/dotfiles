pragma Singleton

import "."
import Quickshell
import Quickshell.Hyprland
import QtQuick

Singleton {
    id: root

    // Public properties
    property bool visible: false
    property int currentIndex: 0
    property var availableWindows: []
    property var selectedWindow: null
    property var focusHistory: []
    
    // Periodic cleanup to remove stale window addresses from history
    Timer {
        interval: 30000 // 30 seconds
        running: true
        repeat: true
        
        onTriggered: {
            if (focusHistory.length === 0) return;
            
            // Get current valid window addresses
            const validAddresses = Hyprland.toplevels.values.map(window => window.address);
            
            // Filter out invalid addresses
            const originalLength = focusHistory.length;
            focusHistory = focusHistory.filter(address => validAddresses.includes(address));
        }
    }
    
    
    function show(): void {
        if (visible) return;
        
        // Stop the hide timer if it's running (user showing switcher again quickly)
        hideTimer.stop();
        
        // Get all windows excluding special workspaces and minimized
        let filteredWindows = Hyprland.toplevels.values.filter(window => {
            return window.mapped !== false && 
                   !window.workspace?.name?.startsWith("special:") &&
                   window.title !== "" &&
                   window.title !== null &&
                   window.workspace?.id !== undefined;
        });
        
        if (filteredWindows.length === 0) return;
        
        // Sort by our manual focus history (most recently focused first)
        availableWindows = filteredWindows.sort((a, b) => {
            const aIndex = focusHistory.indexOf(a.address);
            const bIndex = focusHistory.indexOf(b.address);
            
            // If both are in history, sort by position (later = more recent)
            if (aIndex >= 0 && bIndex >= 0) {
                return bIndex - aIndex;
            }
            // If only one is in history, prioritize it
            if (aIndex >= 0) return -1;
            if (bIndex >= 0) return 1;
            // If neither in history, keep original order
            return 0;
        });
        
        
        // Start from the second most recently focused window (index 1)
        // since index 0 is the currently active window
        currentIndex = availableWindows.length > 1 ? 1 : 0;
        
        selectedWindow = availableWindows[currentIndex];
        visible = true;
        
        
        // Also set the visibility in the drawer system
        const visibilities = Visibilities.getForActive();
        if (visibilities) {
            visibilities.windowswitcher = true;
        }
        
    }
    
    function hide(): void {
        if (!visible) return;
        
        // Focus the selected window if we have one
        if (selectedWindow) {
            Hyprland.dispatch(`focuswindow address:0x${selectedWindow.address.toString(16)}`);
        }
        
        visible = false;
        
        // Clear the visibility in the drawer system to start animation
        const visibilities = Visibilities.getForActive();
        if (visibilities) {
            visibilities.windowswitcher = false;
        }
        
        // Delay clearing the window data until animation completes
        // Use the same duration as the exit animation
        hideTimer.start();
    }
    
    Timer {
        id: hideTimer
        interval: 400 // Should match Appearance.anim.durations.expressiveDefaultSpatial
        running: false
        repeat: false
        
        onTriggered: {
            // Double-check that we're not visible before clearing
            if (!visible) {
                availableWindows = [];
                selectedWindow = null;
                currentIndex = 0;
            }
        }
    }
    
    function cycleNext(): void {
        if (!visible || availableWindows.length === 0) return;
        
        currentIndex = (currentIndex + 1) % availableWindows.length;
        selectedWindow = availableWindows[currentIndex];
    }
    
    function cyclePrevious(): void {
        if (!visible || availableWindows.length === 0) return;
        
        currentIndex = currentIndex > 0 ? currentIndex - 1 : availableWindows.length - 1;
        selectedWindow = availableWindows[currentIndex];
    }
    
    function selectWindow(window): void {
        if (!visible) return;
        
        const index = availableWindows.findIndex(w => w === window);
        if (index >= 0) {
            currentIndex = index;
            selectedWindow = window;
            hide(); // Immediately switch and hide
        }
    }
    
    function onNext(): void {
        if (visible) {
            cycleNext();
        } else {
            show();
        }
    }
    
    function onPrev(): void {
        if (visible) {
            cyclePrevious();
        } else {
            show();
            cyclePrevious();
        }
    }
    
    function onEscapePressed(): void {
        if (visible) {
            // Cancel without switching - don't focus any window
            visible = false;
            
            // Clear the visibility in the drawer system to start animation
            const visibilities = Visibilities.getForActive();
            if (visibilities) {
                visibilities.windowswitcher = false;
            }
            
            // Delay clearing the window data until animation completes
            hideTimer.start();
        }
    }
    
    
    // Track window focus changes to maintain focus history
    Connections {
        target: Hyprland
        
        function onActiveToplevelChanged(): void {
            const activeWindow = Hyprland.activeToplevel;
            if (activeWindow && activeWindow.address) {
                // Remove from history if already exists
                const existingIndex = focusHistory.indexOf(activeWindow.address);
                if (existingIndex >= 0) {
                    focusHistory.splice(existingIndex, 1);
                }
                // Add to end (most recent)
                focusHistory.push(activeWindow.address);
                // Keep only last 200 windows
                if (focusHistory.length > 200) {
                    focusHistory.splice(0, focusHistory.length - 200);
                }
            }
        }
        
        function onRawEvent(data: string): void {
            // Clean up focus history when windows are closed
            if (data.includes("closewindow")) {
                // Extract window address from closewindow event: "closewindow>>ADDRESS"
                const match = data.match(/closewindow>>([^,\s]+)/);
                if (match) {
                    const closedAddress = parseInt(match[1], 16);
                    const index = focusHistory.indexOf(closedAddress);
                    if (index >= 0) {
                        focusHistory.splice(index, 1);
                    }
                }
            }
            
            // Refresh available windows if a window is opened/closed while switcher is visible
            if (visible && (data.includes("openwindow") || data.includes("closewindow"))) {
                const oldLength = availableWindows.length;
                const oldSelected = selectedWindow;
                
                // Refresh window list with focus history sorting
                let filteredWindows = Hyprland.toplevels.values.filter(window => {
                    return window.mapped !== false && 
                           !window.workspace?.name?.startsWith("special:") &&
                           window.title !== "" &&
                           window.title !== null &&
                           window.workspace?.id !== undefined;
                });
                
                availableWindows = filteredWindows.sort((a, b) => {
                    const aIndex = focusHistory.indexOf(a.address);
                    const bIndex = focusHistory.indexOf(b.address);
                    
                    if (aIndex >= 0 && bIndex >= 0) {
                        return bIndex - aIndex;
                    }
                    if (aIndex >= 0) return -1;
                    if (bIndex >= 0) return 1;
                    return 0;
                });
                
                // Adjust current index if window list changed
                if (availableWindows.length !== oldLength) {
                    if (oldSelected && availableWindows.includes(oldSelected)) {
                        currentIndex = availableWindows.findIndex(w => w === oldSelected);
                    } else {
                        currentIndex = Math.min(currentIndex, availableWindows.length - 1);
                    }
                    
                    if (availableWindows.length > 0) {
                        selectedWindow = availableWindows[currentIndex];
                    } else {
                        hide(); // No windows left
                    }
                }
            }
        }
    }
}