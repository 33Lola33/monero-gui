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
import moneroComponents.Wallet 1.0

import "../components" as MyNewCoinComponents

Rectangle {
    id: item
    property int fillLevel: 0
    property string syncType // Wallet or Daemon
    property string syncText: qsTr("%1 blocks remaining: ").arg(syncType)
    visible: false
    color: "transparent"

    function updateProgress(currentBlock,targetBlock, blocksToSync, statusTxt){
        if(targetBlock > 0) {
            var remaining = (currentBlock < targetBlock) ? targetBlock - currentBlock : 0
            var progressLevel = (blocksToSync > 0 ) ? (100*(blocksToSync - remaining)/blocksToSync).toFixed(0) : 100
            fillLevel = progressLevel
            if(typeof statusTxt != "undefined" && statusTxt != "") {
                progressText.text = statusTxt;
                progressTextValue.text = "";
            } else {
                progressText.text = syncText;
                progressTextValue.text = remaining.toFixed(0);
            }
        }
    }

    Item {
        anchors.top: item.top
        anchors.topMargin: 10
        anchors.leftMargin: 15
        anchors.rightMargin: 15
        anchors.fill: parent

        MyNewCoinComponents.TextPlain {
            id: progressText
            anchors.top: parent.top
            anchors.topMargin: 6
            font.family: MyNewCoinComponents.Style.fontMedium.name
            font.pixelSize: 13
            font.bold: MyNewCoinComponents.Style.progressBarProgressTextBold
            color: MyNewCoinComponents.Style.defaultFontColor
            text: qsTr("Synchronizing %1").arg(syncType) + translationManager.emptyString
            height: 18
        }

        MyNewCoinComponents.TextPlain {
            id: progressTextValue
            anchors.top: parent.top
            anchors.topMargin: 6
            anchors.right: parent.right
            font.family: MyNewCoinComponents.Style.fontMedium.name
            font.pixelSize: 13
            font.bold: MyNewCoinComponents.Style.progressBarProgressTextBold
            color: MyNewCoinComponents.Style.defaultFontColor
            height:18
        }

        Rectangle {
            id: bar
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: progressText.bottom
            anchors.topMargin: 4
            height: 8
            radius: 8
            color: MyNewCoinComponents.Style.progressBarBackgroundColor

            states: [
                State {
                    name: "black";
                    when: MyNewCoinComponents.Style.blackTheme
                    PropertyChanges { target: bar; color: MyNewCoinComponents.Style._b_progressBarBackgroundColor}
                }, State {
                    name: "white";
                    when: !MyNewCoinComponents.Style.blackTheme
                    PropertyChanges { target: bar; color: MyNewCoinComponents.Style._w_progressBarBackgroundColor}
                }
            ]

            transitions: Transition {
                enabled: appWindow.themeTransition
                ColorAnimation { properties: "color"; easing.type: Easing.InOutQuad; duration: 300 }
            }

            Rectangle {
                id: fillRect
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                height: bar.height
                property int maxWidth: bar.width
                width: (maxWidth * fillLevel) / 100
                radius: 8
                color: "#FA6800"
            }

            Rectangle {
                color:"#333"
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.leftMargin: 8
            }
        }

    }
}
