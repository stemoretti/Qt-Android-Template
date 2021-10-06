import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQml.Models
import "../common"

import AppData

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
                        text: AppData.message
                        onEditingFinished: {
                            AppData.message = text
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
                AppData.sendNotification(AppData.message)
            }
        }
    }
}
