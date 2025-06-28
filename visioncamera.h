#ifndef VISIONCAMERA_H
#define VISIONCAMERA_H

#include <QObject>
#include <QCamera>
#include <QCameraDevice>
#include <QMediaDevices>
#include <QMediaFormat>
#include <QMediaCaptureSession>
#include <QImageCapture>


class VisionCamera : public QObject
{
    Q_OBJECT
public:
    explicit VisionCamera(QObject *parent = nullptr);
    void hello(int id, const QImage &preview);
    Q_INVOKABLE void yorosiku(void);

    QCamera *camera = nullptr;
    QMediaCaptureSession *capu = nullptr;
    QImageCapture *cImage = nullptr;

signals:
};

#endif // VISIONCAMERA_H
