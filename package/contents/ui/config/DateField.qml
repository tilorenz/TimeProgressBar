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

	property date value: new Date()
	signal accepted()

	function parseTime(str) {
		var dateRe = /^(\d*)-(\d\d?)-(\d\d?$)/
		var matches = str.match(dateRe)
		if (!matches || matches.length != 4) {
			return [false, null, null, null]
		} else {
			//console.log('parsed:', [true, Number(matches[1]), Number(matches[2]) - 1, Number(matches[3])])
			return [true, Number(matches[1]), Number(matches[2]) - 1, Number(matches[3])]
		}
	}

	function formatDate(d) {
		return formatYear(d.getFullYear(), d.getMonth() + 1, d.getDate())
	}

	function formatYear(y, m, d) {
		return String(y) + "-" + String(m).padStart(2, '0') + "-" + String(d).padStart(2, '0')
	}

	TextField {
		id: field
		width: Kirigami.Units.gridUnit * 5
		background: Rectangle {
			color: Kirigami.Theme.backgroundColor
			bottomLeftRadius: Kirigami.Units.cornerRadius
			topLeftRadius: Kirigami.Units.cornerRadius
		}

		onEditingFinished: {
			var [success, year, month, day] = parseTime(text)
			if (success) {
				root.value.setFullYear(year, month, day)
				root.accepted()
			} else {
				text = Qt.binding(() =>
					formatDate(root.value)
				)
			}
		}

		text: formatDate(root.value)
	}

	DatePopup {
		id: popup
		onAccepted: {
			// don't just set the date, we want to keep the time (hours/minutes)
			root.value.setFullYear(value.getFullYear(), value.getMonth(), value.getDate())
			root.accepted()
		}
	}

	Button {
		id: showPopupButton
		icon.name: "expand-symbolic"
		height: field.height

		// TODO see TimeField
		//background: Rectangle {
			//color: Kirigami.Theme.backgroundColor
			//implicitWidth: Kirigami.Units.gridUnit * 1.2
			//implicitHeight: field.height
			//bottomRightRadius: Kirigami.Units.cornerRadius
			//topRightRadius: Kirigami.Units.cornerRadius
			//height: field.height
		//}

		onClicked: {
			//picker.selectedDate = root.value
			popup.value = root.value
			popup.open()
		}
	}
}

