#ifndef VISIONCAMERA_H
#define VISIONCAMERA_H

#include <QObject>

class VisionCamera : public QObject
{
    Q_OBJECT
public:
    explicit VisionCamera(QObject *parent = nullptr);
    Q_INVOKABLE void hello(void);

signals:
};

#endif // VISIONCAMERA_H
