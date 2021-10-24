import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../common"

AppStackPage {
    title: qsTr("About")
    padding: 10

    Flickable {
        contentHeight: aboutPane.implicitHeight
        anchors.fill: parent

        Pane {
            id: aboutPane

            anchors.fill: parent

            ColumnLayout {
                width: parent.width

                LabelTitle {
                    text: "Android Qml Template"
                    Layout.alignment: Qt.AlignHCenter
                }

                LabelBody {
                    text: "<a href='http://github.com/stemoretti/androidqmltemplate'>"
                          + "github.com/stemoretti/androidqmltemplate</a>"
                    linkColor: Style.isDarkTheme ? "lightblue" : "blue"
                    Layout.alignment: Qt.AlignHCenter
                    onLinkActivated: Qt.openUrlExternally(link)
                }

                HorizontalDivider { }

                LabelSubheading {
                    text: qsTr("This app is based on the following software:")
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }

                LabelBody {
                    text: "Qt 6<br>"
                          + "Copyright 2008-2021 The Qt Company Ltd."
                          + " All rights reserved."
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }

                LabelBody {
                    text: "Qt is under the LGPLv3 license."
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }

                HorizontalDivider { }

                LabelBody {
                    text: "<a href='https://material.io/tools/icons/'"
                          + "title='Material Design'>Material Design</a>"
                          + " icons are under Apache license version 2.0"
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                    linkColor: Style.isDarkTheme ? "lightblue" : "blue"
                    onLinkActivated: Qt.openUrlExternally(link)
                }

                HorizontalDivider { }

                LabelBody {
                    text: "<a href='https://www.github.com/ekke'>github.com/ekke</a>"
                    linkColor: Style.isDarkTheme ? "lightblue" : "blue"
                    onLinkActivated: Qt.openUrlExternally(link)
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
}
