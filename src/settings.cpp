#include "settings.h"

#include <QDebug>
#include <QStringList>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QQmlEngine>

#include "system.h"

Settings::Settings(QObject *parent)
    : QObject(parent)
    , m_darkTheme(false)
    , m_primaryColor("#607D8B") // Material.BlueGrey
    , m_accentColor("#FF9800") // Material.Orange
    , m_language("en")
    , m_country("en_US")
{
    QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);
    m_settingsFilePath = System::dataRoot() + "/settings.json";
}

Settings::~Settings()
{
    writeSettingsFile();
}

Settings *Settings::instance()
{
    static Settings s;
    return &s;
}

QObject *Settings::singletonProvider(QQmlEngine *qmlEngine, QJSEngine *jsEngine)
{
    Q_UNUSED(qmlEngine)
    Q_UNUSED(jsEngine)

    return instance();
}

void Settings::readSettingsFile()
{
    qDebug() << "Read the settings file";

    QFile readFile(m_settingsFilePath);

    if (!readFile.exists()) {
        qWarning() << "Cannot find the settings file:" << m_settingsFilePath;
        qDebug() << "Using default settings values";
        setCountry(System::locale());
        if (System::translations().contains(System::language()))
            setLanguage(System::language());
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
    setCountry(jobj["country"].toString());

    qDebug() << "Settings file read";
}

void Settings::writeSettingsFile() const
{
    qDebug() << "Write the settings file";

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
    jobj["country"] = m_country;
    writeFile.write(QJsonDocument(jobj).toJson());
    writeFile.close();

    qDebug() << "Settings file saved";
}

bool Settings::darkTheme() const
{
    return m_darkTheme;
}

void Settings::setDarkTheme(bool darkTheme)
{
    if (m_darkTheme == darkTheme)
        return;

    m_darkTheme = darkTheme;
    Q_EMIT darkThemeChanged(m_darkTheme);
}

QColor Settings::primaryColor() const
{
    return m_primaryColor;
}

void Settings::setPrimaryColor(const QColor &primaryColor)
{
    if (m_primaryColor == primaryColor)
        return;

    m_primaryColor = primaryColor;
    Q_EMIT primaryColorChanged(m_primaryColor);
}

QColor Settings::accentColor() const
{
    return m_accentColor;
}

void Settings::setAccentColor(const QColor &accentColor)
{
    if (m_accentColor == accentColor)
        return;

    m_accentColor = accentColor;
    Q_EMIT accentColorChanged(m_accentColor);
}

QString Settings::language() const
{
    return m_language;
}

void Settings::setLanguage(const QString &language)
{
    if (m_language == language)
        return;

    m_language = language;
    Q_EMIT languageChanged(m_language);
}

QString Settings::country() const
{
    return m_country;
}

void Settings::setCountry(const QString &country)
{
    if (m_country == country)
        return;

    m_country = country;
    Q_EMIT countryChanged(m_country);
}
