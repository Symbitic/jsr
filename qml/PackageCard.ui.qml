import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import JSR

Pane {
    id: root

    required property string name
    required property string scope
    required property string description
    required property int score
    required property variant runtimeCompat

    property string scoreColor: score >= 90 ? "green" : score >= 60 ? "yellow" : "red"

    property list<string> icons: Object.entries(runtimeCompat || {})
        .filter(([key, val]) => val && val === true)
        .map(([key, val]) => "qrc:/images/" + key + ".svg")

    ColumnLayout {
        id: layout

        width: root.width

        RowLayout {
            Label {
                text: `@<a href="https://jsr.io/@${scope}">${scope}</a> / <a href="https://jsr.io/@${scope}/${name}"><strong>${name}</strong></a>`
                color: Constants.primaryTextColor
                onLinkActivated: (link) => {
                    Qt.openUrlExternally(link)
                }
            }
            Item {
                Layout.fillWidth: true
            }
            Repeater {
                model: icons
                Image {
                    source: modelData
                    sourceSize.width: 20
                    sourceSize.height: 20
                }
            }
        }

        RowLayout {
            Label {
                text: description
                color: Constants.accentTextColor
                elide: Text.ElideRight
                wrapMode: Text.NoWrap
                Layout.preferredWidth: layout.width * 0.90
            }
            Item {
                Layout.fillWidth: true
            }
            Label {
                text: score + "%"
                color: scoreColor
            }
        }
    }
}
