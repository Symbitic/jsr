cmake_minimum_required(VERSION 3.16)
project(jsr DESCRIPTION "Client for jsr.io" VERSION 0.0.0 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick QuickControls2)
qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(jsr
    main.cpp
)

set_target_properties(jsr PROPERTIES
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE TRUE
    MACOSX_BUNDLE_GUI_IDENTIFIER "jsr.jsr"
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
)

set_source_files_properties(qml/Constants.qml
    PROPERTIES
        QT_QML_SINGLETON_TYPE TRUE
)

set_source_files_properties(qml/AppSettings.qml
    PROPERTIES
        QT_QML_SINGLETON_TYPE TRUE
)

qt_add_qml_module(jsr
    URI "JSR"
    NO_RESOURCE_TARGET_PATH
    SOURCES
        httpclient.h
        httpclient.cpp
        endpoint.h
        endpoint.cpp
    QML_FILES
        qml/AppSettings.qml
        qml/BottomBar.ui.qml
        qml/Constants.qml
        qml/ExplorePage.ui.qml
        qml/HomePage.qml
        qml/Main.qml
        qml/PackageCard.ui.qml
        qml/ProfilePage.ui.qml
        qml/SettingsPage.qml
        qml/SideBar.ui.qml
    RESOURCES
        fonts/DMMono-Regular.ttf
        fonts/DMSans-Regular.ttf
        fonts/DMSerifDisplay-Regular.ttf
        fonts/DMSerifText-Regular.ttf
        images/browser.svg
        images/bun.svg
        images/deno.svg
        images/globe.svg
        images/home.svg
        images/jsr.svg
        images/node.svg
        images/search.svg
        images/settings.svg
        images/user.svg
        images/workerd.svg
        qtquickcontrols2.conf
)

target_link_libraries(jsr PUBLIC
    Qt::Core
    Qt::Gui
    Qt::Qml
    Qt::Quick
    Qt::QuickControls2
)

qt_generate_deploy_qml_app_script(
    TARGET jsr
    OUTPUT_SCRIPT deploy_script
    MACOS_BUNDLE_POST_BUILD
    NO_UNSUPPORTED_PLATFORM_ERROR
    DEPLOY_USER_QML_MODULES_ON_UNSUPPORTED_PLATFORM
)
install(SCRIPT ${deploy_script})
