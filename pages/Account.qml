// Copyright (c) 2014-2024, The MyNewCoin Project
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification, are
// permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice, this list of
//    conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright notice, this list
//    of conditions and the following disclaimer in the documentation and/or other
//    materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its contributors may be
//    used to endorse or promote products derived from this software without specific
//    prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
// THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import QtQuick 2.9
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import FontAwesome 1.0

import "../components" as MyNewCoinComponents
import "../components/effects/" as MyNewCoinEffects

import moneroComponents.Clipboard 1.0
import moneroComponents.Wallet 1.0
import moneroComponents.WalletManager 1.0
import moneroComponents.TransactionHistory 1.0
import moneroComponents.TransactionHistoryModel 1.0
import "../js/TxUtils.js" as TxUtils

Rectangle {
    id: pageAccount
    color: "transparent"
    property var model
    property alias accountHeight: mainLayout.height
    property alias balanceAllText: balanceAll.text
    property alias unlockedBalanceAllText: unlockedBalanceAll.text
    property bool selectAndSend: false
    property int currentAccountIndex

    function renameSubaddressAccountLabel(_index){
        inputDialog.labelText = qsTr("Set the label of the selected account:") + translationManager.emptyString;
        inputDialog.onAcceptedCallback = function() {
            appWindow.currentWallet.setSubaddressLabel(_index, 0, inputDialog.inputText)
            appWindow.currentWallet.subaddressAccount.refresh()
        }
        inputDialog.onRejectedCallback = null;
        inputDialog.open(appWindow.currentWallet.getSubaddressLabel(_index, 0))
    }

    Clipboard { id: clipboard }

    /* main layout */
    ColumnLayout {
        id: mainLayout
        anchors.margins: 20
        anchors.topMargin: 40

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right

        spacing: 20

        ColumnLayout {
            id: balanceRow
            visible: !selectAndSend
            spacing: 0

            MyNewCoinComponents.LabelSubheader {
                Layout.fillWidth: true
                fontSize: 24
                textFormat: Text.RichText
                text: qsTr("Balance All") + translationManager.emptyString
            }

            RowLayout {
                Layout.topMargin: 22

                MyNewCoinComponents.TextPlain {
                    text: qsTr("Total balance: ") + translationManager.emptyString
                    Layout.fillWidth: true
                    color: MyNewCoinComponents.Style.defaultFontColor
                    font.pixelSize: 16
                    font.family: MyNewCoinComponents.Style.fontRegular.name
                    themeTransition: false
                }

                MyNewCoinComponents.TextPlain {
                    id: balanceAll
                    Layout.rightMargin: 87
                    font.family: MyNewCoinComponents.Style.fontMonoRegular.name;
                    font.pixelSize: 16
                    color: MyNewCoinComponents.Style.defaultFontColor

                    MouseArea {
                        hoverEnabled: true
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onEntered: parent.color = MyNewCoinComponents.Style.orange
                        onExited: parent.color = MyNewCoinComponents.Style.defaultFontColor
                        onClicked: {
                            console.log("Copied to clipboard");
                            var balanceAllNumberOnly = parent.text.slice(0, -4);
                            clipboard.setText(balanceAllNumberOnly);
                            appWindow.showStatusMessage(qsTr("Copied to clipboard"),3)
                        }
                    }
                }
            }

            RowLayout {
                Layout.topMargin: 10

                MyNewCoinComponents.TextPlain {
                    text: qsTr("Total unlocked balance: ") + translationManager.emptyString
                    Layout.fillWidth: true
                    color: MyNewCoinComponents.Style.defaultFontColor
                    font.pixelSize: 16
                    font.family: MyNewCoinComponents.Style.fontRegular.name
                    themeTransition: false
                }

                MyNewCoinComponents.TextPlain {
                    id: unlockedBalanceAll
                    Layout.rightMargin: 87
                    font.family: MyNewCoinComponents.Style.fontMonoRegular.name;
                    font.pixelSize: 16
                    color: MyNewCoinComponents.Style.defaultFontColor

                    MouseArea {
                        hoverEnabled: true
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onEntered: parent.color = MyNewCoinComponents.Style.orange
                        onExited: parent.color = MyNewCoinComponents.Style.defaultFontColor
                        onClicked: {
                            console.log("Copied to clipboard");
                            var unlockedBalanceAllNumberOnly = parent.text.slice(0, -4);
                            clipboard.setText(unlockedBalanceAllNumberOnly);
                            appWindow.showStatusMessage(qsTr("Copied to clipboard"),3)
                        }
                    }
                }
            }
        }

        ColumnLayout {
            id: addressRow
            spacing: 0

            RowLayout {
                spacing: 0

                MyNewCoinComponents.LabelSubheader {
                    Layout.fillWidth: true
                    fontSize: 24
                    textFormat: Text.RichText
                    text: qsTr("Accounts") + translationManager.emptyString
                }

                MyNewCoinComponents.StandardButton {
                    id: createNewAccountButton
                    visible: !selectAndSend
                    small: true
                    text: qsTr("Create new account") + translationManager.emptyString
                    fontSize: 13
                    onClicked: {
                        inputDialog.labelText = qsTr("Set the label of the new account:") + translationManager.emptyString
                        inputDialog.onAcceptedCallback = function() {
                            appWindow.currentWallet.subaddressAccount.addRow(inputDialog.inputText)
                            appWindow.currentWallet.switchSubaddressAccount(appWindow.currentWallet.numSubaddressAccounts() - 1)
                            appWindow.onWalletUpdate();
                        }
                        inputDialog.onRejectedCallback = null;
                        inputDialog.open()
                    }

                    Rectangle {
                        anchors.top: createNewAccountButton.bottom
                        anchors.topMargin: 8
                        anchors.left: createNewAccountButton.left
                        anchors.right: createNewAccountButton.right
                        height: 2
                        color: MyNewCoinComponents.Style.appWindowBorderColor

                        MyNewCoinEffects.ColorTransition {
                            targetObj: parent
                            blackColor: MyNewCoinComponents.Style._b_appWindowBorderColor
                            whiteColor: MyNewCoinComponents.Style._w_appWindowBorderColor
                        }
                    }
                }
            }

            ColumnLayout {
                id: subaddressAccountListRow
                property int subaddressAccountListItemHeight: 50
                Layout.topMargin: 6
                Layout.fillWidth: true
                Layout.minimumWidth: 240
                Layout.preferredHeight: subaddressAccountListItemHeight * subaddressAccountListView.count
                visible: subaddressAccountListView.count >= 1

                ListView {
                    id: subaddressAccountListView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    boundsBehavior: ListView.StopAtBounds
                    interactive: false
                    currentIndex: currentAccountIndex

                    delegate: Rectangle {
                        id: tableItem2
                        height: subaddressAccountListRow.subaddressAccountListItemHeight
                        width: parent ? parent.width : undefined
                        Layout.fillWidth: true
                        color: itemMouseArea.containsMouse || index === currentAccountIndex ? MyNewCoinComponents.Style.titleBarButtonHoverColor : "transparent"

                        Rectangle {
                            visible: index === currentAccountIndex
                            Layout.fillHeight: true
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            color: MyNewCoinComponents.Style.accountColors[currentAccountIndex % MyNewCoinComponents.Style.accountColors.length]
                            width: 2
                        }

                        Rectangle {
                            color: MyNewCoinComponents.Style.appWindowBorderColor
                            anchors.right: parent.right
                            anchors.left: parent.left
                            anchors.top: parent.top
                            height: 1
                            visible: index !== 0

                            MyNewCoinEffects.ColorTransition {
                                targetObj: parent
                                blackColor: MyNewCoinComponents.Style._b_appWindowBorderColor
                                whiteColor: MyNewCoinComponents.Style._w_appWindowBorderColor
                            }
                        }

                        Rectangle {
                            anchors.fill: parent
                            anchors.topMargin: 5
                            anchors.rightMargin: 80
                            color: "transparent"

                            MyNewCoinComponents.Label {
                                id: idLabel
                                color: index === currentAccountIndex ? MyNewCoinComponents.Style.defaultFontColor : "#757575"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 6
                                fontSize: 16
                                text: "#" + index
                                themeTransition: false
                            }

                            MyNewCoinComponents.Label {
                                id: nameLabel
                                color: index === currentAccountIndex ? MyNewCoinComponents.Style.defaultFontColor : MyNewCoinComponents.Style.dimmedFontColor
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: idLabel.right
                                anchors.leftMargin: 6
                                fontSize: 16 
                                text: label
                                elide: Text.ElideRight
                                textWidth: addressLabel.x - nameLabel.x - 1
                                themeTransition: false
                            }

                            MyNewCoinComponents.Label {
                                id: addressLabel
                                color: MyNewCoinComponents.Style.defaultFontColor
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: balanceNumberLabel.left
                                anchors.leftMargin: -addressLabel.width - 30
                                fontSize: 16
                                fontFamily: MyNewCoinComponents.Style.fontMonoRegular.name;
                                text: TxUtils.addressTruncatePretty(address, mainLayout.width < 740 ? 1 : (mainLayout.width < 900 ? 2 : 3))
                                themeTransition: false
                            }

                            MyNewCoinComponents.Label {
                                id: balanceNumberLabel
                                color: MyNewCoinComponents.Style.defaultFontColor
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.right
                                anchors.leftMargin: -balanceNumberLabel.width
                                fontSize: 16
                                fontFamily: MyNewCoinComponents.Style.fontMonoRegular.name;
                                text: balance + " MNC"
                                elide: Text.ElideRight
                                textWidth: 180
                                themeTransition: false
                            }

                            MouseArea {
                                id: itemMouseArea
                                cursorShape: Qt.PointingHandCursor
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    appWindow.currentWallet.switchSubaddressAccount(index);
                                    if (selectAndSend)
                                        appWindow.showPageRequest("Transfer");
                                }
                            }
                        }

                        RowLayout {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            anchors.rightMargin: 6
                            height: 21
                            spacing: 10

                            MyNewCoinComponents.IconButton {
                                id: renameButton
                                image: "qrc:///images/edit.svg"
                                fontAwesomeFallbackIcon: FontAwesome.edit
                                fontAwesomeFallbackSize: 22
                                color: MyNewCoinComponents.Style.defaultFontColor
                                opacity: isOpenGL ? 0.5 : 1
                                fontAwesomeFallbackOpacity: 0.5
                                Layout.preferredWidth: 23
                                Layout.preferredHeight: 21
                                tooltip: qsTr("Edit account label") + translationManager.emptyString

                                onClicked: pageAccount.renameSubaddressAccountLabel(index);
                            }

                            MyNewCoinComponents.IconButton {
                                id: copyButton
                                image: "qrc:///images/copy.svg"
                                fontAwesomeFallbackIcon: FontAwesome.clipboard
                                fontAwesomeFallbackSize: 22
                                color: MyNewCoinComponents.Style.defaultFontColor
                                opacity: isOpenGL ? 0.5 : 1
                                fontAwesomeFallbackOpacity: 0.5
                                Layout.preferredWidth: 16
                                Layout.preferredHeight: 21
                                tooltip: qsTr("Copy address to clipboard") + translationManager.emptyString

                                onClicked: {
                                    console.log("Address copied to clipboard");
                                    clipboard.setText(address);
                                    appWindow.showStatusMessage(qsTr("Address copied to clipboard"),3);
                                }
                            }
                        }
                    }

                    onCurrentIndexChanged: {
                        appWindow.onWalletUpdate();
                    }
                }
            }

            Rectangle {
                color: MyNewCoinComponents.Style.appWindowBorderColor
                Layout.fillWidth: true
                height: 1

                MyNewCoinEffects.ColorTransition {
                    targetObj: parent
                    blackColor: MyNewCoinComponents.Style._b_appWindowBorderColor
                    whiteColor: MyNewCoinComponents.Style._w_appWindowBorderColor
                }
            }
        }
    }

    function onPageCompleted() {
        console.log("account");
        if (appWindow.currentWallet !== undefined) {
            appWindow.currentWallet.subaddressAccount.refresh();
            subaddressAccountListView.model = appWindow.currentWallet.subaddressAccountModel;
            appWindow.currentWallet.subaddress.refresh(appWindow.currentWallet.currentSubaddressAccount)

            balanceAll.text = walletManager.displayAmount(appWindow.currentWallet.balanceAll()) + " MNC"
            unlockedBalanceAll.text = walletManager.displayAmount(appWindow.currentWallet.unlockedBalanceAll()) + " MNC"
        }
    }

    function onPageClosed() {
        selectAndSend = false;
    }
}
