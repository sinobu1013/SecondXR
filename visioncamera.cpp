#include "visioncamera.h"
#include <QDebug>
#include <QStandardPaths>
#include <QFile>
#include <QDir>

VisionCamera::VisionCamera(QObject *parent)
    : QObject{parent}
{
    qDebug("hello world");
    int i = 0;
    const QList<QCameraDevice> cameras = QMediaDevices::videoInputs();
    for (const QCameraDevice &cameraDevice: cameras) {
        i++;
        if(i == 1) continue;
        qDebug() << cameraDevice;
        if(cameraDevice.position() == QCameraDevice::BackFace) {
            camera = new QCamera(cameraDevice);
            break;
        }
    }

    camera->start();
    capu = new QMediaCaptureSession();
    capu->setCamera(camera);
    cImage = new QImageCapture();
    capu->setImageCapture(cImage);

    QString saveDirectory = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QString fileName = "try.jpg";
    QDir dir(saveDirectory);
    if(!dir.exists()) {
        dir.mkpath(".");
    }
    filePath = dir.filePath(fileName);
    m_imageSource = QUrl::fromLocalFile(filePath);
    qDebug() << "url2 :" << m_imageSource;

    connect(cImage, &QImageCapture::errorOccurred, this,
            [](int id, QImageCapture::Error error, const QString &errorString) {
                Q_UNUSED(id);
                qWarning() << "Image capture FAILED! Error:" << errorString << "(" << error << ")";
            });

    connect(cImage, &QImageCapture::imageCaptured, this, &VisionCamera::hello);


}

void VisionCamera::hello(int id, const QImage &preview) {
    qDebug() << "Image captured! ID:" << id << "Size:" << preview.size() << "youkoso!!!!!";
    // 必要であれば、ここで preview イメージを処理する

    emit imageSourceChanged();
}

void VisionCamera::yorosiku(void) {

    if(cImage->isReadyForCapture()) {
        cImage->captureToFile("try.jpg");

    }

    qDebug() << "Image OK : " << cImage->isReadyForCapture();

}

QUrl VisionCamera::imageSource() const {
    qDebug() << "url: " << m_imageSource;
    return m_imageSource;
}
