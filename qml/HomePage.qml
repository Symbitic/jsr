import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    id: root

    property Endpoint getStats
    property list<QtObject> featuredPackages: []
    signal navigate(page: int)

    padding: 0

    Column {
        id: title

        width: internal.contentWidth
        leftPadding: 16
        topPadding: 20

        Label {
            id: heading

            text: qsTr("Home")
            font.pixelSize: internal.fontSize
            font.bold: true
            color: Constants.primaryTextColor
            elide: Text.ElideRight
        }

        // TODO: Search
    }

    ListView {
        id: featuredPackagesList

        width: internal.contentWidth
        spacing: 16
        rightMargin: 25
        clip: true
        anchors.top: title.bottom
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        model: getStats.data.featured
        delegate: PackageCard {
            width: parent.width
        }
    }

    QtObject {
        id: internal

        readonly property int contentWidth: root.width - root.rightPadding - root.leftPadding
        property int fontSize: AppSettings.fontSize
    }

    states: [
        State {
            name: "desktop"
            when: Constants.layout === Constants.Layout.Desktop
            PropertyChanges {
                target: internal
                fontSize: AppSettings.fontSize * 2
            }
        },
        State {
            name: "tablet"
            when: Constants.layout === Constants.Layout.Tablet
            PropertyChanges {
                target: internal
                fontSize: AppSettings.fontSize * 1.5
            }
        },
        State {
            name: "mobile"
            when: Constants.layout === Constants.Layout.Mobile
            PropertyChanges {
                target: internal
                fontSize: AppSettings.fontSize
            }
        }
    ]
}
