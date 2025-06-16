import { App } from "astal/gtk3"
import style from "./style-minimal.scss"
import TopBar from "./widget/TopBar"
import BottomBar from "./widget/BottomBar"
import OSD from "./osd/OSD"

App.start({
    css: style,
    main() {
        App.get_monitors().map(monitor => {
            TopBar(monitor)
            BottomBar(monitor)
            OSD(monitor)
        })
    },
})