pragma Singleton

import QtQuick
import QtCore

Settings {
    id: settings

    property string style
    property int fontSize: 16
    property bool isDarkMode: Qt.styleHints.colorScheme === Qt.Dark
}
