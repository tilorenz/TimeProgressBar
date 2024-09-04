/*
    SPDX-FileCopyrightText: 2024 Tino Lorenz <tilrnz@gmx.net>
    SPDX-License-Identifier:  GPL-3.0-or-later
*/

import QtQuick
import QtQuick.Controls
import org.kde.kirigami as Kirigami

import "."

Row {
	id: root

	property int hours
	property int minutes
	property alias show24: popup.show24

	function parseTime(str) {
		// 1 or 2 digits before and after the : and nothing else on the line
		var dateRe = /^(\d\d?):(\d\d?$)/
		var matches = str.match(dateRe)
		if (!matches || matches.length != 3) {
			return [false, null, null]
		} else {
			return [true, Number(matches[1]), Number(matches[2])]
		}
	}

	function formatTime(h, m) {
		return String(h).padStart(2, '0') + ":" + String(m).padStart(2, '0')
	}

	TextField {
		id: field
		width: Kirigami.Units.gridUnit * 4
		background: Rectangle {
			color: Kirigami.Theme.backgroundColor
			bottomLeftRadius: Kirigami.Units.cornerRadius
			topLeftRadius: Kirigami.Units.cornerRadius
		}

		onEditingFinished: {
			var [success, hours, minutes] = parseTime(text)
			if (success) {
				root.hours = hours
				root.minutes = minutes
			} else {
				text = Qt.binding(() => formatTime(root.hours, root.minutes))
			}
		}

		text: formatTime(root.hours, root.minutes)
	}

	TBTimePopup {
		id: popup
		//show24: true
		onAccepted: {
			root.hours = hours
			root.minutes = minutes
		}
	}

	Button {
		id: showPopupButton
		icon.name: "expand-symbolic"
		background: Rectangle {
			color: Kirigami.Theme.backgroundColor
			bottomRightRadius: Kirigami.Units.cornerRadius
			topRightRadius: Kirigami.Units.cornerRadius
			height: field.height
		}

		onClicked: {
			popup.hours = root.hours
			popup.minutes = root.minutes
			popup.open()
		}
	}
}

