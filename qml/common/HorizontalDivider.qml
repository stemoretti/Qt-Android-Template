// ekke (Ekkehard Gentz) @ekkescorner
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
Item {
    height: 8
    Layout.fillWidth: true
    // anchors.left: parent.left
    // anchors.right: parent.right
    // anchors.margins: 6
    // https://www.google.com/design/spec/components/dividers.html#dividers-types-of-dividers
    Rectangle {
        width: parent.width
        height: 1
        opacity: dividerOpacity
        color: dividerColor
    }
}
