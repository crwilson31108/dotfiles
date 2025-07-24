pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property real scaleFactor: _scaleFactor
    readonly property real baseDPI: 96.0
    readonly property real actualDPI: _actualDPI

    property real _scaleFactor: 1.0
    property real _actualDPI: 96.0

    Component.onCompleted: {
        detectScaling()
    }

    function detectScaling() {
        // Try to get Hyprland monitor info first
        const hyprProcess = new Process({
            command: ["hyprctl", "monitors", "-j"],
            stdout: output => {
                try {
                    const monitors = JSON.parse(output);
                    if (monitors.length > 0) {
                        const monitor = monitors[0]; // Use first monitor
                        _scaleFactor = monitor.scale || 1.0;
                        
                        // Calculate actual DPI from physical size
                        if (monitor.width && monitor.height && monitor.physicalWidth && monitor.physicalHeight) {
                            const widthInches = monitor.physicalWidth / 25.4; // mm to inches
                            const heightInches = monitor.physicalHeight / 25.4;
                            const diagonalPixels = Math.sqrt(monitor.width * monitor.width + monitor.height * monitor.height);
                            const diagonalInches = Math.sqrt(widthInches * widthInches + heightInches * heightInches);
                            _actualDPI = diagonalPixels / diagonalInches;
                        }
                        
                        return;
                    }
                } catch (e) {
                }
                
                // Fallback to environment variables
                fallbackDetection();
            },
            stderr: () => fallbackDetection()
        });
        
        hyprProcess.start();
    }

    function fallbackDetection() {
        // Check Qt/environment scaling
        const qtScale = parseFloat(Quickshell.env("QT_SCALE_FACTOR") || "1.0");
        const gdkScale = parseFloat(Quickshell.env("GDK_SCALE") || "1.0");
        
        _scaleFactor = Math.max(qtScale, gdkScale);
        
    }

    // Helper functions for scaled values
    function scale(baseValue) {
        // Apply inverse scaling since Qt already handles the base scaling
        // We want to make things smaller on high-DPI displays
        return Math.round(baseValue / _scaleFactor);
    }

    function scaleFont(baseSize) {
        // Font scaling might need different logic
        return Math.max(6, Math.round(baseSize / _scaleFactor));
    }
}