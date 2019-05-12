#include "iconprovider.h"

#include <QFile>
#include <QFont>
#include <QJsonDocument>
#include <QPainter>

IconProvider::IconProvider(const QString &fontName, const QString &iconCodes)
    : QQuickImageProvider(QQuickImageProvider::Image)
    , fontName(fontName)
{
    QFile file(iconCodes);
    if (file.exists() && file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        auto jd = QJsonDocument::fromJson(file.readAll());
        codepoints = jd.object();
    }
}

QImage IconProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
    int width = 48;
    int height = 48;

    if (requestedSize.width() > 0)
        width = requestedSize.width();

    if (requestedSize.height() > 0)
        height = requestedSize.height();

    if (size)
        *size = QSize(width, height);

    QImage image(width, height, QImage::Format_RGBA8888);
    image.fill(QColor(Qt::transparent));

    QFont font(fontName);
    font.setPixelSize(width < height ? width : height);

    QPainter painter(&image);
    painter.setFont(font);
    painter.drawText(0, height,
                     codepoints[id] != QJsonValue::Undefined ? codepoints[id].toString() : "?");
    painter.end();

    return image;
}
