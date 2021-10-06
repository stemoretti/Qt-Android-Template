import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../common"
import "../languages.js" as JS

AppStackPage {
    title: qsTr("Continents")
    padding: 0

    ListView {
        anchors.fill: parent
        model: JS.regions.map(function (o) { return o.name })

        delegate: ItemDelegate {
            width: parent.width
            contentItem: LabelSubheading {
                text: modelData
            }
            onClicked: {
                replace(Qt.resolvedUrl("SettingsCountriesPage.qml"),
                        { "continent": index })
            }
        }
    }
}
