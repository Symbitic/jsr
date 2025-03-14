/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import JSR

Column {
    id: root

    property alias menuOptions: repeater.model
    property int currentPage
    signal itemClicked(int item)

    leftPadding: internal.leftPadding
    spacing: internal.spacing

    Repeater {
        id: repeater
        model: menuOptions

        delegate: ItemDelegate {
            id: columnItem

            required property string name
            required property int page
            required property string source

            readonly property bool active: currentPage === columnItem.page

            width: column.width
            height: column.height

            background: Rectangle {
                color: active ? "#2CDE85" : "transparent"
                anchors.fill: parent
                radius: Constants.layout === Constants.Layout.Mobile ? 4 : 12
                opacity: Constants.layout === Constants.Layout.Mobile ? 0.3 : 0.1
            }

            Column {
                id: column
                padding: 0

                Item {
                    id: menuItem

                    width: internal.delegateWidth
                    height: internal.delegateHeight
                    visible: true

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: internal.leftMargin
                        anchors.rightMargin: internal.rightMargin
                        spacing: 24

                        Item {
                            Layout.preferredWidth: internal.iconWidth
                            Layout.preferredHeight: internal.iconWidth
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                            Image {
                                id: icon

                                source: columnItem.source
                                sourceSize.width: internal.iconWidth
                            }
                        }

                        Label {
                            id: menuItemName
                            text: name
                            color: Constants.primaryTextColor
                            font.pixelSize: 18
                            font.weight: 600
                            visible: internal.isNameVisible
                            Layout.fillWidth: true
                        }
                    }
                }
            }

            onClicked: {
                itemClicked(columnItem.page)
            }
        }
    }

    QtObject {
        id: internal

        property int delegateWidth: 290
        property int delegateHeight: 60
        property int iconWidth: 34
        property int leftMargin: 5
        property int rightMargin: 13
        property int leftPadding: 5
        property int spacing: 5
        property bool isNameVisible: true
    }

    states: [
        State {
            name: "desktop"
            when: Constants.layout === Constants.Layout.Desktop
            PropertyChanges {
                target: internal
                delegateWidth: 290
                delegateHeight: 60
                iconWidth: 34
                isNameVisible: true
                leftMargin: 31
                rightMargin: 13
                leftPadding: 5
                spacing: 5
            }
        },
        State {
            name: "tablet"
            when: Constants.layout === Constants.Layout.Tablet
            PropertyChanges {
                target: internal
                delegateWidth: 56
                delegateHeight: 56
                iconWidth: 34
                isNameVisible: false
                leftMargin: 0
                rightMargin: 0
                leftPadding: 5
                spacing: 5
            }
        },
        State {
            name: "mobile"
            when: Constants.layout === Constants.Layout.Mobile
            PropertyChanges {
                target: internal
                delegateWidth: 24
                delegateHeight: 24
                iconWidth: 24
                isNameVisible: false
                leftMargin: 0
                rightMargin: 0
                leftPadding: 6
                spacing: 12
            }
        }
    ]
}
