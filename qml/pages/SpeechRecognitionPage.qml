import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQml
import "../common"

import AppData

AppStackPage {
    title: qsTr("Speech Recognition")
    padding: 6

    rightButtons: [
        Action {
            icon.source: "image://icon/mic"
            onTriggered: AppData.startSpeechRecognizer();
        }
    ]

    Connections {
        target: AppData
        function onSpeechRecognized(result) { speechTextArea.text = result }
    }

    Flickable {
        contentHeight: mainPane.implicitHeight
        anchors.fill: parent

        Pane {
            id: mainPane

            anchors.fill: parent

            ColumnLayout {
                width: parent.width

                Pane {
                    topPadding: 0
                    leftPadding: 10
                    rightPadding: 10
                    Layout.fillWidth: true
                    TextArea {
                        id: speechTextArea
                        leftPadding: 10
                        rightPadding: 10
                        textFormat: TextEdit.PlainText
                        wrapMode: TextEdit.WordWrap
                        anchors.fill: parent
                    }
                }
            }
        }
    }
}
