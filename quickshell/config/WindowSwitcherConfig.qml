import Quickshell.Io

JsonObject {
    property JsonObject preview: JsonObject {
        property int width: 300
        property int height: 200
        property bool enabled: true
        property bool showTitle: true
    }
    
    property JsonObject layout: JsonObject {
        property int maxVisibleCards: 5
        property bool slidingWindow: true  // Enable sliding window for overflow
    }
}