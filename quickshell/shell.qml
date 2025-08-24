//@ pragma Env QS_NO_RELOAD_POPUP=1

import "modules"
import "modules/drawers"
import "modules/background"
import "modules/areapicker"
import "modules/lock"
import "modules/powermenu"
import Quickshell

ShellRoot {
    Background {}
    Drawers {}
    AreaPicker {}
    Lock {}
    PowerMenu {}

    Shortcuts {}
}
