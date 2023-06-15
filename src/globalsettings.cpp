#include "globalsettings.h"

#include <QDebug>
#include <QStringList>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QQmlEngine>
#include <QLocale>
#include <QStandardPaths>
#include <QDir>

GlobalSettings::GlobalSettings(QObject *parent)
    : QObject(parent)
    , m_darkTheme(false)
    , m_primaryColor("#607D8B") // Material.BlueGrey
    , m_accentColor("#FF9800") // Material.Orange
    , m_language("en")
{
    QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);

    QString path = QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation);
    m_settingsFilePath = path + "/settings.json";

    QDir dir;
    if (!dir.exists(path)) {
        if (!dir.mkpath(path))
            qWarning() << "Cannot create" << path;
        else
            qDebug() << "Created directory" << path;
    }
}

GlobalSettings::~GlobalSettings()
{
    saveSettings();
}

void GlobalSettings::loadSettings()
{
    qDebug() << "Loading settings...";

    QFile readFile(m_settingsFilePath);

    if (!readFile.exists()) {
        qWarning() << "Cannot find the settings file:" << m_settingsFilePath;
        if (translations().contains(QLocale().name().left(2)))
            setLanguage(QLocale().name().left(2));
        return;
    }
    if (!readFile.open(QIODevice::ReadOnly)) {
        qWarning() << "Cannot open file:" << m_settingsFilePath;
        return;
    }
    auto jdoc = QJsonDocument::fromJson(readFile.readAll());
    readFile.close();
    if (!jdoc.isObject()) {
        qWarning() << "Cannot read JSON file:" << m_settingsFilePath;
        return;
    }
    auto jobj = jdoc.object();
    setDarkTheme(jobj["darkTheme"].toBool());
    setPrimaryColor(jobj["primaryColor"].toString());
    setAccentColor(jobj["accentColor"].toString());
    setLanguage(jobj["language"].toString());

    qDebug() << "Settings loaded";
}

void GlobalSettings::saveSettings() const
{
    qDebug() << "Saving settings...";

    QFile writeFile(m_settingsFilePath);

    if (!writeFile.open(QIODevice::WriteOnly)) {
        qWarning() << "Cannot open file for writing:" << m_settingsFilePath;
        return;
    }
    QJsonObject jobj;
    jobj["darkTheme"] = m_darkTheme;
    jobj["primaryColor"] = m_primaryColor.name(QColor::HexRgb);
    jobj["accentColor"] = m_accentColor.name(QColor::HexRgb);
    jobj["language"] = m_language;
    writeFile.write(QJsonDocument(jobj).toJson());
    writeFile.close();

    qDebug() << "Settings saved";
}

QStringList GlobalSettings::translations()
{
    QDir translationsDir(":/i18n");
    QStringList languages({ "en" });

    if (translationsDir.exists()) {
        QStringList translations = translationsDir.entryList({ "*.qm" });
        translations.replaceInStrings("qt-android-template_", "");
        translations.replaceInStrings(".qm", "");
        languages.append(translations);
        languages.sort();
    }

    return languages;
}

bool GlobalSettings::darkTheme() const
{
    return m_darkTheme;
}

void GlobalSettings::setDarkTheme(bool darkTheme)
{
    if (m_darkTheme == darkTheme)
        return;

    m_darkTheme = darkTheme;
    Q_EMIT darkThemeChanged(m_darkTheme);
}

QColor GlobalSettings::primaryColor() const
{
    return m_primaryColor;
}

void GlobalSettings::setPrimaryColor(const QColor &primaryColor)
{
    if (m_primaryColor == primaryColor)
        return;

    m_primaryColor = primaryColor;
    Q_EMIT primaryColorChanged(m_primaryColor);
}

QColor GlobalSettings::accentColor() const
{
    return m_accentColor;
}

void GlobalSettings::setAccentColor(const QColor &accentColor)
{
    if (m_accentColor == accentColor)
        return;

    m_accentColor = accentColor;
    Q_EMIT accentColorChanged(m_accentColor);
}

QString GlobalSettings::language() const
{
    return m_language;
}

void GlobalSettings::setLanguage(const QString &language)
{
    if (m_language == language)
        return;

    m_language = language;
    Q_EMIT languageChanged(m_language);
}
