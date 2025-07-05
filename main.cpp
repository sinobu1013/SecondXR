// Copyright (C) 2024 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <opencv2/opencv.hpp>
#include "visioncamera.h"

int main(int argc, char *argv[])
{
    qputenv("QT_QUICK_CONTROLS_STYLE", "Basic");

    QGuiApplication app(argc, argv);

    QCoreApplication::setApplicationName("Qt SecondXR");
    QCoreApplication::setOrganizationName("Keima");
    QCoreApplication::setApplicationVersion(QT_VERSION_STR);

    QQmlApplicationEngine engine;

    VisionCamera date;
    engine.rootContext()->setContextProperty("VisionCamera", &date);

    const QUrl url(QStringLiteral("qrc:/Main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
                         if (!obj && url == objUrl)
                             QCoreApplication::exit(-1);
                     }, Qt::QueuedConnection);

    // engine.setInitialProperties({{"visitionCamera", &date}});

    engine.load(url);

    // VisionCamera date;
    // engine.rootContext()->setContextProperty("visitionCamera", &date);

    return app.exec();
}
