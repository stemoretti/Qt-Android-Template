import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

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

    Pane {
        id: mainPane

        anchors.fill: parent

        ColumnLayout {
            width: parent.width

            LabelBody {
                leftPadding: 10
                rightPadding: 10
                text: Qt.application.name
            }
        }
    }

    Drawer {
        id: navDrawer

        interactive: root.stack.currentItem == root
        width: Math.min(240,  Math.min(parent.width, parent.height) / 3 * 2 )
        height: parent.height

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
                    color: Style.primaryColor
                    Layout.fillWidth: true

                    Text {
                        text: Qt.application.name
                        color: Style.textOnPrimary
                        font.pixelSize: Style.fontSizeHeadline
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
                            iconUrl: "image://icon/settings"
                            text: QT_TR_NOOP("Settings")
                            page: "SettingsPage.qml"
                        }
                        ListElement {
                            iconUrl: "image://icon/info"
                            text: QT_TR_NOOP("About")
                            page: "AboutPage.qml"
                        }
                    }

                    delegate: ItemDelegate {
                        icon.source: iconUrl
                        text: qsTr(model.text)
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
            text: qsTr("Item")
        }
    }
}
