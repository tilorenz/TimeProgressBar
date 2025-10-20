/*
    SPDX-FileCopyrightText: 2025 Tino Lorenz <tilrnz@gmx.net>
    SPDX-License-Identifier:  GPL-3.0-or-later
*/

import QtQuick
import QtQuick.Controls

import org.kde.kquickcontrols as KQControls
import org.kde.kirigami as Kirigami

Row {
    property alias colorMode: colorModeBox.currentIndex
    property alias customColor: customColorBtn.color

    ComboBox {
        id: colorModeBox
        model: [
            "Custom",
            "Theme's highlight color",
            "Theme's background color",
            "Theme's text color",
        ]
    }

    Item {
        height: 1
        width: Kirigami.Units.smallSpacing
    }

    KQControls.ColorButton {
        id: customColorBtn
        showAlphaChannel: true
        // enabled if color mode is custom
        enabled: colorModeBox.currentIndex === 0
    }
}
