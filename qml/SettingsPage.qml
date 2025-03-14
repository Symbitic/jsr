import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    id: root

    property list<string> builtInStyles
    signal navigate(page: int)

    ToolTip {
        id: restartTip

        y: parent.height - restartTip.implicitHeight

        timeout: 5000
        text: qsTr("Please restart the application to apply the new theme")
    }

    ColumnLayout {
        id: settingsLayout
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20

        RowLayout {
            width: parent.width
            Label {
                horizontalAlignment: Text.AlignLeft
                wrapMode: Text.Wrap
                text: qsTr("Theme")
                font.pixelSize: internal.fontSize

                Layout.fillWidth: true
            }
            ComboBox {
                model: builtInStyles
                onActivated: {
                    if (currentValue !== AppSettings.style) {
                        AppSettings.style = currentValue;
                        restartTip.visible = true;
                    }
                }
                Component.onCompleted: currentIndex = builtInStyles.indexOf(AppSettings.style) || 0
            }
        }

        RowLayout {
            width: parent.width
            Label {
                horizontalAlignment: Text.AlignLeft
                wrapMode: Text.Wrap
                text: qsTr("Dark mode")
                font.pixelSize: internal.fontSize

                Layout.fillWidth: true
            }
            Switch {
                font.pixelSize: internal.fontSize
                checked: AppSettings.isDarkMode
                onToggled: {
                    AppSettings.isDarkMode = !AppSettings.isDarkMode;
                }
            }
        }
    }

    QtObject {
        id: internal
        property int fontSize: AppSettings.fontSize
    }

    states: [
        State {
            name: "desktop"
            when: Constants.layout === Constants.Layout.Desktop
            PropertyChanges {
                target: internal
                fontSize: AppSettings.fontSize * 2.5
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
