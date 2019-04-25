#include "iconprovider.h"

#include <QByteArray>
#include <QFile>
#include <QDebug>

#define NANOSVG_IMPLEMENTATION
#include "nanosvg/src/nanosvg.h"
#define NANOSVGRAST_IMPLEMENTATION
#include "nanosvg/src/nanosvgrast.h"

IconProvider::IconProvider()
    : QQuickImageProvider(QQuickImageProvider::Image)
{
}

QImage IconProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
    QImage image;
    int width, height;
    NSVGimage *parse;
    NSVGrasterizer *rast;

    QFile path(":icons/" + id + ".svg");
    if (path.exists() && path.open(QFile::ReadOnly)) {
        QByteArray ba(path.readAll());

        parse = nsvgParse(ba.data(), "px", 96.0f);
        if (parse) {
            rast = nsvgCreateRasterizer();
            if (rast) {
                width = static_cast<int>(parse->width);
                height = static_cast<int>(parse->height);

                if (size)
                    *size = QSize(width, height);

                QImage img(width, height, QImage::Format_RGBA8888);
                nsvgRasterize(rast, parse, 0, 0, 1, img.bits(), width, height, width * 4);

                if (requestedSize.width() > 0)
                    width = requestedSize.width();

                if (requestedSize.height() > 0)
                    height = requestedSize.height();

                image = img.scaled(width, height, Qt::KeepAspectRatio, Qt::SmoothTransformation);
            }
            nsvgDeleteRasterizer(rast);
        }
        nsvgDelete(parse);
    }

    return image;
}

