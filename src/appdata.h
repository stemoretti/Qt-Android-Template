#ifndef APPDATA_H
#define APPDATA_H

#include <QObject>

class AppData : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString message READ message WRITE setMessage NOTIFY messageChanged)

public:
    virtual ~AppData();

    static AppData &instance();

    bool checkDirs() const;

#ifdef Q_OS_ANDROID
    Q_INVOKABLE
    void startSpeechRecognizer() const;

    Q_INVOKABLE
    void sendNotification(const QString &s) const;
#endif

    //{{{ Properties getters declarations

    QString message() const;

    //}}} Properties getters declarations

signals:
#ifdef Q_OS_ANDROID
    void speechRecognized(const QString &result);
#endif

    //{{{ Properties signals

    void messageChanged(const QString &message);

    //}}} Properties signals

public slots:
    //{{{ Properties setters declarations

    void setMessage(const QString &message);

    //}}} Properties setters declarations

private:
    explicit AppData(QObject *parent = nullptr);
    Q_DISABLE_COPY(AppData)

    //{{{ Properties declarations

    QString m_message;

    //}}} Properties declarations
};

#endif // APPDATA_H
