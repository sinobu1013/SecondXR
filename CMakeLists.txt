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
SOURCES 3Party/include/onnxruntime/core/common/logging/capture.h 3Party/include/onnxruntime/core/common/logging/isink.h 3Party/include/onnxruntime/core/common/logging/logging.h 3Party/include/onnxruntime/core/common/logging/macros.h 3Party/include/onnxruntime/core/common/logging/severity.h 3Party/include/onnxruntime/core/common/logging/sink_types.h 3Party/include/onnxruntime/core/common/basic_types.h 3Party/include/onnxruntime/core/common/code_location.h 3Party/include/onnxruntime/core/common/common.h 3Party/include/onnxruntime/core/common/const_pointer_container.h 3Party/include/onnxruntime/core/common/denormal.h 3Party/include/onnxruntime/core/common/eigen_common_wrapper.h 3Party/include/onnxruntime/core/common/exceptions.h 3Party/include/onnxruntime/core/common/gpu_profiler_common.h 3Party/include/onnxruntime/core/common/hash_combine.h 3Party/include/onnxruntime/core/common/inlined_containers.h 3Party/include/onnxruntime/core/common/inlined_containers_fwd.h 3Party/include/onnxruntime/core/common/make_string.h 3Party/include/onnxruntime/core/common/narrow.h 3Party/include/onnxruntime/core/common/optional.h 3Party/include/onnxruntime/core/common/parse_string.h 3Party/include/onnxruntime/core/common/profiler_common.h 3Party/include/onnxruntime/core/common/span_utils.h 3Party/include/onnxruntime/core/common/spin_pause.h 3Party/include/onnxruntime/core/common/status.h 3Party/include/onnxruntime/core/common/string_helper.h 3Party/include/onnxruntime/core/eager/ort_kernel_invoker.h 3Party/include/onnxruntime/core/framework/alloc_kind.h 3Party/include/onnxruntime/core/framework/allocator.h 3Party/include/onnxruntime/core/framework/buffer_deleter.h 3Party/include/onnxruntime/core/framework/customregistry.h 3Party/include/onnxruntime/core/framework/data_types.h 3Party/include/onnxruntime/core/framework/data_types_internal.h 3Party/include/onnxruntime/core/framework/endian.h 3Party/include/onnxruntime/core/framework/execution_provider.h 3Party/include/onnxruntime/core/framework/float16.h 3Party/include/onnxruntime/core/framework/float8.h 3Party/include/onnxruntime/core/framework/framework_common.h 3Party/include/onnxruntime/core/framework/framework_provider_common.h 3Party/include/onnxruntime/core/framework/func_api.h 3Party/include/onnxruntime/core/framework/int4.h 3Party/include/onnxruntime/core/framework/kernel_def_builder.h 3Party/include/onnxruntime/core/framework/kernel_registry.h 3Party/include/onnxruntime/core/framework/op_kernel.h 3Party/include/onnxruntime/core/framework/op_kernel_context.h 3Party/include/onnxruntime/core/framework/op_kernel_info.h 3Party/include/onnxruntime/core/framework/op_node_proto_helper.h 3Party/include/onnxruntime/core/framework/ort_value.h 3Party/include/onnxruntime/core/framework/ortdevice.h 3Party/include/onnxruntime/core/framework/ortmemoryinfo.h 3Party/include/onnxruntime/core/framework/provider_options.h 3Party/include/onnxruntime/core/framework/provider_options_utils.h 3Party/include/onnxruntime/core/framework/provider_shutdown.h 3Party/include/onnxruntime/core/framework/resource_accountant.h 3Party/include/onnxruntime/core/framework/run_options.h 3Party/include/onnxruntime/core/framework/sparse_tensor.h 3Party/include/onnxruntime/core/framework/stream_handles.h 3Party/include/onnxruntime/core/framework/tensor.h 3Party/include/onnxruntime/core/framework/tensor_shape.h 3Party/include/onnxruntime/core/framework/to_tensor_proto_element_type.h 3Party/include/onnxruntime/core/graph/basic_types.h 3Party/include/onnxruntime/core/graph/constants.h 3Party/include/onnxruntime/core/graph/function.h 3Party/include/onnxruntime/core/graph/graph.h 3Party/include/onnxruntime/core/graph/graph_nodes.h 3Party/include/onnxruntime/core/graph/graph_viewer.h 3Party/include/onnxruntime/core/graph/indexed_sub_graph.h 3Party/include/onnxruntime/core/graph/model_saving_options.h 3Party/include/onnxruntime/core/graph/node_arg.h 3Party/include/onnxruntime/core/graph/onnx_protobuf.h 3Party/include/onnxruntime/core/graph/schema_registry.h 3Party/include/onnxruntime/core/optimizer/graph_transformer.h 3Party/include/onnxruntime/core/optimizer/graph_transformer_config.h 3Party/include/onnxruntime/core/optimizer/graph_transformer_level.h 3Party/include/onnxruntime/core/optimizer/graph_transformer_utils.h 3Party/include/onnxruntime/core/optimizer/rewrite_rule.h 3Party/include/onnxruntime/core/optimizer/rule_based_graph_transformer.h 3Party/include/onnxruntime/core/platform/windows/TraceLoggingConfig.h 3Party/include/onnxruntime/core/platform/Barrier.h 3Party/include/onnxruntime/core/platform/EigenNonBlockingThreadPool.h 3Party/include/onnxruntime/core/platform/ort_spin_lock.h 3Party/include/onnxruntime/core/platform/threadpool.h 3Party/include/onnxruntime/core/platform/tracing.h 3Party/include/onnxruntime/core/providers/acl/acl_provider_factory.h 3Party/include/onnxruntime/core/providers/armnn/armnn_provider_factory.h 3Party/include/onnxruntime/core/providers/cann/cann_provider_options.h 3Party/include/onnxruntime/core/providers/coreml/coreml_provider_factory.h 3Party/include/onnxruntime/core/providers/cpu/cpu_provider_factory.h 3Party/include/onnxruntime/core/providers/cuda/cuda_context.h 3Party/include/onnxruntime/core/providers/cuda/cuda_provider_options.h 3Party/include/onnxruntime/core/providers/cuda/cuda_resource.h 3Party/include/onnxruntime/core/providers/dml/dml_provider_factory.h 3Party/include/onnxruntime/core/providers/dnnl/dnnl_provider_options.h 3Party/include/onnxruntime/core/providers/nnapi/nnapi_provider_factory.h 3Party/include/onnxruntime/core/providers/nv_tensorrt_rtx/nv_provider_options.h 3Party/include/onnxruntime/core/providers/openvino/openvino_provider_factory.h 3Party/include/onnxruntime/core/providers/rknpu/rknpu_provider_factory.h 3Party/include/onnxruntime/core/providers/rocm/rocm_context.h 3Party/include/onnxruntime/core/providers/rocm/rocm_resource.h 3Party/include/onnxruntime/core/providers/tensorrt/tensorrt_provider_options.h 3Party/include/onnxruntime/core/providers/tvm/tvm_provider_factory.h 3Party/include/onnxruntime/core/providers/vsinpu/vsinpu_provider_factory.h 3Party/include/onnxruntime/core/providers/webgpu/webgpu_provider_factory.h 3Party/include/onnxruntime/core/providers/winml/winml_provider_factory.h 3Party/include/onnxruntime/core/providers/custom_op_context.h 3Party/include/onnxruntime/core/providers/providers.h 3Party/include/onnxruntime/core/providers/resource.h 3Party/include/onnxruntime/core/session/environment.h 3Party/include/onnxruntime/core/session/experimental_onnxruntime_cxx_api.h 3Party/include/onnxruntime/core/session/experimental_onnxruntime_cxx_inline.h 3Party/include/onnxruntime/core/session/onnxruntime_c_api.h 3Party/include/onnxruntime/core/session/onnxruntime_cxx_api.h 3Party/include/onnxruntime/core/session/onnxruntime_cxx_inline.h 3Party/include/onnxruntime/core/session/onnxruntime_float16.h 3Party/include/onnxruntime/core/session/onnxruntime_lite_custom_op.h 3Party/include/onnxruntime/core/session/onnxruntime_run_options_config_keys.h 3Party/include/onnxruntime/core/session/onnxruntime_session_options_config_keys.h
RESOURCES 3Party/include/onnxruntime/core/platform/windows/readme.txt 3Party/include/onnxruntime/core/session/snippets.dox
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
