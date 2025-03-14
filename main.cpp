#include <QtCore/QUrl>
#include <QtCore/QCommandLineOption>
#include <QtCore/QCommandLineParser>
#include <QGuiApplication>
#include <QStyleHints>
#include <QScreen>
#include <QQmlApplicationEngine>
#include <QtQml/QQmlContext>
#include <QSettings>
#include <QQuickStyle>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QGuiApplication::setApplicationDisplayName(QCoreApplication::translate("main", "JSR"));
    QGuiApplication::setApplicationName("JSR");
    QGuiApplication::setOrganizationName("Deno");
    QGuiApplication::setApplicationVersion(QT_VERSION_STR);

    QCommandLineParser parser;
    parser.setApplicationDescription(QGuiApplication::applicationDisplayName());
    parser.addHelpOption();
    parser.addVersionOption();
    QStringList arguments = app.arguments();
    parser.process(arguments);

    QSettings settings;
    if (qEnvironmentVariableIsEmpty("QT_QUICK_CONTROLS_STYLE")
        && settings.value("style").toString().isEmpty()) {
#if defined(Q_OS_MACOS)
        QQuickStyle::setStyle(QString("iOS"));
#elif defined(Q_OS_IOS)
        QQuickStyle::setStyle(QString("iOS"));
#elif defined(Q_OS_WINDOWS)
        QQuickStyle::setStyle(QString("Windows"));
#elif defined(Q_OS_ANDROID)
        QQuickStyle::setStyle(QString("Material"));
#endif
    } else {
        QQuickStyle::setStyle(settings.value("style").toString());
    }

    const QString styleInSettings = settings.value("style").toString();
    if (styleInSettings.isEmpty()) {
        settings.setValue(QString("style"), QQuickStyle::name());
    }

    QStringList builtInStyles = { QString("Material"), QString("Universal") };
#if defined(Q_OS_MACOS)
    builtInStyles << QString("iOS");
#elif defined(Q_OS_IOS)
    builtInStyles << QString("iOS");
#elif defined(Q_OS_WINDOWS)
    builtInStyles << QString("Windows");
#endif

    QQmlApplicationEngine engine;
    QObject::connect(&engine, &QQmlApplicationEngine::quit, &app, &QGuiApplication::quit);

    engine.setInitialProperties({ { "builtInStyles", builtInStyles } });
    engine.loadFromModule("JSR", "Main");
    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

    return app.exec();
}
