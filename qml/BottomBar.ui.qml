/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick
import QtQuick.Controls
import JSR

TabBar {
    id: root

    property alias menuOptions: repeater.model
    signal itemClicked(int item)

    contentHeight: 56

    background: Rectangle {
        color: Constants.accentColor
        border.color: Constants.accentTextColor
        radius: 12
    }

    Repeater {
        id: repeater

        delegate: TabButton {
            id: menuItem

            required property string name
            required property string page
            required property string source
            readonly property bool active: Constants.currentPage === menuItem.page

            background: Rectangle {
                color: "transparent"
            }

            width: undefined;
            height: undefined;

            icon.width: 24
            icon.height: 24
            icon.source: menuItem.source
            icon.color: menuItem.active ? "#2CDE85" : Constants.accentTextColor

            onClicked: {
                itemClicked(menuItem.page)
            }
        }
    }
}
