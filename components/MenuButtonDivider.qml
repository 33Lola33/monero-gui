import QtQuick 2.9

import "." as MyNewCoinComponents
import "effects/" as MyNewCoinEffects

Rectangle {
    color: MyNewCoinComponents.Style.appWindowBorderColor
    height: 1

    MyNewCoinEffects.ColorTransition {
        targetObj: parent
        blackColor: MyNewCoinComponents.Style._b_appWindowBorderColor
        whiteColor: MyNewCoinComponents.Style._w_appWindowBorderColor
    }
}
