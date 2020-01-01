#ifndef SYSTEM_H
#define SYSTEM_H

#include <QObject>

class System : public QObject
{
    Q_OBJECT

public:
    static QString dataRoot();
    static QString language();
    static QString locale();
    static QStringList translations();

private:
    explicit System(QObject *parent = nullptr);
};

#endif // SYSTEM_H
