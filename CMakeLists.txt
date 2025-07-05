# Copyright (C) 2024 The Qt Company Ltd.
# SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

cmake_minimum_required(VERSION 3.16)
project(SecondXR LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(OpenCV_DIR "C:/OpenCV-android-sdk/sdk/native/jni")

find_package(Qt6 COMPONENTS Core Gui Quick Quick3D Quick3DXr Multimedia)
find_package(OpenCV REQUIRED)

qt6_policy(SET QTP0002 NEW)

qt_add_executable(SecondXR
    MANUAL_FINALIZATION
    main.cpp
    android/AndroidManifest.xml
)

set_target_properties(SecondXR PROPERTIES
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE TRUE
)

target_link_libraries(SecondXR PUBLIC
    Qt::Core
    Qt::Gui
    Qt::Quick
    Qt::Quick3D
    Qt::Quick3DXr
    Qt6::Multimedia
    ${OpenCV_LIBRARIES}
)

qt_add_qml_module(SecondXR
    URI Example
    VERSION 1.0
    QML_FILES
        Main.qml
    RESOURCES
        meshes/teapot.mesh
    NO_RESOURCE_TARGET_PATH
    SOURCES visioncamera.h visioncamera.cpp
    QML_FILES Point.qml
)

if(ANDROID)
    set_property(TARGET SecondXR APPEND PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/android)
endif()

if (APPLE AND CMAKE_SYSTEM_NAME STREQUAL "visionOS")
    set_target_properties(SecondXR PROPERTIES
        MACOSX_BUNDLE_GUI_IDENTIFIER io.qt.SecondXR
        MACOSX_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_SOURCE_DIR}/visionos/MacOSXBundleInfo.plist.in
    )
endif()

qt_finalize_executable(SecondXR)

install(TARGETS SecondXR
    BUNDLE  DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

qt_generate_deploy_qml_app_script(
    TARGET SecondXR
    OUTPUT_SCRIPT deploy_script
    MACOS_BUNDLE_POST_BUILD
    NO_UNSUPPORTED_PLATFORM_ERROR
    DEPLOY_USER_QML_MODULES_ON_UNSUPPORTED_PLATFORM
)
install(SCRIPT ${deploy_script})
