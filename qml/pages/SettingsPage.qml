import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.5
import "../ekke/common"
import "../common"
import "../languages.js" as JS

AppStackPage {
    title: qsTr("Settings")
    padding: 10

    Flickable {
        contentHeight: settingsPane.implicitHeight
        anchors.fill: parent

        Pane {
            id: settingsPane

            anchors.fill: parent

            ColumnLayout {
                width: parent.width

                LabelBody {
                    leftPadding: 10
                    text: qsTr("Theme:")
                }
                Pane {
                    topPadding: 0
                    Layout.fillWidth: true
                    Button {
                        text: isDarkTheme ? qsTr("Dark Theme") : qsTr("Light Theme")
                        onClicked: appSettings.darkTheme = !appSettings.darkTheme
                    }
                }

                LabelBody {
                    leftPadding: 10
                    text: qsTr("Primary Color:")
                }
                Pane {
                    topPadding: 0
                    Layout.fillWidth: true
                    ColorComboBox {
                        width: parent.width
                    }
                }

                LabelBody {
                    leftPadding: 10
                    text: qsTr("Accent Color:")
                }
                Pane {
                    topPadding: 0
                    Layout.fillWidth: true
                    ColorComboBox {
                        width: parent.width
                        selectAccentColor: true
                        currentColor: accentColor
                    }
                }

                HorizontalDivider { }

                LabelBody {
                    leftPadding: 10
                    text: qsTr("Language:")
                }
                Pane {
                    topPadding: 0
                    Layout.fillWidth: true
                    ComboBox {
                        width: parent.width
                        model: appTranslations
                        displayText: JS.getLanguageFromCode(currentText)
                        popup.modal: true
                        popup.dim: true
                        delegate: ItemDelegate {
                            width: parent.width
                            implicitHeight: 40
                            text: JS.getLanguageFromCode(modelData)
                            onClicked: appSettings.language = modelData
                        }
                        Component.onCompleted: {
                            currentIndex = model.indexOf(appSettings.language)
                        }
                    }
                }

                LabelBody {
                    leftPadding: 10
                    text: qsTr("Country:")
                }
                Pane {
                    topPadding: 0
                    Layout.fillWidth: true
                    ComboBox {
                        width: parent.width
                        model: JS.regions.map(function (o) { return o.code })
                        displayText: JS.getRegionFromCode(currentText)
                        popup.modal: true
                        popup.dim: true
                        delegate: ItemDelegate {
                            width: parent.width
                            implicitHeight: 40
                            text: JS.getRegionFromCode(modelData)
                            onClicked: appSettings.region = modelData
                        }
                        Component.onCompleted: {
                            currentIndex = model.indexOf(appSettings.region)
                        }
                    }
                }
            }
        }
    }
}
