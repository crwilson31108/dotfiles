import { Variable, GLib, bind } from "astal"
import { Astal, Gtk, Gdk } from "astal/gtk3"
import Mpris from "gi://AstalMpris"

// Media OSD State
const mediaVisible = Variable(false)
const currentPlayer = Variable<any>(null)

// Auto-hide timer
let mediaHideTimer: number | null = null

function showMediaOSD() {
    const mpris = Mpris.get_default()
    const players = mpris.get_players()
    
    if (players.length > 0) {
        const player = players[0] // Use first available player
        currentPlayer.set(player)
        mediaVisible.set(true)
        
        // Clear existing timer
        if (mediaHideTimer) {
            GLib.source_remove(mediaHideTimer)
        }
        
        // Auto-hide after 4 seconds
        mediaHideTimer = GLib.timeout_add(GLib.PRIORITY_DEFAULT, 4000, () => {
            mediaVisible.set(false)
            mediaHideTimer = null
            return false
        })
    }
}

function MediaControls() {
    const player = bind(currentPlayer)
    
    return <box className="media-controls">
        <button 
            className="media-btn"
            onClicked={() => currentPlayer.get()?.previous()}
            sensitive={player.as(p => p?.canGoPrevious || false)}>
            <icon icon="media-skip-backward-symbolic" iconSize={24} />
        </button>
        
        <button 
            className="media-btn play-pause"
            onClicked={() => currentPlayer.get()?.playPause()}>
            <icon 
                icon={player.as(p => 
                    p?.playbackStatus === "Playing" ? "media-playback-pause-symbolic" : "media-playback-start-symbolic"
                )}
                iconSize={32}
            />
        </button>
        
        <button 
            className="media-btn"
            onClicked={() => currentPlayer.get()?.next()}
            sensitive={player.as(p => p?.canGoNext || false)}>
            <icon icon="media-skip-forward-symbolic" iconSize={24} />
        </button>
    </box>
}

function MediaInfo() {
    const player = bind(currentPlayer)
    
    return <box className="media-info" vertical>
        <label 
            className="media-title"
            label={player.as(p => p?.title || "Unknown Title")}
            maxWidthChars={30}
            ellipsize={3}
        />
        <label 
            className="media-artist"
            label={player.as(p => p?.artist || "Unknown Artist")}
            maxWidthChars={25}
            ellipsize={3}
        />
        <label 
            className="media-album"
            label={player.as(p => p?.album || "")}
            maxWidthChars={25}
            ellipsize={3}
            visible={player.as(p => (p?.album || "").length > 0)}
        />
    </box>
}

function MediaProgress() {
    const player = bind(currentPlayer)
    
    return <box className="media-progress" visible={player.as(p => p?.length > 0)}>
        <label 
            className="media-time"
            label={player.as(p => {
                if (!p?.position) return "0:00"
                const pos = Math.floor(p.position)
                const mins = Math.floor(pos / 60)
                const secs = pos % 60
                return `${mins}:${secs.toString().padStart(2, '0')}`
            })}
        />
        <scale
            className="media-scale"
            hexpand
            drawValue={false}
            min={0}
            max={player.as(p => p?.length || 1)}
            value={player.as(p => p?.position || 0)}
            onChangeValue={(self, value) => {
                const p = currentPlayer.get()
                if (p) p.position = value
            }}
        />
        <label 
            className="media-time"
            label={player.as(p => {
                if (!p?.length) return "0:00"
                const len = Math.floor(p.length)
                const mins = Math.floor(len / 60)
                const secs = len % 60
                return `${mins}:${secs.toString().padStart(2, '0')}`
            })}
        />
    </box>
}

export default function MediaOSD(monitor: Gdk.Monitor) {
    const { CENTER } = Astal.WindowAnchor
    
    // Listen for media key events
    const mpris = Mpris.get_default()
    mpris.connect("player-added", () => showMediaOSD())
    mpris.connect("player-closed", () => {
        const players = mpris.get_players()
        if (players.length === 0) {
            mediaVisible.set(false)
        }
    })

    return <window
        className="MediaOSD"
        gdkmonitor={monitor}
        exclusivity={Astal.Exclusivity.IGNORE}
        anchor={CENTER}
        visible={bind(mediaVisible)}
        keymode={Astal.Keymode.NONE}
        layer={Astal.Layer.OVERLAY}>
        <box className="media-container">
            <box className="media-artwork">
                <icon 
                    className="media-icon"
                    icon={bind(currentPlayer).as(p => p?.entry || "multimedia-player-symbolic")}
                    iconSize={64}
                />
            </box>
            <box className="media-content" vertical>
                <MediaInfo />
                <MediaControls />
                <MediaProgress />
            </box>
        </box>
    </window>
}

// Export function for external media control
export { showMediaOSD }