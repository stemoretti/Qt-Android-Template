import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3
import QtQml.Models 2.12
import "../common"
import "../popups"

AppStackPage {
    id: root

    title: qsTr("Home Page")

    leftButton: Action {
        icon.source: "image://icon/menu"
        onTriggered: navDrawer.open()
    }

    rightButtons: [
        Action {
            icon.source: "image://icon/more_vert"
            onTriggered: optionsMenu.open()
        }
    ]

    Flickable {
        contentHeight: mainPane.implicitHeight
        anchors.fill: parent

        Pane {
            id: mainPane

            anchors.fill: parent

            ColumnLayout {
                width: parent.width

                LabelBody {
                    leftPadding: 10
                    rightPadding: 10
                    text: qsTr("Message for notification:")
                }
                Pane {
                    topPadding: 0
                    leftPadding: 10
                    rightPadding: 10
                    Layout.fillWidth: true
                    TextField {
                        leftPadding: 10
                        rightPadding: 10
                        anchors.fill: parent
                        selectByMouse: true
                        inputMethodHints: Qt.ImhNoPredictiveText
                        text: appData.message
                        onEditingFinished: {
                            appData.message = text
                            focus = false
                        }
                    }
                }
            }
        }
    }

    Menu {
        id: optionsMenu
        modal: true
        dim: false
        closePolicy: Popup.CloseOnPressOutside | Popup.CloseOnEscape
        x: parent.width - width - 6
        y: -appToolBar.height + 6
        transformOrigin: Menu.TopRight

        onAboutToShow: enabled = true
        onAboutToHide: currentIndex = -1 // reset highlighting

        MenuItem {
            text: qsTr("Send Notification")
            onTriggered: {
                appData.sendNotification(appData.message)
            }
        }
    }
}
