/*
    SPDX-FileCopyrightText: 2024 Tino Lorenz <tilrnz@gmx.net>
    SPDX-License-Identifier:  GPL-3.0-or-later
*/

import QtQuick
import QtQuick.Controls
import org.kde.kirigami as Kirigami

import "."

Dialog {
	id: root
	anchors.centerIn: parent
	parent: Overlay.overlay

	property alias hours: timePicker.hours
	property alias minutes: timePicker.minutes
	property alias show24: timePicker.show24

	contentItem: TBTimePicker {
		id: timePicker
		onDoubleClicked: {
			root.accepted()
			root.close()
		}
	}

	footer: DialogButtonBox {
        id: box

        leftPadding: Kirigami.Units.mediumSpacing
        rightPadding: Kirigami.Units.mediumSpacing
        bottomPadding: Kirigami.Units.mediumSpacing

        Button {
            text: "Cancel"
            icon.name: "dialog-cancel"
            onClicked: {
                root.rejected()
                root.close()
            }

            DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
        }

        Button {
            text: "Select"
            icon.name: "dialog-ok-apply"

            onClicked: {
                root.accepted()
                root.close()
            }

            DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
        }
    }
}

