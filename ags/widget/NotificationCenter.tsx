import { Variable, bind } from "astal"
import { Astal, Gtk, Gdk, App } from "astal/gtk3"
import Notifd from "gi://AstalNotifd"

const notifyd = Notifd.get_default()

function NotificationItem({ notification, onDismiss }: { 
    notification: Notifd.Notification,
    onDismiss: () => void 
}) {
    const hovered = Variable(false)
    
    return <eventbox
        onHover={() => hovered.set(true)}
        onHoverLost={() => hovered.set(false)}>
        <box className={`notification-item ${notification.urgency === 2 ? "urgent" : ""}`}>
            <icon 
                icon={notification.appIcon || notification.desktopEntry || "dialog-information-symbolic"} 
                css="font-size: 24px; margin-right: 12px;"
            />
            <box vertical hexpand>
                <label 
                    className="notif-summary"
                    halign={Gtk.Align.START}
                    label={notification.summary}
                    wrap={false}
                    css="font-weight: bold;"
                />
                {notification.body && (
                    <label 
                        className="notif-body"
                        halign={Gtk.Align.START}
                        label={notification.body}
                        wrap
                        css="opacity: 0.8;"
                    />
                )}
                <label 
                    className="notif-time"
                    halign={Gtk.Align.START}
                    label={new Date(notification.time * 1000).toLocaleTimeString()}
                    css="font-size: 11px; opacity: 0.6;"
                />
            </box>
            <revealer
                revealChild={hovered()}
                transitionType={Gtk.RevealerTransitionType.CROSSFADE}
                transitionDuration={200}>
                <button
                    className="notif-dismiss"
                    onClicked={() => {
                        notification.dismiss()
                        onDismiss()
                    }}>
                    <icon icon="window-close-symbolic" />
                </button>
            </revealer>
        </box>
    </eventbox>
}

function NotificationCenter() {
    const notifications = Variable<Notifd.Notification[]>([])
    
    // Load existing notifications
    notifyd.get_notifications().forEach(n => {
        notifications.set([...notifications.get(), n])
    })
    
    // Listen for new notifications
    notifyd.connect("notified", (_, id) => {
        const notif = notifyd.get_notification(id)
        if (notif) {
            notifications.set([notif, ...notifications.get()])
        }
    })
    
    // Listen for resolved notifications
    notifyd.connect("resolved", (_, id) => {
        notifications.set(notifications.get().filter(n => n.id !== id))
    })
    
    return <box vertical className="notification-center">
        <box className="notif-header">
            <label label="Notifications" css="font-size: 16px; font-weight: bold;" />
            <box hexpand />
            <button
                className="clear-all-btn"
                visible={bind(notifications).as(n => n.length > 0)}
                onClicked={() => {
                    notifications.get().forEach(n => n.dismiss())
                    notifications.set([])
                }}>
                <label label="Clear All" />
            </button>
        </box>
        <scrollable vexpand heightRequest={700}>
            <box vertical>
                {bind(notifications).as(notifs => 
                    notifs.length === 0 ? (
                        <box vexpand valign={Gtk.Align.CENTER} css="opacity: 0.5;">
                            <label label="No notifications" />
                        </box>
                    ) : (
                        notifs.map(n => (
                            <NotificationItem 
                                notification={n} 
                                onDismiss={() => {
                                    notifications.set(notifications.get().filter(notif => notif.id !== n.id))
                                }}
                            />
                        ))
                    )
                )}
            </box>
        </scrollable>
    </box>
}

export default function NotificationCenterWindow(monitor: Gdk.Monitor) {
    return <window
        name="NotificationCenter"
        className="NotificationCenter"
        gdkmonitor={monitor}
        visible={false}
        keymode={Astal.Keymode.ON_DEMAND}
        anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.RIGHT}
        marginTop={40}
        marginRight={10}
        application={App}
        onKeyPressEvent={(self, event) => {
            if (event.get_keyval()[1] === Gdk.KEY_Escape) {
                self.visible = false
            }
        }}
        setup={(self) => {
            // Close notification center when clicking outside
            const closeOnFocusLoss = () => {
                setTimeout(() => {
                    if (!self.is_active) {
                        self.visible = false
                    }
                }, 100)
            }
            
            self.connect("focus-out-event", closeOnFocusLoss)
        }}>
        <NotificationCenter />
    </window>
}