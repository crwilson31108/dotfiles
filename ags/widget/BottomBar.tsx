import { Variable, bind } from "astal"
import { Astal, Gtk, Gdk, App } from "astal/gtk3"
import { execAsync } from "astal/process"
import Hyprland from "gi://AstalHyprland"
import Tray from "gi://AstalTray"

function AppLauncher() {
    return <button
        className="app-launcher"
        onClicked={() => execAsync(["rofi", "-show", "drun"])}>
        <label label="≡" />
    </button>
}

function WindowTitle() {
    const hypr = Hyprland.get_default()
    const focused = bind(hypr, "focusedClient")

    return <label
        className="window-title"
        visible={focused.as(Boolean)}
        label={focused.as(client => client?.title || "Desktop")}
    />
}

function SysTray() {
    const tray = Tray.get_default()

    return <box className="systray">
        {bind(tray, "items").as(items => items
            .map(item => (
                <menubutton
                    className="tray-item"
                    tooltipMarkup={bind(item, "tooltipMarkup")}
                    usePopover={false}
                    actionGroup={bind(item, "actionGroup").as(ag => ["dbusmenu", ag])}
                    menuModel={bind(item, "menuModel")}>
                    <icon gicon={bind(item, "gicon")} />
                </menubutton>
            ))
        )}
    </box>
}

function Screenshot() {
    return <button
        className="screenshot"
        onClicked={() => execAsync(["bash", "-c", "grim -g \"$(slurp)\""])}>
        <icon icon="camera-photo-symbolic" />
    </button>
}

function UpdateChecker() {
    const updates = Variable<number>(0).poll(300000, ["bash", "-c", 
        "checkupdates 2>/dev/null | wc -l"])

    return <button
        className="updates"
        visible={bind(updates).as(n => n > 0)}
        onClicked={() => execAsync(["kitty", "-e", "yay", "-Syu"])}>
        <label label={bind(updates).as(n => n > 0 ? `${n}` : "")} />
    </button>
}

export default function BottomBar(monitor: Gdk.Monitor) {
    const { BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor

    return <window
        className="BottomBar"
        gdkmonitor={monitor}
        exclusivity={Astal.Exclusivity.EXCLUSIVE}
        anchor={BOTTOM | LEFT | RIGHT}>
        <centerbox className="bar-content">
            <box className="left" hexpand halign={Gtk.Align.START}>
                <AppLauncher />
            </box>
            <box className="center">
                <WindowTitle />
            </box>
            <box className="right" hexpand halign={Gtk.Align.END}>
                <SysTray />
                <Screenshot />
                <UpdateChecker />
            </box>
        </centerbox>
    </window>
}