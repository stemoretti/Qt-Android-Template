import QtQuick
import QtQuick.Controls

Page {
    id: root

    property StackView stack: StackView.view
    property alias appToolBar: appToolBar
    property alias leftButton: appToolBar.leftButton
    property alias rightButtons: appToolBar.rightButtons

    function pop(item, operation) {
        if (stack.currentItem != root)
            return false

        return stack.pop(item, operation)
    }

    function back() {
        pop()
    }

    Keys.onBackPressed: {
        if (stack.depth > 1) {
            event.accepted = true
            back()
        } else {
            Qt.quit()
        }
    }

    Action {
        id: backAction
        icon.source: "image://icon/arrow_back"
        onTriggered: root.back()
    }

    AppToolBar {
        id: appToolBar
        title: root.title
        leftButton: stack && stack.depth > 1 ? backAction : null
    }
}
