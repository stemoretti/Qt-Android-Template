#include "appdata.h"

#include <QDir>
#include <QDebug>
#include <QQmlEngine>

#ifdef Q_OS_ANDROID
#include <QJniObject>
#include <QCoreApplication>
#endif

#include "system.h"

AppData::AppData(QObject *parent)
    : QObject(parent)
    , m_message("Message from C++")
{
    QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);

    if (!checkDirs())
        qFatal("App won't work - cannot create data directory.");
}

AppData::~AppData()
{
}

AppData *AppData::instance()
{
    static AppData s;
    return &s;
}

QObject *AppData::singletonProvider(QQmlEngine *qmlEngine, QJSEngine *jsEngine)
{
    Q_UNUSED(qmlEngine)
    Q_UNUSED(jsEngine)

    return instance();
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
    Q_UNUSED(env)
    Q_UNUSED(obj)

    auto result = QJniObject(text).toString();
    if (!result.isEmpty())
        Q_EMIT AppData::instance()->speechRecognized(result);
}

void AppData::startSpeechRecognizer() const
{
    QJniObject activity = QNativeInterface::QAndroidApplication::context();
    activity.callMethod<void>("getSpeechInput", "()V");
}

void AppData::sendNotification(const QString &s) const
{
    auto javaNotification = QJniObject::fromString(s);
    QJniObject activity = QNativeInterface::QAndroidApplication::context();
    activity.callMethod<void>("notify", "(Ljava/lang/String;)V",
                              javaNotification.object<jstring>());
}
#endif

QString AppData::message() const
{
    return m_message;
}

void AppData::setMessage(const QString &message)
{
    if (m_message == message)
        return;

    m_message = message;
    Q_EMIT messageChanged(m_message);
}
