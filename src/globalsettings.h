#ifndef GLOBAL_SETTINGS_H_
#define GLOBAL_SETTINGS_H_

#include <QObject>
#include <QColor>
#include <QString>

#include <QtQml/qqmlregistration.h>

class QQmlEngine;
class QJSEngine;

class GlobalSettings : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(bool darkTheme READ darkTheme WRITE setDarkTheme NOTIFY darkThemeChanged)
    Q_PROPERTY(QColor primaryColor READ primaryColor WRITE setPrimaryColor NOTIFY primaryColorChanged)
    Q_PROPERTY(QColor accentColor READ accentColor WRITE setAccentColor NOTIFY accentColorChanged)
    Q_PROPERTY(QString language READ language WRITE setLanguage NOTIFY languageChanged)

public:
    virtual ~GlobalSettings();

    inline static GlobalSettings *instance;
    static void init(QObject *parent) { instance = new GlobalSettings(parent); }
    static GlobalSettings *create(QQmlEngine *, QJSEngine *) { return instance; }

    void loadSettings();
    void saveSettings() const;

    Q_INVOKABLE static QStringList translations();

    bool darkTheme() const;
    void setDarkTheme(bool darkTheme);

    QColor primaryColor() const;
    void setPrimaryColor(const QColor &primaryColor);

    QColor accentColor() const;
    void setAccentColor(const QColor &accentColor);

    QString language() const;
    void setLanguage(const QString &language);

Q_SIGNALS:
    void darkThemeChanged(bool darkTheme);
    void primaryColorChanged(QColor primaryColor);
    void accentColorChanged(QColor accentColor);
    void languageChanged(QString language);

private:
    explicit GlobalSettings(QObject *parent = nullptr);
    Q_DISABLE_COPY_MOVE(GlobalSettings)

    QString m_settingsFilePath;

    bool m_darkTheme;
    QColor m_primaryColor;
    QColor m_accentColor;
    QString m_language;
};

#endif
