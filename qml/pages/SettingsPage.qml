import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../common"
import "../popups"
import "../languages.js" as JS

import Settings
import System

AppStackPage {
    title: qsTr("Settings")
    padding: 0

    Flickable {
        contentHeight: settingsPane.implicitHeight
        anchors.fill: parent

        Pane {
            id: settingsPane

            anchors.fill: parent
            padding: 0

            ColumnLayout {
                width: parent.width
                spacing: 0

                SettingsItem {
                    title: qsTr("Dark Theme")
                    subtitle: Settings.darkTheme ?
                                  qsTr("Dark theme is enabled") :
                                  qsTr("Dark theme is disabled")
                    check.visible: true
                    check.checked: Settings.darkTheme
                    check.onClicked: Settings.darkTheme = !Settings.darkTheme
                    onClicked: check.clicked()
                }

                SettingsItem {
                    title: qsTr("Primary Color")
                    subtitle: primaryColorPopup.currentColorName
                    onClicked: primaryColorPopup.open()
                }

                SettingsItem {
                    title: qsTr("Accent Color")
                    subtitle: accentColorPopup.currentColorName
                    onClicked: accentColorPopup.open()
                }

                HorizontalDivider { }

                SettingsItem {
                    title: qsTr("Language")
                    subtitle: JS.getLanguageFromCode(Settings.language)
                    onClicked: languagePopup.open()
                }

                SettingsItem {
                    property string name: JS.getCountryFromCode(Settings.country)
                    property string nativeName: JS.getCountryFromCode(Settings.country, "native")

                    title: qsTr("Country")
                    subtitle: nativeName + ((name !== nativeName) ? " (" + name + ")" : "")
                    onClicked: push(Qt.resolvedUrl("SettingsContinentsPage.qml"))
                }
            }
        }
    }

    ColorSelectionPopup {
        id: primaryColorPopup
        currentColor: Settings.primaryColor
        onColorSelected: function(c) { Settings.primaryColor = c }
    }

    ColorSelectionPopup {
        id: accentColorPopup
        selectAccentColor: true
        currentColor: Settings.accentColor
        onColorSelected: function(c) { Settings.accentColor = c }
    }

    ListPopup {
        id: languagePopup

        model: System.translations()
        delegateFunction: JS.getLanguageFromCode
        onClicked: function(data, index) {
            Settings.language = data
            currentIndex = index
            close()
        }
        Component.onCompleted: {
            currentIndex = model.indexOf(Settings.language)
        }
    }
}
