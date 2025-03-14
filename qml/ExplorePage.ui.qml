import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    id: root

    signal navigate(page: int)

    padding: 12

    GridLayout {
        flow: GridLayout.LeftToRight
        width: internal.contentWidth

        Label {
            id: heading

            text: qsTr("Explore")
            font.pixelSize: internal.fontSize
            font.bold: true
            color: Constants.primaryTextColor
            elide: Text.ElideRight
        }

        Item {
            id: spacer
            visible: true
            Layout.fillWidth: true
        }

        TextField {
            id: searchInput
            rightPadding: padding + searchIcon.width + searchIcon.anchors.rightMargin
            placeholderText: qsTr("Search")
            Layout.preferredWidth: 250

            onAccepted: {
                console.log('Accepted')
                // doSearch(searchInput.text)
            }

            background: Rectangle {
                border {
                    width: 1
                    color: Constants.primaryTextColor
                }
                color: "transparent"
                radius: 3
                Button {
                    id: searchIcon
                    flat: true
                    icon.source: Qt.resolvedUrl("qrc:/images/search.svg")
                    icon.height: searchInput.implicitHeight - searchInput.padding * 2
                    icon.width: searchInput.implicitHeight - searchInput.padding * 2
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                    onClicked: {
                        // doSearch(searchText.text)
                    }
                }
            }
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
