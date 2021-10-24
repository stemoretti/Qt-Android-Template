import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../common"
import "../languages.js" as JS

import Settings

AppStackPage {
    id: root

    property int continent: 0

    function back() {
        return replace(Qt.resolvedUrl("SettingsContinentsPage.qml"),
                       StackView.PopTransition)
    }

    title: qsTr("Countries")
    padding: 0

    ListView {
        anchors.fill: parent
        model: JS.regions[continent].countries.map(function (o) { return o.code })
        reuseItems: true

        delegate: ItemDelegate {
            width: root.width
            contentItem: ColumnLayout {
                spacing: 0
                LabelSubheading {
                    text: JS.getCountryFromCode(modelData)
                }
                LabelBody {
                    text: JS.getCountryFromCode(modelData, "native")
                    opacity: 0.6
                }
            }
            onClicked: {
                Settings.country = modelData
                pop()
            }
        }

        ScrollIndicator.vertical: ScrollIndicator { }
    }
}
