#ifndef APPDATA_H
#define APPDATA_H

#include <QObject>

class QQmlEngine;
class QJSEngine;

class AppData : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString message READ message WRITE setMessage NOTIFY messageChanged)

public:
    virtual ~AppData();

    static AppData *instance();
    static QObject *singletonProvider(QQmlEngine *qmlEngine, QJSEngine *jsEngine);

    bool checkDirs() const;

#ifdef Q_OS_ANDROID
    Q_INVOKABLE void startSpeechRecognizer() const;

    Q_INVOKABLE void sendNotification(const QString &s) const;
#endif

    QString message() const;

Q_SIGNALS:
#ifdef Q_OS_ANDROID
    void speechRecognized(const QString &result);
#endif

    void messageChanged(const QString &message);

public Q_SLOTS:
    void setMessage(const QString &message);

private:
    explicit AppData(QObject *parent = nullptr);
    Q_DISABLE_COPY(AppData)

    QString m_message;
};

#endif // APPDATA_H
