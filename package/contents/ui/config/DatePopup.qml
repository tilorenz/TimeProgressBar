/*
    SPDX-FileCopyrightText: 2024 Tino Lorenz <tilrnz@gmx.net>
    SPDX-License-Identifier:  GPL-3.0-or-later
*/

import QtQuick
import QtQuick.Controls
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.dateandtime as KAD

import "."

// This Popup is inspired by the one in Kirigami-addons,
// with the important difference that the value is aliased to the DatePicker's
// selectedDate.
// This makes it easy to set the date from both sides
// (from the picker and externally from the text field).

Dialog {
	id: root
	anchors.centerIn: parent
	parent: Overlay.overlay

	property alias value: datePicker.selectedDate

	// TODO: get the picker to keep its day and month values when selecting a different year
	// TODO: maybe give the picker an accepted signal that triggers on double click,
	// similar to how my TBTimePicker works
	contentItem: KAD.DatePicker {
		id: datePicker
		// not using onDatePicked since it triggers on single click,
		// even for years and months
		//onDatePicked: (d) => {
			//console.log('dp: ', d)
		//}
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

