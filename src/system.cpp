#include "system.h"

#include <QStandardPaths>
#include <QLocale>
#include <QQmlEngine>
#include <QDir>
#include <QRegularExpression>

System::System(QObject *parent) : QObject(parent)
{
    QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);
}

System *System::instance()
{
    static System s;
    return &s;
}

QObject *System::singletonProvider(QQmlEngine *qmlEngine, QJSEngine *jsEngine)
{
    Q_UNUSED(qmlEngine)
    Q_UNUSED(jsEngine)

    return instance();
}

QString System::dataRoot()
{
    return QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
}

QString System::language()
{
    return QLocale().name().left(2);
}

QString System::locale()
{
    return QLocale().name();
}

QStringList System::translations()
{
    QDir translationsDir(":/i18n");
    QStringList languages({ "en" });

    if (translationsDir.exists()) {
        QStringList translations = translationsDir.entryList({ "*.qm" });
        translations.replaceInStrings(QRegularExpression("[^_]+_(\\w+)\\.qm"), "\\1");
        languages.append(translations);
        languages.sort();
    }

    return languages;
}
