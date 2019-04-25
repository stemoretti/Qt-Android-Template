#include "appdata.h"

#include <QDir>
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonArray>
#include <QDebug>

#ifdef Q_OS_ANDROID
#include <QAndroidJniObject>
#include <QtAndroid>
#endif

#include "system.h"

AppData::AppData(QObject *parent)
    : QObject(parent)
    , m_message("Message from C++")
{
    if (!checkDirs())
        qFatal("App won't work - cannot create data directory.");
}

AppData::~AppData()
{
}

AppData &AppData::instance()
{
    static AppData instance;

    return instance;
}

bool AppData::checkDirs() const
{
    QDir myDir;
    auto path = System::dataRoot();

    if (!myDir.exists(path)) {
        if (!myDir.mkpath(path)) {
            qWarning() << "Cannot create" << path;
            return false;
        }
        qDebug() << "Created directory" << path;
    }

    return true;
}

#ifdef Q_OS_ANDROID
extern "C" JNIEXPORT void JNICALL
Java_com_github_stemoretti_androidqmltemplate_MainActivity_sendResult(JNIEnv *env,
                                                                      jobject obj,
                                                                      jstring text)
{
    Q_UNUSED(env);
    Q_UNUSED(obj);
    auto result = QAndroidJniObject(text).toString();
    if (!result.isEmpty())
        emit AppData::instance().speechRecognized(result);
}

void AppData::startSpeechRecognizer() const
{
    QtAndroid::androidActivity().callMethod<void>("getSpeechInput", "()V");
}

void AppData::sendNotification(const QString &s) const
{
    auto javaNotification = QAndroidJniObject::fromString(s);
    QtAndroid::androidActivity().callMethod<void>("notify", "(Ljava/lang/String;)V",
                                                  javaNotification.object<jstring>());
}
#endif

//{{{ Properties getters/setters definitions

QString AppData::message() const
{
    return m_message;
}

void AppData::setMessage(const QString &message)
{
    if (m_message == message)
        return;

    m_message = message;
    emit messageChanged(m_message);
}

//}}} Properties getters/setters definitions
