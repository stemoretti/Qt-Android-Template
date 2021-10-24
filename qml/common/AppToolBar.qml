import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ToolBar {
    property Action leftButton
    property list<Action> rightButtons

    property alias title: titleLabel.text

    RowLayout {
        focus: false
        spacing: 0
        anchors { fill: parent; leftMargin: 4; rightMargin: 4 }

        ToolButton {
            icon.source: leftButton ? leftButton.icon.source : ""
            icon.color: Style.textOnPrimary
            focusPolicy: Qt.NoFocus
            opacity: Style.opacityTitle
            enabled: leftButton && leftButton.enabled
            onClicked: leftButton.trigger()
        }
        LabelTitle {
            id: titleLabel
            elide: Label.ElideRight
            color: Style.textOnPrimary
            Layout.fillWidth: true
        }
        Repeater {
            model: rightButtons.length
            delegate: ToolButton {
                icon.source: rightButtons[index].icon.source
                icon.color: Style.textOnPrimary
                focusPolicy: Qt.NoFocus
                opacity: Style.opacityTitle
                enabled: rightButtons[index].enabled
                onClicked: rightButtons[index].trigger()
            }
        }
    }
}
