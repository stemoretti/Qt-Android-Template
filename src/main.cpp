#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QTranslator>
#include <QScopedPointer>
#include <QDebug>
#include <QFontDatabase>

#include "settings.h"
#include "iconprovider.h"

int main(int argc, char *argv[])
{
    QGuiApplication::setApplicationName("Qt Android Template");
    QGuiApplication app(argc, argv);

    if (QFontDatabase::addApplicationFont(":/icons/MaterialIcons-Regular.ttf") == -1)
        qWarning() << "Failed to load font Material";

    QQuickStyle::setStyle("Material");

    QQmlApplicationEngine engine;

    engine.addImageProvider("icon", new IconProvider("Material Icons", ":/icons/codepoints.json"));

    qDebug() << "Available translations:" << Settings::translations();
    QScopedPointer<QTranslator> translator;
    QObject::connect(Settings::instance(), &Settings::languageChanged,
                     [&engine, &translator](QString language) {
        if (!translator.isNull()) {
            QCoreApplication::removeTranslator(translator.data());
            translator.reset();
        }
        if (language != "en") {
            translator.reset(new QTranslator);
            if (translator->load(QLocale(language), "qt-android-template", "_", ":/i18n"))
                QCoreApplication::installTranslator(translator.data());
        }
        engine.retranslate();
    });

    Settings::instance()->readSettingsFile();

    qmlRegisterSingletonType<Settings>("Settings", 1, 0, "Settings", Settings::singletonProvider);

    QUrl url("qrc:/qml/main.qml");
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    QObject::connect(&app, &QGuiApplication::applicationStateChanged,
                     [](Qt::ApplicationState state) {
        if (state == Qt::ApplicationSuspended) {
            Settings::instance()->writeSettingsFile();
        }
    });

    return app.exec();
}
