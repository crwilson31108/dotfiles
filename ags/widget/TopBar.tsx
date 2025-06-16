import { Variable, GLib, bind } from "astal"
import { Astal, Gtk, Gdk, App } from "astal/gtk3"
import { exec, execAsync } from "astal/process"
import Hyprland from "gi://AstalHyprland"
import Wp from "gi://AstalWp"
import Battery from "gi://AstalBattery"
import Brightness from "../osd/brightness"
import Notifd from "gi://AstalNotifd"

function Workspaces() {
    const hypr = Hyprland.get_default()

    return <box className="workspaces">
        {Array.from({ length: 4 }, (_, i) => i + 1).map(i => {
            const ws = bind(hypr, "workspaces").as(wss => 
                wss.find(ws => ws.id === i)
            )
            
            return <button
                className={bind(hypr, "focusedWorkspace").as(fw =>
                    fw?.id === i ? "workspace-btn active" : "workspace-btn"
                )}
                onClicked={() => hypr.dispatch("workspace", `${i}`)}>
                <label label={`${i}`} />
            </button>
        })}
    </box>
}


function Clock() {
    const time = Variable<string>("").poll(1000, () =>
        GLib.DateTime.new_now_local().format("%Y-%m-%d  %I:%M %p")!)

    return <button 
        className="clock-box"
        onClicked={() => execAsync(["gnome-calendar"])}>
        <label
            className="clock"
            onDestroy={() => time.drop()}
            label={time()}
        />
    </button>
}

function AudioSlider() {
    const speaker = Wp.get_default()?.audio.defaultSpeaker!

    return <eventbox 
        className="audio"
        onScroll={(self, event) => {
            if (event.delta_y > 0) {
                // Scroll down = increase volume
                speaker.volume = Math.min(speaker.volume + 0.05, 1.0)
            } else if (event.delta_y < 0) {
                // Scroll up = decrease volume
                speaker.volume = Math.max(speaker.volume - 0.05, 0.0)
            }
        }}>
        <button onClicked={() => {
            speaker.mute = !speaker.mute
        }}>
            <box>
                <icon icon={bind(speaker, "volumeIcon")} />
                <label label={bind(speaker, "volume").as(v => 
                    `${Math.round(v * 100)}%`
                )} />
            </box>
        </button>
    </eventbox>
}

function BrightnessWidget() {
    const brightness = Brightness.get_default()
    const blueFilterActive = Variable(false)

    return <eventbox 
        className="brightness"
        onScroll={(self, event) => {
            if (event.delta_y > 0) {
                // Scroll down = increase brightness
                brightness.screen = Math.min(brightness.screen + 0.05, 1.0)
            } else if (event.delta_y < 0) {
                // Scroll up = decrease brightness
                brightness.screen = Math.max(brightness.screen - 0.05, 0.0)
            }
        }}>
        <button onClicked={() => {
            blueFilterActive.set(!blueFilterActive.get())
            if (blueFilterActive.get()) {
                execAsync(["bash", "-c", "hyprctl keyword decoration:screen_shader ~/.config/hypr/shaders/blue-light-filter.glsl"])
            } else {
                execAsync(["bash", "-c", "hyprctl keyword decoration:screen_shader ''"])
            }
        }}>
            <box>
                <icon icon={bind(blueFilterActive).as(active => 
                    active ? "night-light-symbolic" : "display-brightness-symbolic"
                )} />
                <label label={bind(brightness, "screen").as(b => 
                    `${Math.round(b * 100)}%`
                )} />
            </box>
        </button>
    </eventbox>
}

function BatteryWidget() {
    const battery = Battery.get_default()
    
    const getTimeRemaining = () => {
        if (!battery.isPresent) return ""
        
        if (battery.state === 1) { // Charging
            const hoursLeft = battery.timeToFull / 3600
            return `${Math.floor(hoursLeft)}h ${Math.floor((hoursLeft % 1) * 60)}m to full`
        } else if (battery.state === 2) { // Discharging
            const hoursLeft = battery.timeToEmpty / 3600
            return `${Math.floor(hoursLeft)}h ${Math.floor((hoursLeft % 1) * 60)}m remaining`
        }
        return "Fully charged"
    }

    return <button 
        className="battery" 
        visible={bind(battery, "isPresent")}
        onClicked={() => execAsync(["bash", "-c", "gnome-power-statistics || xfce4-power-manager-settings || mate-power-statistics || kde-power-settings"])}
        tooltipText={bind(battery, "state").as(() => getTimeRemaining())}>
        <box>
            <icon icon={bind(battery, "batteryIconName")} />
            <label label={bind(battery, "percentage").as(p =>
                `${Math.floor(p * 100)}%`
            )} />
        </box>
    </button>
}

function NotificationIndicator() {
    const notifyd = Notifd.get_default()
    const count = Variable(0)
    
    // Update count when notifications change
    const updateCount = () => {
        count.set(notifyd.get_notifications().length)
    }
    
    notifyd.connect("notified", updateCount)
    notifyd.connect("resolved", updateCount)
    updateCount()
    
    return <button
        className="notification-indicator"
        onClicked={() => {
            App.toggle_window("NotificationCenter")
        }}>
        <box>
            <icon icon="notification-symbolic" />
            <label 
                className="notif-count"
                visible={bind(count).as(c => c > 0)}
                label={bind(count).as(c => c.toString())} 
            />
        </box>
    </button>
}

function PowerMenu() {
    return <button
        className="power-button"
        onClicked={() => execAsync(["bash", "-c", "~/.config/waybar/scripts/power-menu.sh"])}>
        <label label="⏻" />
    </button>
}

export default function TopBar(monitor: Gdk.Monitor) {
    const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

    return <window
        className="TopBar"
        gdkmonitor={monitor}
        exclusivity={Astal.Exclusivity.EXCLUSIVE}
        anchor={TOP | LEFT | RIGHT}>
        <centerbox className="bar-content">
            <box className="left" halign={Gtk.Align.START}>
                <Workspaces />
            </box>
            <box className="center">
                <Clock />
            </box>
            <box className="right" spacing={8} hexpand halign={Gtk.Align.END}>
                <BrightnessWidget />
                <AudioSlider />
                <BatteryWidget />
                <NotificationIndicator />
                <PowerMenu />
            </box>
        </centerbox>
    </window>
}