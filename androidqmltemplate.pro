TEMPLATE = app

TARGET = androidqmltemplate

QT += qml quick quickcontrols2

CONFIG += c++11

HEADERS += \
    src/settings.h \
    src/appdata.h \
    src/system.h \
    src/iconprovider.h

SOURCES += \
    src/main.cpp \
    src/settings.cpp \
    src/appdata.cpp \
    src/system.cpp \
    src/iconprovider.cpp

OTHER_FILES += \
    LICENSE

RESOURCES += \
    qml.qrc \
    translations.qrc \
    icons.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

# T R A N S L A T I O N S

# if languages are added:
# 1. rebuild project to generate *.qm
# 2. add existing .qm files to translations.qrc

# if changes to translatable strings:
# 1. Run Tools-External-Linguist-Update
# 2. Run Linguist and do translations
# 3. Build and run on iOS and Android to verify translations
# 4. Optional: if translations not done: Run Tools-External-Linguist-Release

# Supported languages
LANGUAGES = it

# used to create .ts files
defineReplace(prependAll) {
    for(a,$$1):result += $$2$${a}$$3
    return($$result)
}
# Available translations
#tsroot = $$join(TARGET,,,.ts)
tstarget = $$join(TARGET,,,_)
#TRANSLATIONS = $$PWD/translations/$$tsroot
TRANSLATIONS = $$prependAll(LANGUAGES, $$PWD/translations/$$tstarget, .ts)
# run LRELEASE to generate the qm files
qtPrepareTool(LRELEASE, lrelease)
for(tsfile, TRANSLATIONS) {
    command = $$LRELEASE $$tsfile
    system($$command)|error("Failed to run: $$command")
}

DEFINES += 'AVAILABLE_TRANSLATIONS=\\\"\'$$LANGUAGES\'\\\"'

android {
    QT += androidextras

    # Android package sources
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

    DISTFILES += \
        android/AndroidManifest.xml \
        android/build.gradle \
        android/gradle/wrapper/gradle-wrapper.jar \
        android/gradle/wrapper/gradle-wrapper.properties \
        android/gradlew \
        android/gradlew.bat \
        android/res/values/libs.xml \
        android/src/com/github/stemoretti/androidqmltemplate/MainActivity.java
}

# Default rules for deployment.
include(deployment.pri)
