#include "visioncamera.h"
#include <QDebug>

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
}

void VisionCamera::yorosiku(void) {

    cImage->captureToFile("try.jpg");

    qDebug("Image OK");

}
