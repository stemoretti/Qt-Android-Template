import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.5
import QtQml 2.12
import "../common"
import "../popups"

AppStackPage {
    title: qsTr("Speech Recognition")
    padding: 6

    rightButtons: [
        Action {
            icon.source: "image://icon/mic"
            onTriggered: appData.startSpeechRecognizer();
        }
    ]

    Connections {
        target: appData
        onSpeechRecognized: speechTextArea.text = result
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
//                        selectByMouse: false
                    }
                }
            }
        }
    }
}
