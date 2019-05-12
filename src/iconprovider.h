#ifndef ICONPROVIDER_H
#define ICONPROVIDER_H

#include <QQuickImageProvider>
#include <QJsonObject>

class IconProvider : public QQuickImageProvider
{
public:
    explicit IconProvider(const QString &fontName, const QString &iconCodes);

    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize) override;
private:
    QJsonObject codepoints;
    QString fontName;
};

#endif // ICONPROVIDER_H
