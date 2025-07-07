import "./../../widgets"
import "./../../services"
import "./../../config"
import "./../../utils"
import Quickshell
import Quickshell.Widgets
import QtQuick

Item {
    id: card

    required property var window
    required property bool selected
    property bool compact: false
    
    signal clicked()

    readonly property int cardWidth: compact ? 120 : 160
    readonly property int cardHeight: compact ? 80 : 100
    readonly property int iconSize: compact ? 32 : 48

    implicitWidth: cardWidth
    implicitHeight: cardHeight

    // Background
    StyledRect {
        id: cardBackground
        
        anchors.fill: parent
        radius: Appearance.rounding.normal
        
        color: card.selected ? 
            Colours.palette.m3primaryContainer : 
            Colours.palette.m3surfaceContainerHighest
        
        border.color: card.selected ? 
            Colours.palette.m3primary : 
            Colours.palette.m3outline
        border.width: card.selected ? 2 : 1

        Behavior on color {
            ColorAnimation {
                duration: Appearance.anim.durations.fast
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.anim.curves.standard
            }
        }

        Behavior on border.color {
            ColorAnimation {
                duration: Appearance.anim.durations.fast
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.anim.curves.standard
            }
        }
    }

    // Content
    Column {
        anchors.centerIn: parent
        spacing: Appearance.spacing.small

        // App icon
        IconImage {
            anchors.horizontalCenter: parent.horizontalCenter
            
            source: {
                // Get app class from window properties or title fallback
                let appClass = card.window.windowClass || 
                              card.window.appId || 
                              card.window.class || 
                              card.window.initialClass || 
                              "";
                
                // Fallback: guess from title if no class found
                if (!appClass && card.window.title) {
                    const title = card.window.title.toLowerCase();
                    if (title.includes("chromium")) {
                        appClass = "chromium";
                    } else if (title.includes("firefox")) {
                        appClass = "firefox";
                    } else if (title.includes("✳") || title.includes("alacritty") || title.includes("@cachyos")) {
                        appClass = "Alacritty";
                    } else if (title.includes("code")) {
                        appClass = "code";
                    } else if (title.includes("discord")) {
                        appClass = "discord";
                    }
                }
                
                if (!appClass) {
                    return Quickshell.iconPath("application-x-executable", "preferences-system");
                }
                
                // Generate icon name variants for better matching
                function getIconVariants(id) {
                    const normalized = id.toLowerCase()
                        .replace(/\s+/g, '-')
                        .replace(/[^a-z0-9\-_.]/g, '')
                        .replace(/^org\./, '')
                        .replace(/^com\./, '')
                        .replace(/^io\./, '')
                        .replace(/^net\./, '');
                    
                    const spacesToHyphens = id.replace(/\s+/g, '-').toLowerCase();
                    const spacesRemoved = id.replace(/\s+/g, '').toLowerCase();
                    
                    return [
                        id, id.toLowerCase(), normalized,
                        spacesToHyphens, spacesRemoved,
                        `org.${normalized}`, `com.${normalized}`,
                        `org.gnome.${normalized}`, `org.kde.${normalized}`,
                        `org.mozilla.${normalized}`, `com.github.${normalized}`,
                        normalized.replace(/-browser$/, ''),
                        normalized.replace(/-desktop$/, ''),
                        normalized.replace(/-app$/, '')
                    ].filter((v, i, arr) => arr.indexOf(v) === i);
                }
                
                const variants = getIconVariants(appClass);
                
                // Find best matching app using enhanced logic
                const matchingApps = Apps.fuzzyQuery(appClass);
                if (matchingApps.length === 0) {
                    return Quickshell.iconPath("application-x-executable", "preferences-system");
                }
                
                // Priority 1: Exact desktop ID matches
                for (const variant of variants) {
                    const exactMatch = matchingApps.find(app => {
                        const desktopId = app.desktopId?.toLowerCase().replace(/\.desktop$/, '') || "";
                        return desktopId === variant.toLowerCase();
                    });
                    if (exactMatch) {
                        return Quickshell.iconPath(exactMatch.icon || "application-x-executable", "preferences-system");
                    }
                }
                
                // Priority 2: StartsWith matches (for versioned apps)
                for (const variant of variants) {
                    if (variant.length < 3) continue;
                    const startsMatch = matchingApps.find(app => {
                        const desktopId = app.desktopId?.toLowerCase().replace(/\.desktop$/, '') || "";
                        return desktopId.startsWith(variant.toLowerCase()) && 
                               desktopId.length - variant.length <= 3;
                    });
                    if (startsMatch) {
                        return Quickshell.iconPath(startsMatch.icon || "application-x-executable", "preferences-system");
                    }
                }
                
                // Priority 3: EndsWith matches (for reverse domain notation)
                for (const variant of variants) {
                    if (variant.length < 4) continue;
                    const endsMatch = matchingApps.find(app => {
                        const desktopId = app.desktopId?.toLowerCase().replace(/\.desktop$/, '') || "";
                        return desktopId.endsWith(variant.toLowerCase()) || 
                               desktopId.endsWith(`.${variant.toLowerCase()}`);
                    });
                    if (endsMatch) {
                        return Quickshell.iconPath(endsMatch.icon || "application-x-executable", "preferences-system");
                    }
                }
                
                // Priority 4: Name contains matches
                for (const variant of variants) {
                    if (variant.length < 4) continue;
                    const nameMatch = matchingApps.find(app => {
                        const name = app.name?.toLowerCase() || "";
                        return name.includes(variant.toLowerCase()) && 
                               !name.includes("settings") && 
                               !name.includes("manager");
                    });
                    if (nameMatch) {
                        return Quickshell.iconPath(nameMatch.icon || "application-x-executable", "preferences-system");
                    }
                }
                
                // Fallback to first result
                const fallback = matchingApps[0];
                return Quickshell.iconPath(fallback.icon || "application-x-executable", "preferences-system");
            }
            
            implicitSize: card.iconSize
        }

        // Window title
        StyledText {
            anchors.horizontalCenter: parent.horizontalCenter
            
            text: card.window.title || "Untitled"
            font.pointSize: card.compact ? Appearance.font.size.small : Appearance.font.size.normal
            font.weight: card.selected ? Font.DemiBold : Font.Normal
            
            color: card.selected ? 
                Colours.palette.m3onPrimaryContainer : 
                Colours.palette.m3onSurface
            
            elide: Text.ElideRight
            width: Math.min(implicitWidth, card.cardWidth - Appearance.padding.normal * 2)
            
            Behavior on color {
                ColorAnimation {
                    duration: Appearance.anim.durations.fast
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Appearance.anim.curves.standard
                }
            }
        }

        // Workspace indicator (small text)
        StyledText {
            anchors.horizontalCenter: parent.horizontalCenter
            visible: !card.compact
            
            text: card.window.workspace?.name || ""
            font.pointSize: Appearance.font.size.smaller
            
            color: card.selected ? 
                Colours.palette.m3onPrimaryContainer : 
                Colours.palette.m3onSurfaceVariant
            
            opacity: 0.7
        }
    }

    // Click area
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        
        onClicked: card.clicked()
        
        // Hover effect
        hoverEnabled: true
        onEntered: {
            if (!card.selected) {
                cardBackground.color = Colours.palette.m3surfaceContainerHigh;
            }
        }
        onExited: {
            if (!card.selected) {
                cardBackground.color = Colours.palette.m3surfaceContainerHighest;
            }
        }
    }

    // Scale animation when selected
    transform: Scale {
        origin.x: card.width / 2
        origin.y: card.height / 2
        xScale: card.selected ? 1.05 : 1.0
        yScale: card.selected ? 1.05 : 1.0
        
        Behavior on xScale {
            NumberAnimation {
                duration: Appearance.anim.durations.fast
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.anim.curves.standard
            }
        }
        
        Behavior on yScale {
            NumberAnimation {
                duration: Appearance.anim.durations.fast
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.anim.curves.standard
            }
        }
    }
}