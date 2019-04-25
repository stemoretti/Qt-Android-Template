import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3
import "common"
import "ekke/common"
import "pages"

App {
    id: appWindow

    title: "Android Qml Template"
    header: pageStack.currentItem.appToolBar

    StackView {
        id: pageStack
        anchors.fill: parent
        initialItem: HomePage { }
        onCurrentItemChanged: {
            if (currentItem) {
                currentItem.canNavigateBack = depth > 1
                currentItem.forceActiveFocus()
            }
        }
    }

    Drawer {
        id: navDrawer

        interactive: pageStack.depth === 1
        width: Math.min(240,  Math.min(appWindow.width, appWindow.height) / 3 * 2 )
        height: appWindow.height

        onAboutToShow: menuColumn.enabled = true

        Flickable {
            anchors.fill: parent
            contentHeight: menuColumn.implicitHeight
            boundsBehavior: Flickable.StopAtBounds

            ColumnLayout {
                id: menuColumn

                anchors { left: parent.left; right: parent.right }
                spacing: 0

                Rectangle {
                    id: topItem
                    height: 140
                    color: primaryColor
                    Layout.fillWidth: true
                    Text {
                        text: appWindow.title
                        color: textOnPrimary
                        font.pixelSize: fontSizeHeadline
                        wrapMode: Text.WordWrap
                        anchors {
                            left: parent.left
                            right: parent.right
                            bottom: parent.bottom
                            margins: 25
                        }
                    }
                }

                Repeater {
                    id: pageList

                    model: ListModel {
                        ListElement {
                            iconUrl: "image://icon/mic"
                            text: qsTr("Speech Recognition")
                            page: "pages/SpeechRecognitionPage.qml"
                        }
                        ListElement {
                            iconUrl: "image://icon/settings"
                            text: qsTr("Settings")
                            page: "pages/SettingsPage.qml"
                        }
                        ListElement {
                            iconUrl: "image://icon/info"
                            text: qsTr("About")
                            page: "pages/AboutPage.qml"
                        }
                    }

                    delegate: ItemDelegate {
                        icon.source: iconUrl
                        text: model.text
                        Layout.fillWidth: true
                        onClicked: {
                            // Disable, or a double click will push the page twice.
                            menuColumn.enabled = false
                            navDrawer.close()
                            pageStack.push(Qt.resolvedUrl(model.page))
                        }
                    }
                }
            }
        }
    }

    Connections {
        target: Qt.application
        onStateChanged: {
            if (Qt.application.state === Qt.ApplicationSuspended) {
                appSettings.writeSettingsFile()
            }
        }
    }
}
