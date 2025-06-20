import { App, Astal, Gdk, Gtk } from "astal/gtk3"
import { timeout } from "astal/time"
import Variable from "astal/variable"
import Brightness from "./brightness"
import Wp from "gi://AstalWp"

function OnScreenProgress({ visible }: { visible: Variable<boolean> }) {
    const brightness = Brightness.get_default()
    const speaker = Wp.get_default()?.get_default_speaker()

    const iconName = Variable("")
    const value = Variable(0)
    
    // Track if this is the initial load to suppress OSD
    let brightnessInitialized = false
    let volumeInitialized = false

    let count = 0
    function show(v: number, icon: string) {
        visible.set(true)
        value.set(v)
        iconName.set(icon)
        count++
        timeout(2000, () => {
            count--
            if (count === 0) visible.set(false)
        })
    }

    return (
        <revealer
            setup={(self) => {
                self.hook(brightness, "notify::screen", () => {
                    if (brightnessInitialized) {
                        show(brightness.screen, "display-brightness-symbolic")
                    } else {
                        brightnessInitialized = true
                    }
                })

                if (speaker) {
                    self.hook(speaker, "notify::volume", () => {
                        if (volumeInitialized) {
                            show(speaker.volume, speaker.volumeIcon)
                        } else {
                            volumeInitialized = true
                        }
                    })
                }
            }}
            revealChild={visible()}
            transitionType={Gtk.RevealerTransitionType.SLIDE_UP}
        >
            <box className="OSD">
                <icon icon={iconName()} />
                <levelbar valign={Gtk.Align.CENTER} widthRequest={150} value={value()} />
                <label label={value(v => `${Math.round(v * 100)}%`)} />
            </box>
        </revealer>
    )
}

export default function OSD(monitor: Gdk.Monitor) {
    const visible = Variable(false)

    return (
        <window
            gdkmonitor={monitor}
            className="OSD"
            namespace="osd"
            application={App}
            layer={Astal.Layer.OVERLAY}
            keymode={Astal.Keymode.ON_DEMAND}
            anchor={0}
        >
            <eventbox onClick={() => visible.set(false)}>
                <OnScreenProgress visible={visible} />
            </eventbox>
        </window>
    )
}