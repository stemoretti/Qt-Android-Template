import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ItemDelegate {
    property alias title: titleLabel.text
    property alias subtitle: subtitleLabel.text
    property alias check: settingSwitch

    Layout.fillWidth: true
    RowLayout {
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        ColumnLayout {
            spacing: 0
            LabelSubheading {
                id: titleLabel
                topPadding: 10
                leftPadding: 20
            }
            LabelBody {
                id: subtitleLabel
                leftPadding: 20
                bottomPadding: 10
                opacity: 0.6
            }
        }
        Item {
            Layout.fillWidth: true
        }
        Switch {
            id: settingSwitch
            rightPadding: 20
            visible: false
        }
    }
}
