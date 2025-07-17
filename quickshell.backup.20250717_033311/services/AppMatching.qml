pragma Singleton

import "./../config"
import "." as Services
import Quickshell
import QtQuick

Singleton {
    id: root

    // Get app icon from window properties
    function getWindowIcon(window) {
        // Get app class from window properties
        // For Quickshell.Wayland toplevels, check wayland.appId
        let appClass = window.wayland?.appId ||
                      window.appId ||
                      window.lastIpcObject?.class ||
                      window.lastIpcObject?.initialClass ||
                      window.handle?.appid || 
                      window.appclass || 
                      window.appClass ||
                      window.windowClass ||
                      window.class || 
                      window.initialClass ||
                      "";
        
        // Fallback: guess from title if no class found
        if (!appClass && window.title) {
            const title = window.title.toLowerCase();
            if (title.includes("chromium")) {
                appClass = "chromium";
            } else if (title.includes("firefox")) {
                appClass = "firefox";
            } else if (title.includes("✳") || title.includes("alacritty") || title.includes("@cachyos")) {
                appClass = "Alacritty";
            } else if (title.includes("kitty")) {
                appClass = "kitty";
            } else if (title.includes("code")) {
                appClass = "code";
            } else if (title.includes("discord")) {
                appClass = "discord";
            } else if (title.includes("steam")) {
                appClass = "steam";
            } else if (title.includes("spotify")) {
                appClass = "spotify";
            }
        }
        
        if (!appClass) {
            return "application-x-executable";
        }
        
        return getAppIcon(appClass, window);
    }

    // Get app name from window properties  
    function getWindowAppName(window) {
        let appClass = window.wayland?.appId ||
                      window.appId ||
                      window.lastIpcObject?.class ||
                      window.lastIpcObject?.initialClass ||
                      window.handle?.appid || 
                      window.appclass || 
                      window.appClass ||
                      window.windowClass ||
                      window.class || 
                      window.initialClass ||
                      "";

        if (!appClass && window.title) {
            const title = window.title.toLowerCase();
            if (title.includes("chromium")) return "Chromium";
            if (title.includes("firefox")) return "Firefox";
            if (title.includes("alacritty") || title.includes("@cachyos")) return "Alacritty";
            if (title.includes("kitty")) return "Kitty";
            if (title.includes("code")) return "Visual Studio Code";
            if (title.includes("discord")) return "Discord";
            if (title.includes("steam")) return "Steam";
            if (title.includes("spotify")) return "Spotify";
        }

        if (!appClass) {
            return window.title || "Unknown";
        }

        // Try to get proper app name from desktop entries
        const matchingApps = Services.Apps.fuzzyQuery(appClass);
        if (matchingApps.length > 0) {
            const app = findBestMatch(appClass, matchingApps, window.title);
            if (app) {
                return app.name || appClass;
            }
        }

        // Format fallback name
        return appClass.charAt(0).toUpperCase() + appClass.slice(1);
    }

    // Get app icon from app class/id
    function getAppIcon(appClass, window = null) {
        if (!appClass) {
            return "application-x-executable";
        }
        
        // Generate icon name variants for better matching
        const variants = getIconVariants(appClass);
        
        // Find best matching app using enhanced logic
        let matchingApps = Services.Apps.fuzzyQuery(appClass);
        
        // If no matches with app class, try searching with window title keywords
        if (matchingApps.length === 0 && window && window.title) {
            const titleWords = window.title.toLowerCase().split(/[\s\-_\.]/).filter(w => w.length > 3);
            for (const word of titleWords) {
                matchingApps = Services.Apps.fuzzyQuery(word);
                if (matchingApps.length > 0) {
                    break;
                }
            }
        }
        
        if (matchingApps.length === 0) {
            return "application-x-executable";
        }

        const bestMatch = findBestMatch(appClass, matchingApps, window ? window.title : "");
        if (bestMatch && bestMatch.icon) {
            return bestMatch.icon;
        }

        return "application-x-executable";
    }

    // Find best matching app from list (now considers both class and title)
    function findBestMatch(appClass, matchingApps, windowTitle = "") {
        const variants = getIconVariants(appClass);
        
        // Priority 1: Exact desktop ID matches
        for (const variant of variants) {
            const exactMatch = matchingApps.find(app => {
                const desktopId = app.desktopId?.toLowerCase().replace(/\.desktop$/, '') || "";
                return desktopId === variant.toLowerCase();
            });
            if (exactMatch) return exactMatch;
        }
        
        // Priority 2: App name matches window title
        if (windowTitle) {
            const titleLower = windowTitle.toLowerCase();
            const titleMatch = matchingApps.find(app => {
                const name = app.name?.toLowerCase() || "";
                return name && titleLower.includes(name) && name.length > 3;
            });
            if (titleMatch) return titleMatch;
        }
        
        // Priority 3: StartsWith matches (for versioned apps)
        for (const variant of variants) {
            if (variant.length < 3) continue;
            const startsMatch = matchingApps.find(app => {
                const desktopId = app.desktopId?.toLowerCase().replace(/\.desktop$/, '') || "";
                return desktopId.startsWith(variant.toLowerCase()) && 
                       desktopId.length - variant.length <= 3;
            });
            if (startsMatch) return startsMatch;
        }
        
        // Priority 4: EndsWith matches (for reverse domain notation)
        for (const variant of variants) {
            if (variant.length < 4) continue;
            const endsMatch = matchingApps.find(app => {
                const desktopId = app.desktopId?.toLowerCase().replace(/\.desktop$/, '') || "";
                return desktopId.endsWith(variant.toLowerCase()) || 
                       desktopId.endsWith(`.${variant.toLowerCase()}`);
            });
            if (endsMatch) return endsMatch;
        }
        
        // Priority 5: Name contains matches
        for (const variant of variants) {
            if (variant.length < 4) continue;
            const nameMatch = matchingApps.find(app => {
                const name = app.name?.toLowerCase() || "";
                return name.includes(variant.toLowerCase()) && 
                       !name.includes("settings") && 
                       !name.includes("manager");
            });
            if (nameMatch) return nameMatch;
        }
        
        // Fallback to first result
        return matchingApps[0];
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
}