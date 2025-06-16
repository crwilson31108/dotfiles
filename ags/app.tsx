import { App } from "astal/gtk3"
import style from "./style-minimal.scss"
import TopBar from "./widget/TopBar"
import BottomBar from "./widget/BottomBar"
import OSD from "./osd/OSD"
import NotificationCenter from "./widget/NotificationCenter"

App.start({
    css: style,
    main() {
        App.get_monitors().map(monitor => {
            TopBar(monitor)
            BottomBar(monitor)
            OSD(monitor)
            NotificationCenter(monitor)
        })
    },
})