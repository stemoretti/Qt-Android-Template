import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import "common"
import "pages"

App {
    id: appWindow

    title: "Android Qml Template"
    header: pageStack.currentItem ? pageStack.currentItem.appToolBar : null
    width: 360
    height: 480

    StackView {
        id: pageStack
        anchors.fill: parent
        initialItem: "./pages/HomePage.qml"
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
}
