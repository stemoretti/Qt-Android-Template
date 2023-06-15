import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material

import BaseUI as UI

UI.AppStackPage {
    id: root

    title: qsTr("Main Page")

    leftButton: Action {
        icon.source: UI.Icons.menu
        onTriggered: navDrawer.open()
    }

    rightButtons: [
        Action {
            icon.source: UI.Icons.more_vert
            onTriggered: optionsMenu.open()
        }
    ]

    Pane {
        id: mainPane

        anchors.fill: parent

        ColumnLayout {
            width: parent.width

            UI.LabelBody {
                leftPadding: 10
                rightPadding: 10
                text: Qt.application.name
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

    Drawer {
        id: navDrawer

        interactive: stack.depth === 1
        width: Math.min(240,  Math.min(parent.width, parent.height) / 3 * 2 )
        height: parent.height

        onAboutToShow: menuColumn.enabled = true
        topPadding: 0
        bottomPadding: 0

        Flickable {
            anchors.fill: parent
            contentHeight: menuColumn.implicitHeight
            boundsBehavior: Flickable.StopAtBounds

            ColumnLayout {
                id: menuColumn

                anchors { left: parent.left; right: parent.right }
                spacing: 0

                Label {
                    text: Qt.application.displayName
                    color: Material.foreground
                    font.pixelSize: UI.Style.fontSizeTitle
                    padding: (root.appToolBar.implicitHeight - contentHeight) / 2
                    leftPadding: 20
                    Layout.fillWidth: true
                }

                UI.HorizontalListDivider {}

                Repeater {
                    id: pageList

                    model: [
                        {
                            icon: UI.Icons.settings,
                            text: QT_TR_NOOP("Settings"),
                            page: "SettingsPage.qml"
                        },
                        {
                            icon: UI.Icons.info_outline,
                            text: QT_TR_NOOP("Info"),
                            page: "InfoPage.qml"
                        }
                    ]

                    delegate: ItemDelegate {
                        icon.source: modelData.icon
                        text: qsTr(modelData.text)
                        Layout.fillWidth: true
                        onClicked: {
                            // Disable or a double click will push the page twice.
                            menuColumn.enabled = false
                            navDrawer.close()
                            root.stack.push(Qt.resolvedUrl(modelData.page))
                        }
                    }
                }
            }
        }
    }
}
