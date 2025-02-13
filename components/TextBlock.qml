import QtQuick 2.9

import "../components" as MyNewCoinComponents

TextEdit {
    color: MyNewCoinComponents.Style.defaultFontColor
    font.family: MyNewCoinComponents.Style.fontRegular.name
    selectionColor: MyNewCoinComponents.Style.textSelectionColor
    wrapMode: Text.Wrap
    readOnly: true
    selectByMouse: true
    // Workaround for https://bugreports.qt.io/browse/QTBUG-50587
    onFocusChanged: {
        if(focus === false)
            deselect()
    }
}
