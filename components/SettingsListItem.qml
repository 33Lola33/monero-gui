import QtQuick 2.9
import QtQuick.Layouts 1.1
import FontAwesome 1.0

import "../components" as MyNewCoinComponents

ColumnLayout {
    id: settingsListItem
    property alias iconText: iconLabel.text
    property alias symbol: symbolText.text
    property alias description: area.text
    property alias title: header.text
    property bool isLast: false
    property bool enabled: true
    signal clicked()

    Layout.fillWidth: true
    spacing: 0

    Rectangle {
        id: root
        Layout.fillWidth: true
        Layout.minimumHeight: 75
        Layout.preferredHeight: rect.height + 15
        color: "transparent"

        Rectangle {
            id: divider
            anchors.topMargin: 0
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: MyNewCoinComponents.Style.dividerColor
            opacity: MyNewCoinComponents.Style.dividerOpacity
        }

        Rectangle {
            id: rect
            width: parent.width
            height: header.height + area.contentHeight
            color: "transparent";
            opacity: settingsListItem.enabled ? 1 : 0.25
            anchors.left: parent.left
            anchors.bottomMargin: 4
            anchors.topMargin: 4
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                id: icon
                color: "transparent"
                height: 32
                width: 32
                anchors.left: parent.left
                anchors.leftMargin: 16
                anchors.verticalCenter: parent.verticalCenter

                MyNewCoinComponents.Label {
                    id: iconLabel
                    fontSize: 32
                    fontFamily: FontAwesome.fontFamilySolid
                    anchors.centerIn: parent
                    fontColor: MyNewCoinComponents.Style.defaultFontColor
                    styleName: "Solid"
                }
            }

            MyNewCoinComponents.TextPlain {
                id: header
                anchors.left: icon.right
                anchors.leftMargin: 16
                anchors.top: parent.top
                color: MyNewCoinComponents.Style.defaultFontColor
                opacity: MyNewCoinComponents.Style.blackTheme ? 1.0 : 0.8
                font.bold: true
                font.family: MyNewCoinComponents.Style.fontRegular.name
                font.pixelSize: 16
            }

            Text {
                id: area
                anchors.top: header.bottom
                anchors.topMargin: 4
                anchors.left: icon.right
                anchors.leftMargin: 16
                color: MyNewCoinComponents.Style.dimmedFontColor
                font.family: MyNewCoinComponents.Style.fontRegular.name
                font.pixelSize: 15
                horizontalAlignment: TextInput.AlignLeft
                wrapMode: Text.WordWrap;
                leftPadding: 0
                topPadding: 0
                width: parent.width - (icon.width + icon.anchors.leftMargin + anchors.leftMargin)
            }
        }

        Rectangle {
            id: bottomDivider
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: MyNewCoinComponents.Style.dividerColor
            opacity: MyNewCoinComponents.Style.dividerOpacity
            visible: settingsListItem.isLast
        }

        MouseArea {
            visible: settingsListItem.enabled
            cursorShape: Qt.PointingHandCursor
            anchors.fill: parent
            hoverEnabled: true
            onEntered: root.color = MyNewCoinComponents.Style.titleBarButtonHoverColor
            onExited: root.color = "transparent"
            onClicked: {
                settingsListItem.clicked()
            }
        }

        MyNewCoinComponents.TextPlain {
            id: symbolText
            anchors.right: parent.right
            anchors.rightMargin: 44
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 12
            font.bold: true
            color: MyNewCoinComponents.Style.menuButtonTextColor
            visible: appWindow.ctrlPressed
            themeTransition: false
        }
    }
}
