cmake_minimum_required(VERSION 3.19)

project(qt-android-template VERSION 0.1 LANGUAGES CXX)

add_subdirectory(external/BaseUI)

find_package(Qt6 COMPONENTS Core Gui Qml Quick QuickControls2 LinguistTools REQUIRED)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

qt_add_executable(qt-android-template
    src/main.cpp
)

set_property(TARGET qt-android-template APPEND PROPERTY
    QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android"
)

target_include_directories(qt-android-template PRIVATE "${CMAKE_SOURCE_DIR}/src")

target_compile_definitions(qt-android-template
    PRIVATE
        $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>
)

target_link_libraries(qt-android-template
    PRIVATE
        Qt::Core
        Qt::Gui
        Qt::Qml
        Qt::Quick
        Qt::QuickControls2
        baseui
)

set(qml_files
    qml/InfoPage.qml
    qml/MainPage.qml
    qml/main.qml
    qml/SettingsPage.qml
)

qt_add_translations(qt-android-template
    TS_FILES
        translations/qt-android-template_it.ts
    SOURCES
        ${qml_files}
    LUPDATE_OPTIONS
        -no-obsolete
)

qt_add_qml_module(qt-android-template
    URI QtAndroidTemplate
    VERSION 1.0
    QML_FILES
        ${qml_files}
    SOURCES
        src/globalsettings.cpp
        src/globalsettings.h
    NO_RESOURCE_TARGET_PATH
)

set(QML_IMPORT_PATH "${CMAKE_SOURCE_DIR}/baseui/qml"
    CACHE STRING "Qt Creator extra qml import paths" FORCE
)
