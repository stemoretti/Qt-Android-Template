import QtQuick
import QtQuick.Controls

Popup {
    id: root

    modal: true
    dim: true
    padding: 0
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2 - appToolBar.height / 2
    implicitWidth: Math.min(contentWidth, appWindow.width * 0.9)
    implicitHeight: Math.min(contentHeight, appWindow.height * 0.9)
}
