import { Variable, bind } from "astal"
import { Astal, Gtk, Gdk, App } from "astal/gtk3"
import { execAsync } from "astal/process"
import Hyprland from "gi://AstalHyprland"
import Tray from "gi://AstalTray"

function AppLauncher() {
    return <button
        className="app-launcher"
        onClicked={() => execAsync(["rofi", "-show", "drun"])}
        tooltipText="Application Launcher">
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

function UtilityButtons() {
    const expanded = Variable(false)

    const toggleExpanded = () => {
        expanded.set(!expanded.get())
    }

    return <box className="utility-container">
        <revealer
            transitionType={Gtk.RevealerTransitionType.SLIDE_LEFT}
            revealChild={bind(expanded)}
            className="utility-revealer">
            <box className="utility-buttons">
                <button
                    className="utility-btn clipboard"
                    onClicked={() => execAsync(["bash", "-c", "cliphist list | rofi -dmenu | cliphist decode | wl-copy"])}
                    tooltipText="Clipboard History">
                    <icon icon="edit-paste-symbolic" />
                </button>
                <button
                    className="utility-btn emoji"
                    onClicked={() => execAsync(["rofimoji"])}
                    tooltipText="Emoji Picker">
                    <icon icon="face-smile-symbolic" />
                </button>
                <button
                    className="utility-btn colorpicker"
                    onClicked={() => execAsync(["hyprpicker", "-a"])}
                    tooltipText="Color Picker">
                    <icon icon="color-select-symbolic" />
                </button>
                <button
                    className="utility-btn screenshot"
                    onClicked={() => execAsync(["bash", "-c", "grim -g \"$(slurp)\""])}
                    tooltipText="Screenshot">
                    <icon icon="camera-photo-symbolic" />
                </button>
            </box>
        </revealer>
        <button
            className={bind(expanded).as(e => e ? "utility-toggle expanded" : "utility-toggle")}
            onClicked={toggleExpanded}
            tooltipText={bind(expanded).as(e => e ? "Hide Utilities" : "Show Utilities")}>
            <icon icon={bind(expanded).as(e => e ? "pan-end-symbolic" : "pan-start-symbolic")} />
        </button>
    </box>
}

function UpdateChecker() {
    const updates = Variable<number>(0).poll(300000, ["bash", "-c", 
        "count=$(($(checkupdates 2>/dev/null | wc -l) + $(yay -Qua 2>/dev/null | wc -l))); echo $count"])

    const runUpdate = async () => {
        try {
            await execAsync(["alacritty", "-e", "bash", "-c", "yay -Syu; echo 'Press any key to exit...'; read -n 1"])
            updates.startPoll()
        } catch (error) {
            console.log("Update process completed or cancelled")
            updates.startPoll()
        }
    }

    return <button
        className={bind(updates).as(n => n > 0 ? "updates has-updates" : "updates")}
        onClicked={runUpdate}
        tooltipText={bind(updates).as(n => n == 0 ? "System is up to date" : `${n} updates available`)}>
        <box>
            <icon icon={bind(updates).as(n => n == 0 ? "emblem-checked-symbolic" : "software-update-available-symbolic")} />
            {bind(updates).as(n => n > 0 ? <label label={` ${n}`} className="update-count" /> : null)}
        </box>
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
                <UtilityButtons />
                <SysTray />
                <UpdateChecker />
            </box>
        </centerbox>
    </window>
}