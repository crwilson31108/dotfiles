import { Variable, GLib, bind } from "astal"
import { Astal, Gtk, Gdk, App } from "astal/gtk3"
import Wp from "gi://AstalWp"
import Notifd from "gi://AstalNotifd"

// OSD State Management
const osdVisible = Variable(false)
const osdType = Variable<"volume" | "brightness" | "notification">("volume")
const osdValue = Variable(0)
const osdIcon = Variable("")
const osdTitle = Variable("")
const osdBody = Variable("")

// Auto-hide timer
let hideTimer: number | null = null

function showOSD(type: "volume" | "brightness" | "notification", value?: number, icon?: string, title?: string, body?: string) {
    osdType.set(type)
    if (value !== undefined) osdValue.set(value)
    if (icon) osdIcon.set(icon)
    if (title) osdTitle.set(title)
    if (body) osdBody.set(body)
    
    osdVisible.set(true)
    
    // Clear existing timer
    if (hideTimer) {
        GLib.source_remove(hideTimer)
    }
    
    // Auto-hide after 2 seconds
    hideTimer = GLib.timeout_add(GLib.PRIORITY_DEFAULT, 2000, () => {
        osdVisible.set(false)
        hideTimer = null
        return false
    })
}

// Volume OSD
function VolumeOSD() {
    const speaker = Wp.get_default()?.audio.defaultSpeaker

    // Listen for volume changes
    speaker?.connect("notify::volume", () => {
        const volume = Math.round((speaker.volume || 0) * 100)
        showOSD("volume", volume, speaker.volumeIcon)
    })

    return <box className="osd-volume" visible={bind(osdType).as(t => t === "volume")}>
        <box className="osd-content" vertical>
            <box className="osd-header">
                <icon 
                    className="osd-icon" 
                    icon={bind(osdIcon)} 
                    iconSize={48}
                />
                <label 
                    className="osd-label" 
                    label="Volume"
                />
            </box>
            <box className="osd-progress">
                <progressbar
                    className="osd-progressbar"
                    fraction={bind(osdValue).as(v => v / 100)}
                />
                <label 
                    className="osd-percentage" 
                    label={bind(osdValue).as(v => `${v}%`)}
                />
            </box>
        </box>
    </box>
}

// Brightness OSD  
function BrightnessOSD() {
    return <box className="osd-brightness" visible={bind(osdType).as(t => t === "brightness")}>
        <box className="osd-content" vertical>
            <box className="osd-header">
                <icon 
                    className="osd-icon" 
                    icon="display-brightness-symbolic"
                    iconSize={48}
                />
                <label 
                    className="osd-label" 
                    label="Brightness"
                />
            </box>
            <box className="osd-progress">
                <progressbar
                    className="osd-progressbar"
                    fraction={bind(osdValue).as(v => v / 100)}
                />
                <label 
                    className="osd-percentage" 
                    label={bind(osdValue).as(v => `${v}%`)}
                />
            </box>
        </box>
    </box>
}

// Notification OSD
function NotificationOSD() {
    const notifd = Notifd.get_default()
    
    // Listen for new notifications
    notifd.connect("notified", (_, id) => {
        const notification = notifd.get_notification(id)
        if (notification) {
            showOSD("notification", undefined, notification.appIcon || "dialog-information", 
                   notification.summary, notification.body)
        }
    })

    return <box className="osd-notification" visible={bind(osdType).as(t => t === "notification")}>
        <box className="osd-content" vertical>
            <box className="osd-header">
                <icon 
                    className="osd-icon" 
                    icon={bind(osdIcon)}
                    iconSize={48}
                />
                <box className="osd-text" vertical>
                    <label 
                        className="osd-title" 
                        label={bind(osdTitle)}
                        maxWidthChars={30}
                        ellipsize={3}
                    />
                    <label 
                        className="osd-body" 
                        label={bind(osdBody)}
                        maxWidthChars={40}
                        ellipsize={3}
                        wrap
                        visible={bind(osdBody).as(b => b.length > 0)}
                    />
                </box>
            </box>
        </box>
    </box>
}

export default function OSD(monitor: Gdk.Monitor) {
    const { CENTER } = Astal.WindowAnchor

    return <window
        className="OSD"
        gdkmonitor={monitor}
        exclusivity={Astal.Exclusivity.IGNORE}
        anchor={CENTER}
        visible={bind(osdVisible)}
        keymode={Astal.Keymode.NONE}
        layer={Astal.Layer.OVERLAY}>
        <box className="osd-container">
            <VolumeOSD />
            <BrightnessOSD />
            <NotificationOSD />
        </box>
    </window>
}

// Export functions for external brightness control
export function showBrightnessOSD(value: number) {
    showOSD("brightness", value)
}

export function showVolumeOSD() {
    const speaker = Wp.get_default()?.audio.defaultSpeaker
    if (speaker) {
        const volume = Math.round(speaker.volume * 100)
        showOSD("volume", volume, speaker.volumeIcon)
    }
}