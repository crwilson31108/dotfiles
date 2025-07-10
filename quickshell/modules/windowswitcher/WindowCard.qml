import "./../../widgets"
import "./../../services"
import "./../../config"  
import "./../../utils"
import Quickshell
import Quickshell.Widgets
import QtQuick

Item {
    id: card

    required property var window
    required property bool selected
    property bool compact: false
    
    signal clicked()

    readonly property int cardWidth: compact ? 140 : 180
    readonly property int cardHeight: compact ? 90 : 120
    readonly property int iconSize: compact ? 36 : 56

    implicitWidth: cardWidth
    implicitHeight: cardHeight

    // Background
    StyledRect {
        id: cardBackground
        
        anchors.fill: parent
        anchors.margins: 2
        radius: Appearance.rounding.large
        
        color: card.selected ? 
            Colours.palette.m3primaryContainer : 
            Colours.palette.m3surfaceContainerHigh
        
        border.color: card.selected ? 
            Colours.palette.m3primary : 
            "transparent"
        border.width: card.selected ? 3 : 0

        Behavior on color {
            ColorAnimation {
                duration: Appearance.anim.durations.fast
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.anim.curves.standard
            }
        }

        Behavior on border.color {
            ColorAnimation {
                duration: Appearance.anim.durations.fast
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.anim.curves.standard
            }
        }
    }

    // Content
    Column {
        anchors.centerIn: parent
        spacing: card.compact ? Appearance.spacing.small : Appearance.spacing.normal

        // App icon with background circle
        Item {
            anchors.horizontalCenter: parent.horizontalCenter
            width: card.iconSize + (card.selected ? 12 : 8)
            height: card.iconSize + (card.selected ? 12 : 8)
            
            Rectangle {
                anchors.centerIn: parent
                width: parent.width
                height: parent.height
                radius: width / 2
                
                color: card.selected ? 
                    Colours.alpha(Colours.palette.m3primary, 0.12) : 
                    Colours.alpha(Colours.palette.m3onSurface, 0.08)
                
                visible: card.selected
                
                Behavior on color {
                    ColorAnimation {
                        duration: Appearance.anim.durations.fast
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Appearance.anim.curves.standard
                    }
                }
            }
            
            IconImage {
                anchors.centerIn: parent
                source: Quickshell.iconPath(AppMatching.getWindowIcon(card.window), "image-missing")
                implicitSize: card.iconSize
            }
        }

        // Window title
        StyledText {
            anchors.horizontalCenter: parent.horizontalCenter
            
            text: WindowIconMapper.getWindowTitle(card.window)
            font.pointSize: card.compact ? Appearance.font.size.small : Appearance.font.size.normal
            font.weight: card.selected ? Font.Medium : Font.Normal
            
            color: card.selected ? 
                Colours.palette.m3onPrimaryContainer : 
                Colours.palette.m3onSurface
            
            elide: Text.ElideRight
            width: Math.min(implicitWidth, card.cardWidth - Appearance.padding.large)
            horizontalAlignment: Text.AlignHCenter
            
            Behavior on color {
                ColorAnimation {
                    duration: Appearance.anim.durations.fast
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Appearance.anim.curves.standard
                }
            }
        }

        // App name (secondary text)
        StyledText {
            anchors.horizontalCenter: parent.horizontalCenter
            visible: !card.compact
            
            text: AppMatching.getWindowAppName(card.window)
            font.pointSize: Appearance.font.size.smaller
            
            color: card.selected ? 
                Colours.alpha(Colours.palette.m3onPrimaryContainer, 0.7) : 
                Colours.palette.m3onSurfaceVariant
            
            elide: Text.ElideRight
            width: Math.min(implicitWidth, card.cardWidth - Appearance.padding.large)
            horizontalAlignment: Text.AlignHCenter
        }
    }

    // Click area
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        
        onClicked: card.clicked()
        
        // Enhanced hover effect
        onEntered: {
            if (!card.selected) {
                cardBackground.color = Colours.palette.m3surfaceContainerHighest;
            }
        }
        onExited: {
            if (!card.selected) {
                cardBackground.color = Colours.palette.m3surfaceContainerHigh;
            }
        }
    }

    // Subtle scale animation when selected
    transform: Scale {
        origin.x: card.width / 2
        origin.y: card.height / 2
        xScale: card.selected ? 1.02 : 1.0
        yScale: card.selected ? 1.02 : 1.0
        
        Behavior on xScale {
            NumberAnimation {
                duration: Appearance.anim.durations.normal
                easing.type: Easing.OutCubic
            }
        }
        
        Behavior on yScale {
            NumberAnimation {
                duration: Appearance.anim.durations.normal
                easing.type: Easing.OutCubic
            }
        }
    }
}