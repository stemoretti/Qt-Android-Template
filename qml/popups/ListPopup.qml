import QtQuick
import QtQuick.Controls

BaseModalPopup {
    id: root

    property alias model: internalList.model
    property alias currentIndex: internalList.currentIndex
    property var delegateFunction

    signal clicked(var data, int index)

    implicitWidth: appWindow.width * 0.9
    contentHeight: internalList.contentHeight

    ListView {
        id: internalList
        anchors.fill: parent
        clip: true
        highlightMoveDuration: 0
        delegate: ItemDelegate {
            id: internalDelegate
            width: parent.width
            implicitHeight: 40
            text: delegateFunction(modelData)
            onClicked: root.clicked(modelData, index)
        }
        onCurrentIndexChanged: {
            internalList.positionViewAtIndex(currentIndex, ListView.Center)
        }
    }
}
