import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import "../common"

BaseModalPopup {
    property bool selectAccentColor: false
    property color currentColor: Material.primary
    property string currentColorName: colorModel.get(currentIndex).title
    property int currentIndex: 0

    signal colorSelected(color c)

    implicitWidth: parent.width * 0.9
    contentHeight: colorsList.contentHeight

    ListView {
        id: colorsList
        anchors.fill: parent
        clip: true
        delegate: ItemDelegate {
            width: colorsList.width
            contentItem: RowLayout {
                spacing: 0
                Rectangle {
                    visible: selectAccentColor
                    color: Material.primary
                    Layout.margins: 0
                    Layout.minimumHeight: 32
                    Layout.minimumWidth: 48
                }
                Rectangle {
                    color: Material.color(model.bg)
                    Layout.margins: 0
                    Layout.minimumHeight: 32
                    Layout.minimumWidth: 32
                }
                LabelBody {
                    text: model.title
                    Layout.leftMargin: 6
                    Layout.fillWidth: true
                }
            }
            onClicked: {
                colorSelected(Material.color(model.bg))
                currentIndex = index
                close()
            }
        }

        model: ListModel {
            id: colorModel
            ListElement { title: qsTr("Material Red"); bg: Material.Red }
            ListElement { title: qsTr("Material Pink"); bg: Material.Pink }
            ListElement { title: qsTr("Material Purple"); bg: Material.Purple }
            ListElement { title: qsTr("Material DeepPurple"); bg: Material.DeepPurple }
            ListElement { title: qsTr("Material Indigo"); bg: Material.Indigo }
            ListElement { title: qsTr("Material Blue"); bg: Material.Blue }
            ListElement { title: qsTr("Material LightBlue"); bg: Material.LightBlue }
            ListElement { title: qsTr("Material Cyan"); bg: Material.Cyan }
            ListElement { title: qsTr("Material Teal"); bg: Material.Teal }
            ListElement { title: qsTr("Material Green"); bg: Material.Green }
            ListElement { title: qsTr("Material LightGreen"); bg: Material.LightGreen }
            ListElement { title: qsTr("Material Lime"); bg: Material.Lime }
            ListElement { title: qsTr("Material Yellow"); bg: Material.Yellow }
            ListElement { title: qsTr("Material Amber"); bg: Material.Amber }
            ListElement { title: qsTr("Material Orange"); bg: Material.Orange }
            ListElement { title: qsTr("Material DeepOrange"); bg: Material.DeepOrange }
            ListElement { title: qsTr("Material Brown"); bg: Material.Brown }
            ListElement { title: qsTr("Material Grey"); bg: Material.Grey }
            ListElement { title: qsTr("Material BlueGrey"); bg: Material.BlueGrey }
        }
    }

    Component.onCompleted: {
        for (var i = 0; i < colorModel.count; ++i) {
            var tmp = colorModel.get(i)
            if (Material.color(tmp.bg) === currentColor) {
                currentIndex = i
                return
            }
        }
    }
}
