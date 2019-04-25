#ifndef ICONPROVIDER_H
#define ICONPROVIDER_H

#include <QQuickImageProvider>

class IconProvider : public QQuickImageProvider
{
public:
    explicit IconProvider();

    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize) override;
};

#endif // ICONPROVIDER_H
