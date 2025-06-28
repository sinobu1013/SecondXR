#include "visioncamera.h"
#include <QDebug>

VisionCamera::VisionCamera(QObject *parent)
    : QObject{parent}
{
    qDebug("hello world");
}

void VisionCamera::hello() {
    qDebug("youkoso!!!!!");
}
