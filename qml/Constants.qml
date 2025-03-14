pragma Singleton
import QtQuick

QtObject {
    enum Page {
        Home,
        Explore,
        Profile,

        Settings,
        Back = -1
    }
    enum Layout {
        Desktop,
        Tablet,
        Mobile
    }
    enum Sizes {
        DesktopSize = 1440,
        MobileSize = 647
    }

    readonly property int width: 1440
    readonly property int height: 1080

    property int layout: Layout.Mobile
    property int currentPage: Constants.Page.Home

    readonly property color navbarColor: "#09102B"
    readonly property color navbarIconColor: "#F3F3F4"

    readonly property color accentColor: AppSettings.isDarkMode ? "#002125" : "#FFFFFF"
    readonly property color primaryTextColor: AppSettings.isDarkMode ? "#EFFCF6" : "#000000"
    readonly property color accentTextColor: AppSettings.isDarkMode ? "#D9D9D9" : "#898989"
    readonly property color iconColor: AppSettings.isDarkMode ? "#30D158" : "#34C759"
}
