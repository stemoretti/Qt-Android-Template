import QtQuick

import BaseUI as UI

import QtAndroidTemplate

UI.App {
    id: root

    title: Qt.application.displayName
    width: 360
    height: 480

    initialPage: "qrc:/qml/MainPage.qml"

    Component.onCompleted: {
        UI.Style.primaryColor = Qt.binding(function() { return GlobalSettings.primaryColor })
        UI.Style.accentColor = Qt.binding(function() { return GlobalSettings.accentColor })
        UI.Style.isDarkTheme = Qt.binding(function() { return GlobalSettings.darkTheme })
        UI.Style.theme = Qt.binding(function() { return GlobalSettings.darkTheme ? "Dark" : "Light" })
    }
}
