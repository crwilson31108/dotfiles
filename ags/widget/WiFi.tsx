import { bind } from "astal"
import { Gtk } from "astal/gtk3"
import Network from "gi://AstalNetwork"

export default function WiFi() {
    const network = Network.get_default()
    const wifi = bind(network, "wifi")
    
    return <button className="wifi-button" tooltipText="WiFi">
        <icon icon="network-wireless-symbolic" />
    </button>
}