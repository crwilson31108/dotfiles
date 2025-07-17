pragma Singleton

import "."
import Quickshell
import QtQuick

Singleton {
    id: root

    // Cache for window class to desktop entry mappings
    property var classToDesktopCache: ({})
    
    // Cache for window class to icon path mappings
    property var classToIconCache: ({})
    
    // Common icon aliases for apps that might use different names
    readonly property var iconAliases: ({
        "chromium": ["chromium", "chromium-browser", "google-chrome", "chrome"],
        "firefox": ["firefox", "firefox-esr", "firefox-developer-edition", "firefox-nightly"],
        "thunderbird": ["thunderbird", "mozilla-thunderbird", "thunderbird-daily"],
        "code": ["code", "vscode", "visual-studio-code", "code-oss", "vscodium"],
        "discord": ["discord", "Discord", "discord-canary", "discord-ptb"],
        "steam": ["steam", "steam-runtime", "steam-native"],
        "spotify": ["spotify", "spotify-client", "com.spotify.Client"],
        "slack": ["slack", "com.slack.Slack"],
        "telegram": ["telegram", "telegram-desktop", "org.telegram.desktop"],
        "signal": ["signal", "signal-desktop", "org.signal.Signal"],
        "brave": ["brave", "brave-browser", "com.brave.Browser"],
        "obsidian": ["obsidian", "md.obsidian.Obsidian"],
        "kitty": ["kitty", "kitty-terminal"],
        "alacritty": ["alacritty", "Alacritty", "alacritty-terminal"],
        "wezterm": ["wezterm", "org.wezfurlong.wezterm"],
        "foot": ["foot", "footclient", "foot-terminal"],
        "konsole": ["konsole", "org.kde.konsole"],
        "gnome-terminal": ["gnome-terminal", "org.gnome.Terminal"],
        "tilix": ["tilix", "com.gexperts.Tilix"],
        "terminator": ["terminator", "terminator-terminal"],
        "nautilus": ["nautilus", "org.gnome.Nautilus", "files"],
        "dolphin": ["dolphin", "org.kde.dolphin"],
        "thunar": ["thunar", "Thunar", "org.xfce.thunar"],
        "nemo": ["nemo", "nemo-files"],
        "pcmanfm": ["pcmanfm", "pcmanfm-qt"],
        "libreoffice": ["libreoffice", "libreoffice-writer", "libreoffice-calc", "libreoffice-impress"],
        "gimp": ["gimp", "gimp-2.10", "org.gimp.GIMP"],
        "inkscape": ["inkscape", "org.inkscape.Inkscape"],
        "blender": ["blender", "Blender", "org.blender.Blender"],
        "vlc": ["vlc", "vlc-media-player", "org.videolan.VLC"],
        "mpv": ["mpv", "io.mpv.Mpv"],
        "rhythmbox": ["rhythmbox", "org.gnome.Rhythmbox"],
        "clementine": ["clementine", "org.clementine_player.Clementine"],
        "evolution": ["evolution", "org.gnome.Evolution"],
        "geary": ["geary", "org.gnome.Geary"],
        "kmail": ["kmail", "org.kde.kmail2"],
        "emacs": ["emacs", "emacs-gtk", "org.gnu.emacs"],
        "vim": ["vim", "gvim", "vim-gtk3"],
        "neovim": ["neovim", "nvim", "nvim-qt", "neovide"],
        "sublime": ["sublime", "sublime-text", "sublime_text", "com.sublimetext.three"],
        "atom": ["atom", "atom-editor", "io.atom.Atom"],
        "brackets": ["brackets", "io.brackets.Brackets"],
        "android-studio": ["android-studio", "jetbrains-studio", "com.google.AndroidStudio"],
        "intellij": ["intellij", "intellij-idea", "jetbrains-idea", "com.jetbrains.intellij.ce.desktop"],
        "pycharm": ["pycharm", "jetbrains-pycharm", "com.jetbrains.pycharm-ce.desktop"],
        "webstorm": ["webstorm", "jetbrains-webstorm", "com.jetbrains.webstorm.desktop"],
        "clion": ["clion", "jetbrains-clion", "com.jetbrains.clion.desktop"],
        "datagrip": ["datagrip", "jetbrains-datagrip", "com.jetbrains.datagrip.desktop"],
        "phpstorm": ["phpstorm", "jetbrains-phpstorm", "com.jetbrains.phpstorm.desktop"],
        "goland": ["goland", "jetbrains-goland", "com.jetbrains.goland.desktop"],
        "rider": ["rider", "jetbrains-rider", "com.jetbrains.rider.desktop"],
        "rubymine": ["rubymine", "jetbrains-rubymine", "com.jetbrains.rubymine.desktop"],
        "kdenlive": ["kdenlive", "org.kde.kdenlive"],
        "openshot": ["openshot", "openshot-qt", "org.openshot.OpenShot"],
        "shotcut": ["shotcut", "org.shotcut.Shotcut"],
        "obs": ["obs", "obs-studio", "com.obsproject.Studio"],
        "audacity": ["audacity", "org.audacityteam.Audacity"],
        "ardour": ["ardour", "ardour6", "ardour7", "org.ardour.Ardour"],
        "krita": ["krita", "org.kde.krita"],
        "darktable": ["darktable", "org.darktable.darktable"],
        "rawtherapee": ["rawtherapee", "com.rawtherapee.RawTherapee"],
        "digikam": ["digikam", "org.kde.digikam"],
        "transmission": ["transmission", "transmission-gtk", "transmission-qt", "com.transmissionbt.Transmission"],
        "qbittorrent": ["qbittorrent", "org.qbittorrent.qBittorrent"],
        "deluge": ["deluge", "deluge-gtk", "org.deluge_torrent.deluge"],
        "filelight": ["filelight", "org.kde.filelight"],
        "baobab": ["baobab", "org.gnome.baobab"],
        "gparted": ["gparted", "gparted-pkexec"],
        "virtualbox": ["virtualbox", "VirtualBox", "org.virtualbox.VirtualBox"],
        "vmware": ["vmware", "vmware-workstation", "vmware-player"],
        "virt-manager": ["virt-manager", "virt-manager-gui"],
        "remmina": ["remmina", "org.remmina.Remmina"],
        "anydesk": ["anydesk", "com.anydesk.Anydesk"],
        "teamviewer": ["teamviewer", "com.teamviewer.TeamViewer"],
        "zoom": ["zoom", "zoom-client", "us.zoom.Zoom"],
        "skype": ["skype", "skypeforlinux", "com.skype.Client"],
        "teams": ["teams", "teams-for-linux", "com.microsoft.Teams"],
        "element": ["element", "element-desktop", "im.riot.Riot"],
        "hexchat": ["hexchat", "io.github.Hexchat"],
        "pidgin": ["pidgin", "im.pidgin.Pidgin"],
        "kopete": ["kopete", "org.kde.kopete"],
        "calibre": ["calibre", "calibre-gui", "com.calibre_ebook.calibre"],
        "zotero": ["zotero", "org.zotero.Zotero"],
        "mendeley": ["mendeley", "mendeleydesktop", "com.elsevier.MendeleyDesktop"],
        "okular": ["okular", "org.kde.okular"],
        "evince": ["evince", "org.gnome.Evince"],
        "zathura": ["zathura", "org.pwmt.zathura"],
        "mupdf": ["mupdf", "com.artifex.mupdf"],
        "xreader": ["xreader", "xreader-viewer"],
        "foliate": ["foliate", "com.github.johnfactotum.Foliate"],
        "gnome-calculator": ["gnome-calculator", "org.gnome.Calculator", "calculator"],
        "kcalc": ["kcalc", "org.kde.kcalc"],
        "galculator": ["galculator", "galculator-gtk3"],
        "speedcrunch": ["speedcrunch", "org.speedcrunch.SpeedCrunch"],
        "gnome-system-monitor": ["gnome-system-monitor", "org.gnome.SystemMonitor"],
        "ksysguard": ["ksysguard", "org.kde.ksysguard"],
        "htop": ["htop", "htop-terminal"],
        "btop": ["btop", "btop++"],
        "synaptic": ["synaptic", "synaptic-pkexec"],
        "gnome-software": ["gnome-software", "org.gnome.Software"],
        "discover": ["discover", "org.kde.discover"],
        "pamac": ["pamac", "pamac-manager"],
        "lutris": ["lutris", "net.lutris.Lutris"],
        "heroic": ["heroic", "com.heroicgameslauncher.hgl"],
        "bottles": ["bottles", "com.usebottles.bottles"],
        "playonlinux": ["playonlinux", "PlayOnLinux"],
        "minecraft": ["minecraft", "minecraft-launcher", "com.mojang.Minecraft"],
        "prismlauncher": ["prismlauncher", "org.prismlauncher.PrismLauncher"],
        "multimc": ["multimc", "org.multimc.MultiMC"],
        "retroarch": ["retroarch", "org.libretro.RetroArch"],
        "dolphin-emu": ["dolphin-emu", "org.DolphinEmu.dolphin-emu"],
        "pcsx2": ["pcsx2", "net.pcsx2.PCSX2"],
        "ppsspp": ["ppsspp", "org.ppsspp.PPSSPP"],
        "duckstation": ["duckstation", "org.duckstation.DuckStation"],
        "citra": ["citra", "org.citra_emu.citra"],
        "yuzu": ["yuzu", "org.yuzu_emu.yuzu"],
        "ryujinx": ["ryujinx", "org.ryujinx.Ryujinx"],
        "godot": ["godot", "org.godotengine.Godot"],
        "unity": ["unity", "unity-editor", "com.unity.UnityHub"],
        "unreal": ["unreal", "unreal-engine", "com.unrealengine.UE4Editor"],
        "android-messages": ["android-messages", "android-messages-desktop"],
        "whatsapp": ["whatsapp", "whatsapp-desktop", "whatsapp-for-linux"],
        "caprine": ["caprine", "com.sindresorhus.Caprine"],
        "ferdi": ["ferdi", "com.getferdi.Ferdi"],
        "rambox": ["rambox", "com.rambox.Rambox"],
        "station": ["station", "com.getstation.Station"],
        "wavebox": ["wavebox", "com.wavebox.Wavebox"],
        "mailspring": ["mailspring", "com.getmailspring.Mailspring"],
        "birdtray": ["birdtray", "com.ulduzsoft.Birdtray"],
        "betterbird": ["betterbird", "eu.betterbird.Betterbird"]
    })
    
    // Initialize the mapper with desktop entries
    Component.onCompleted: {
        buildInitialCache();
    }
    
    // Rebuild cache when apps change
    Connections {
        target: Apps
        function onDesktopAppsChanged() {
            buildInitialCache();
        }
    }
    
    function buildInitialCache() {
        const newClassCache = {};
        const newIconCache = {};
        
        // Build cache from desktop entries
        for (const app of Apps.desktopApps) {
            if (!app) continue;
            
            // Extract possible window classes from the desktop entry
            const possibleClasses = [];
            
            // Add the desktop ID without .desktop extension
            if (app.desktopId) {
                const cleanId = app.desktopId.replace(/\.desktop$/, '');
                possibleClasses.push(cleanId);
                possibleClasses.push(cleanId.toLowerCase());
                
                // Handle reverse domain notation (e.g., org.mozilla.firefox -> firefox)
                const parts = cleanId.split('.');
                if (parts.length > 1) {
                    possibleClasses.push(parts[parts.length - 1]);
                    possibleClasses.push(parts[parts.length - 1].toLowerCase());
                }
            }
            
            // Add the executable name
            if (app.execString) {
                const execParts = app.execString.split(/\s+/);
                if (execParts.length > 0) {
                    const execName = execParts[0].split('/').pop();
                    possibleClasses.push(execName);
                    possibleClasses.push(execName.toLowerCase());
                }
            }
            
            // Add the app name as a fallback
            if (app.name) {
                const cleanName = app.name.toLowerCase()
                    .replace(/\s+/g, '-')
                    .replace(/[^a-z0-9\-]/g, '');
                possibleClasses.push(cleanName);
            }
            
            // Store the mapping for all possible classes
            for (const className of possibleClasses) {
                if (className && !newClassCache[className]) {
                    newClassCache[className] = app;
                }
            }
        }
        
        classToDesktopCache = newClassCache;
        classToIconCache = newIconCache;
    }
    
    function getIconForWindow(window) {
        if (!window) return "application-x-executable";
        
        // Get the window class - try multiple possible properties
        const windowClass = window.handle?.appid ||
                          window.appid ||
                          window.appId ||
                          window.lastIpcObject?.class || 
                          window.lastIpcObject?.initialClass || 
                          window.class || 
                          window.initialClass || 
                          "";
        
        if (!windowClass) {
            return "application-x-executable";
        }
        
        // Check icon cache first
        if (classToIconCache[windowClass]) {
            return classToIconCache[windowClass];
        }
        
        // Try to find the desktop entry
        let desktopEntry = findDesktopEntry(windowClass);
        
        if (desktopEntry && desktopEntry.icon) {
            // Cache the result
            classToIconCache[windowClass] = desktopEntry.icon;
            return desktopEntry.icon;
        }
        
        // Try icon aliases
        const iconName = tryIconAliases(windowClass);
        if (iconName) {
            classToIconCache[windowClass] = iconName;
            return iconName;
        }
        
        // Fallback to window class as icon name
        classToIconCache[windowClass] = windowClass.toLowerCase();
        return windowClass.toLowerCase();
    }
    
    function findDesktopEntry(windowClass) {
        if (!windowClass) return null;
        
        // Direct cache lookup
        if (classToDesktopCache[windowClass]) {
            return classToDesktopCache[windowClass];
        }
        
        // Try lowercase
        const lowerClass = windowClass.toLowerCase();
        if (classToDesktopCache[lowerClass]) {
            return classToDesktopCache[lowerClass];
        }
        
        // Try to find by partial match
        for (const [className, entry] of Object.entries(classToDesktopCache)) {
            if (className.includes(lowerClass) || lowerClass.includes(className)) {
                return entry;
            }
        }
        
        // Try fuzzy search as last resort
        const results = Apps.fuzzyQuery(windowClass);
        if (results.length > 0) {
            // Cache this result for future lookups
            classToDesktopCache[windowClass] = results[0];
            return results[0];
        }
        
        return null;
    }
    
    function tryIconAliases(windowClass) {
        const lowerClass = windowClass.toLowerCase();
        
        // Check if this class matches any alias group
        for (const [mainIcon, aliases] of Object.entries(iconAliases)) {
            for (const alias of aliases) {
                if (alias.toLowerCase() === lowerClass || 
                    lowerClass.includes(alias.toLowerCase()) ||
                    alias.toLowerCase().includes(lowerClass)) {
                    // Try each icon variant until we find one that exists
                    for (const iconVariant of aliases) {
                        const iconPath = Quickshell.iconPath(iconVariant);
                        if (iconPath && !iconPath.includes("image-missing")) {
                            return iconVariant;
                        }
                    }
                    // If no variant worked, return the main icon name
                    return mainIcon;
                }
            }
        }
        
        return null;
    }
    
    function getWindowTitle(window) {
        if (!window) return "Unknown";
        
        // Use the window title, but clean it up a bit
        let title = window.title || "Untitled";
        
        // Remove common suffixes that make titles too long
        title = title
            .replace(/ - Mozilla Firefox$/, "")
            .replace(/ - Chromium$/, "")
            .replace(/ - Google Chrome$/, "")
            .replace(/ - Visual Studio Code$/, "")
            .replace(/ - Discord$/, "")
            .replace(/ - Slack$/, "")
            .replace(/ - Mozilla Thunderbird$/, "")
            .replace(/ — Mozilla Firefox$/, "")
            .replace(/ — Chromium$/, "")
            .replace(/ — Google Chrome$/, "");
        
        // Limit length
        if (title.length > 40) {
            title = title.substring(0, 37) + "...";
        }
        
        return title;
    }
}