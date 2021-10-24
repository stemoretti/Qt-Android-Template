import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ItemDelegate {
    property alias title: titleLabel.text
    property alias subtitle: subtitleLabel.text
    property alias check: settingSwitch

    Layout.fillWidth: true

    contentItem: RowLayout {
        ColumnLayout {
            LabelSubheading {
                id: titleLabel
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
            LabelBody {
                id: subtitleLabel
                opacity: 0.6
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
        }
        Item {
            Layout.fillWidth: true
        }
        Switch {
            id: settingSwitch
            visible: false
        }
    }
}
