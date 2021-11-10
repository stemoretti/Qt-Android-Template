import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Settings

AppStackPage {
    title: qsTr("Settings")
    padding: 0

    function getLanguageFromCode(code)
    {
        var languages = [
            { "code": "en", "name": "English", "nativeName": "English" },
            { "code": "it", "name": "Italian", "nativeName": "Italiano" },
        ]
        var codes = languages.map(o => o.code)
        var i = codes.indexOf(code)

        if (i < 0)
            return ""

        var name = languages[i].name
        var nativeName = languages[i].nativeName

        if (name !== nativeName) {
            name = nativeName + " (" + name + ")"
        }

        return name
    }

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
                    subtitle: getLanguageFromCode(Settings.language)
                    onClicked: languagePopup.open()
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

        model: Settings.translations()
        delegateFunction: getLanguageFromCode
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
