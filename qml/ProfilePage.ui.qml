import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    id: root

    signal navigate(page: int)

    padding: 0

    Label {
        text: qsTr("Profile")
    }
}
