pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Universal
import QtQuick.Controls.Material
import QtQuick.Layouts
import JSR

ApplicationWindow {
    id: root
    width: Constants.width
    height: Constants.height
    minimumHeight: 272
    minimumWidth: Qt.PrimaryOrientation === Qt.LandscapeOrientation ? 480 : 360
    visible: true
    title: qsTr("JSR")

    property list<string> builtInStyles

    Universal.theme: AppSettings.isDarkMode ? Universal.Dark : Universal.Light
    Material.theme: AppSettings.isDarkMode ? Material.Dark : Material.Light

    HTTPClient {
        id: client
        base: "https://api.jsr.io"

        Endpoint {
            id: listPackages
            path: "/packages"
            method: "GET"
        }

        Endpoint {
            id: getStats
            path: "/stats"
            method: "GET"
        }
    }

    Component.onCompleted: () => {
        // Cache home data on startup
        getStats.fetchData();

        // Make layout responsive.
        Constants.layout = Qt.binding(() => {
            if (root.width >= Constants.Sizes.DesktopSize) {
                return Constants.Layout.Desktop;
            } else if (root.width >= Constants.Sizes.MobileSize) {
                return Constants.Layout.Tablet;
            } else {
                return Constants.Layout.Mobile;
            }
        });
    }

    function navigate(page: int) {
        if (Constants.currentPage === page) {
            return;
        }

        switch (page) {
        case Constants.Page.Home:
            Constants.currentPage = Constants.Page.Home;
            stackView.push("qrc:/qml/HomePage.qml", {
                getStats: getStats
            });
            break;
        case Constants.Page.Explore:
            Constants.currentPage = Constants.Page.Explore;
            stackView.push("qrc:/qml/ExplorePage.ui.qml");
            break;
        case Constants.Page.Profile:
            Constants.currentPage = Constants.Page.Profile;
            stackView.push("qrc:/qml/ProfilePage.ui.qml");
            break;
        case Constants.Page.Settings:
            Constants.currentPage = Constants.Page.Settings;
            stackView.push("qrc:/qml/SettingsPage.qml", {
                builtInStyles: root.builtInStyles
            });
            break;
        case Constants.Page.Back:
            stackView.pop();
            break;
        }
    }

    Shortcut {
        sequence: StandardKey.Quit
        onActivated: Qt.quit()
    }

    background: Rectangle {
        color: Constants.accentColor
    }

    header: ToolBar {
        id: toolBar

        background: Rectangle {
            color: Constants.navbarColor
        }

        RowLayout {
            anchors.fill: parent
            Image {
                id: logo

                Layout.topMargin: 6
                Layout.bottomMargin: 6
                Layout.leftMargin: 38
                source: "qrc:/images/jsr.svg"
            }

            Item {
                Layout.fillWidth: true
            }

            ToolButton {
                id: settingsButton

                Layout.rightMargin: Constants.layout === Constants.Layout.Mobile ? 5 : 19
                icon.source: "qrc:/images/settings.svg"
                icon.color: Constants.navbarIconColor

                onClicked: {
                    navigate(Constants.Page.Settings)
                }
            }
        }
    }

    ListModel {
        id: menuItems

        ListElement {
            name: qsTr("Home")
            page: Constants.Page.Home
            source: "qrc:/images/home.svg"
        }
        ListElement {
            name: qsTr("Explore")
            page: Constants.Page.Explore
            source: "qrc:/images/search.svg"
        }
        ListElement {
            name: qsTr("Profile")
            page: Constants.Page.Profile
            source: "qrc:/images/user.svg"
        }
    }

    SideBar {
        id: sideMenu

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        height: parent.height
        rightPadding: 5

        menuOptions: menuItems
        currentPage: Constants.currentPage
        onItemClicked: (page) => {
            navigate(page)
        }
    }

    Rectangle {
        id: border
        width: 1
        height: parent.height
        color: Constants.primaryTextColor
        visible: sideMenu.visible
        anchors.left: sideMenu.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
    }

    StackView {
        id: stackView

        anchors.left: border.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        initialItem: HomePage {
            getStats: getStats
        }
        onCurrentItemChanged: {
            stackView.currentItem.navigate.connect(root.navigate);
        }
    }

    BottomBar {
        id: bottomMenu

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width: parent.width

        visible: false
        position: TabBar.Footer
        menuOptions: menuItems
        onItemClicked: (page) => {
            navigate(page)
        }
    }

    StateGroup {
        states: [
            State {
                name: "desktopLayout"
                when: Constants.layout === Constants.Layout.Desktop

                PropertyChanges {
                    target: sideMenu
                    visible: true
                    anchors.topMargin: 63
                }
                PropertyChanges {
                    target: bottomMenu
                    visible: false
                }
                PropertyChanges {
                    target: stackView
                    anchors.leftMargin: 5
                }
                PropertyChanges {
                    target: logo
                    Layout.leftMargin: 38
                    sourceSize.height: 50
                    Layout.topMargin: 6
                    Layout.bottomMargin: 6
                }
                PropertyChanges {
                    target: toolBar
                    height: 56
                }
                AnchorChanges {
                    target: stackView
                    anchors.left: sideMenu.right
                    anchors.bottom: parent.bottom
                }
            },
            State {
                name: "tabletLayout"
                when: Constants.layout === Constants.Layout.Tablet

                PropertyChanges {
                    target: sideMenu
                    visible: true
                    anchors.topMargin: 24
                }
                PropertyChanges {
                    target: bottomMenu
                    visible: false
                }
                PropertyChanges {
                    target: stackView
                    anchors.leftMargin: 5
                }
                PropertyChanges {
                    target: logo
                    Layout.leftMargin: 5
                    sourceSize.height: 18
                    Layout.topMargin: 5
                    Layout.bottomMargin: 0
                }
                PropertyChanges {
                    target: toolBar
                    height: 24
                }
                AnchorChanges {
                    target: stackView
                    anchors.left: sideMenu.right
                    anchors.bottom: parent.bottom
                }
            },
            State {
                name: "mobileLayout"
                when: Constants.layout === Constants.Layout.Mobile

                PropertyChanges {
                    target: sideMenu
                    visible: false
                }
                PropertyChanges {
                    target: bottomMenu
                    visible: true
                }
                PropertyChanges {
                    target: stackView
                    anchors.leftMargin: 0
                }
                PropertyChanges {
                    target: logo
                    Layout.leftMargin: 19
                    sourceSize.height: 25
                    Layout.topMargin: 7
                    Layout.bottomMargin: 7
                }
                PropertyChanges {
                    target: toolBar
                    height: 39
                }
                AnchorChanges {
                    target: stackView
                    anchors.left: parent.left
                    anchors.bottom: bottomMenu.top
                }
            }
        ]
    }
}
