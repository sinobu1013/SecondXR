#ifndef VISIONCAMERA_H
#define VISIONCAMERA_H

#include <QObject>
#include <QCamera>
#include <QCameraDevice>
#include <QMediaDevices>
#include <QMediaFormat>
#include <QMediaMetaData>
#include <QMediaCaptureSession>
#include <QImageCapture>
#include <QUrl>


class VisionCamera : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QUrl imageSource READ imageSource NOTIFY imageSourceChanged FINAL)
public:
    explicit VisionCamera(QObject *parent = nullptr);
    void hello(int id, const QImage &preview);
    Q_INVOKABLE void yorosiku(void);
    Q_INVOKABLE QUrl imageSource() const;

    QCamera *camera = nullptr;
    QMediaCaptureSession *capu = nullptr;
    QImageCapture *cImage = nullptr;
    QUrl m_imageSource;
    QString filePath;

signals:
    void imageSourceChanged();
};

#endif // VISIONCAMERA_H
