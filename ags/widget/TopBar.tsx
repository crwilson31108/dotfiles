import { Variable, GLib, bind } from "astal"
import { Astal, Gtk, Gdk, App } from "astal/gtk3"
import { execAsync } from "astal/process"
import Hyprland from "gi://AstalHyprland"
import Wp from "gi://AstalWp"
import Battery from "gi://AstalBattery"

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

    return <box className="clock-box">
        <label
            className="clock"
            onDestroy={() => time.drop()}
            label={time()}
        />
    </box>
}

function AudioSlider() {
    const speaker = Wp.get_default()?.audio.defaultSpeaker!

    return <box className="audio">
        <icon icon={bind(speaker, "volumeIcon")} />
        <label label={bind(speaker, "volume").as(v => 
            `${Math.round(v * 100)}%`
        )} />
    </box>
}

function Brightness() {
    return <box className="brightness">
        <icon icon="display-brightness-symbolic" />
        <label label="100%" />
    </box>
}

function BatteryWidget() {
    const battery = Battery.get_default()

    return <box className="battery" visible={bind(battery, "isPresent")}>
        <icon icon={bind(battery, "batteryIconName")} />
        <label label={bind(battery, "percentage").as(p =>
            `${Math.floor(p * 100)}%`
        )} />
    </box>
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
                <Brightness />
                <AudioSlider />
                <BatteryWidget />
                <PowerMenu />
            </box>
        </centerbox>
    </window>
}