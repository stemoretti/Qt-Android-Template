#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QTranslator>
#include <QScopedPointer>
#include <QDebug>
#include <QFontDatabase>

#include "appdata.h"
#include "settings.h"
#include "system.h"
#include "iconprovider.h"

int main(int argc, char *argv[])
{
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#ifdef QT_DEBUG
    qputenv("QML_DISABLE_DISK_CACHE", "true");
#endif
    QGuiApplication app(argc, argv);

    if (QFontDatabase::addApplicationFont(":/icons/MaterialIcons-Regular.ttf") == -1)
        qWarning() << "Failed to load font Material";

    QQuickStyle::setStyle("Material");

    QQmlApplicationEngine engine;

    engine.addImageProvider("icon", new IconProvider("Material Icons", ":/icons/codepoints.json"));

    qDebug() << "Available translations:" << System::translations();
    QScopedPointer<QTranslator> translator;
    QObject::connect(&Settings::instance(), &Settings::languageChanged,
                     [&engine, &translator] (QString language) {
        if (!translator.isNull()) {
            QCoreApplication::removeTranslator(translator.data());
            translator.reset();
        }
        if (language != "en") {
            translator.reset(new QTranslator);
            if (translator->load(QLocale(language), "androidqmltemplate", "_", ":/translations"))
                QCoreApplication::installTranslator(translator.data());
        }
        engine.retranslate();
    });

    Settings::instance().readSettingsFile();

    QQmlContext *context = engine.rootContext();
    context->setContextProperty("appData", &AppData::instance());
    context->setContextProperty("appSettings", &Settings::instance());
    context->setContextProperty("appTranslations", System::translations());

    engine.load(QUrl("qrc:/qml/main.qml"));

    QObject::connect(&app, &QGuiApplication::applicationStateChanged,
                     [] (Qt::ApplicationState state) {
        if (state == Qt::ApplicationSuspended) {
            Settings::instance().writeSettingsFile();
        }
    });

    return app.exec();
}
