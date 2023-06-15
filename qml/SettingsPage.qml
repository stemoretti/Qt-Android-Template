import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import BaseUI as UI

import QtAndroidTemplate

UI.AppStackPage {
    id: root

    title: qsTr("Settings")
    padding: 0

    leftButton: Action {
        icon.source: UI.Icons.arrow_back
        onTriggered: root.back()
    }

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

                UI.SettingsSectionTitle { text: qsTr("Theme and colors") }

                UI.SettingsCheckItem {
                    title: qsTr("Dark Theme")
                    checkState: GlobalSettings.darkTheme ? Qt.Checked : Qt.Unchecked
                    onClicked: GlobalSettings.darkTheme = !GlobalSettings.darkTheme
                    Layout.fillWidth: true
                }

                UI.SettingsItem {
                    title: qsTr("Primary color")
                    subtitle: colorDialog.getColorName(GlobalSettings.primaryColor)
                    onClicked: {
                        colorDialog.selectAccentColor = false
                        colorDialog.open()
                    }
                }

                UI.SettingsItem {
                    title: qsTr("Accent color")
                    subtitle: colorDialog.getColorName(GlobalSettings.accentColor)
                    onClicked: {
                        colorDialog.selectAccentColor = true
                        colorDialog.open()
                    }
                }

                UI.SettingsSectionTitle { text: qsTr("Localization") }

                UI.SettingsItem {
                    title: qsTr("Language")
                    subtitle: getLanguageFromCode(GlobalSettings.language)
                    onClicked: languagePopup.open()
                }
            }
        }
    }

    UI.OptionsDialog {
        id: colorDialog

        property bool selectAccentColor: false

        function getColorName(color) {
            var filtered = colorDialog.model.filter((c) => {
                return Material.color(c.bg) === color
            })
            return filtered.length ? filtered[0].name : ""
        }

        title: selectAccentColor ? qsTr("Choose accent color") : qsTr("Choose primary color")
        model: [
            { name: "Material Red", bg: Material.Red },
            { name: "Material Pink", bg: Material.Pink },
            { name: "Material Purple", bg: Material.Purple },
            { name: "Material DeepPurple", bg: Material.DeepPurple },
            { name: "Material Indigo", bg: Material.Indigo },
            { name: "Material Blue", bg: Material.Blue },
            { name: "Material LightBlue", bg: Material.LightBlue },
            { name: "Material Cyan", bg: Material.Cyan },
            { name: "Material Teal", bg: Material.Teal },
            { name: "Material Green", bg: Material.Green },
            { name: "Material LightGreen", bg: Material.LightGreen },
            { name: "Material Lime", bg: Material.Lime },
            { name: "Material Yellow", bg: Material.Yellow },
            { name: "Material Amber", bg: Material.Amber },
            { name: "Material Orange", bg: Material.Orange },
            { name: "Material DeepOrange", bg: Material.DeepOrange },
            { name: "Material Brown", bg: Material.Brown },
            { name: "Material Grey", bg: Material.Grey },
            { name: "Material BlueGrey", bg: Material.BlueGrey }
        ]
        delegate: RowLayout {
            spacing: 0

            Rectangle {
                visible: colorDialog.selectAccentColor
                color: UI.Style.primaryColor
                Layout.margins: 0
                Layout.leftMargin: 10
                Layout.minimumWidth: 48
                Layout.minimumHeight: 32
            }

            Rectangle {
                color: Material.color(modelData.bg)
                Layout.margins: 0
                Layout.leftMargin: colorDialog.selectAccentColor ? 0 : 10
                Layout.minimumWidth: 32
                Layout.minimumHeight: 32
            }

            RadioButton {
                checked: {
                    if (colorDialog.selectAccentColor)
                        Material.color(modelData.bg) === UI.Style.accentColor
                    else
                        Material.color(modelData.bg) === UI.Style.primaryColor
                }
                text: modelData.name
                Layout.leftMargin: 4
                onClicked: {
                    colorDialog.close()
                    if (colorDialog.selectAccentColor)
                        GlobalSettings.accentColor = Material.color(modelData.bg)
                    else
                        GlobalSettings.primaryColor = Material.color(modelData.bg)
                }
            }
        }
    }

    UI.OptionsDialog {
        id: languagePopup

        title: qsTr("Language")
        model: GlobalSettings.translations()
        delegate: RadioButton {
            checked: modelData === GlobalSettings.language
            text: root.getLanguageFromCode(modelData)
            onClicked: { languagePopup.close(); GlobalSettings.language = modelData }
        }
    }
}
