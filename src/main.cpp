#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QTranslator>
#include <QScopedPointer>
#include <QDebug>

#include <BaseUI/core.h>

#include "globalsettings.h"

int main(int argc, char *argv[])
{
    QGuiApplication::setApplicationName("Qt Android Template");

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine *engine = new QQmlApplicationEngine();

    GlobalSettings::init(engine);

    BaseUI::init(engine);

    qDebug() << "Available translations:" << GlobalSettings::translations();
    QScopedPointer<QTranslator> translator;
    QObject::connect(GlobalSettings::instance, &GlobalSettings::languageChanged,
                     [engine, &translator](QString language) {
        if (!translator.isNull()) {
            QCoreApplication::removeTranslator(translator.data());
            translator.reset();
        }
        if (language != "en") {
            translator.reset(new QTranslator);
            if (translator->load(QLocale(language), "qt-android-template", "_", ":/i18n"))
                QCoreApplication::installTranslator(translator.data());
        }
        engine->retranslate();
    });

    GlobalSettings::instance->loadSettings();

    QUrl url("qrc:/qml/main.qml");
    QObject::connect(engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine->load(url);

    QObject::connect(&app, &QGuiApplication::applicationStateChanged,
                     [](Qt::ApplicationState state) {
        if (state == Qt::ApplicationSuspended) {
            GlobalSettings::instance->saveSettings();
        }
    });

    int ret = app.exec();

    delete engine;

    return ret;
}
