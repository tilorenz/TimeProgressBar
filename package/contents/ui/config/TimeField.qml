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

	readonly property real one_minute: 60 * 1000
	readonly property real one_hour: 60 * 60 * 1000

	signal accepted()

	property int hours
	property int minutes
	// Hours and minutes in ms (as JS-compatible time)
	property double timeOffset: hours * one_hour + minutes * one_minute
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
				root.accepted()
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
			root.accepted()
		}
	}

	Button {
		id: showPopupButton
		icon.name: "expand-symbolic"
		height: field.height

		// TODO fix in QQC2 desktop style
		// the QQC2 desktop style puts everything in the background item,
		// so if we replace it, we remove the icon as well -.-
		// https://invent.kde.org/frameworks/qqc2-desktop-style/-/blob/master/org.kde.desktop/Button.qml?ref_type=heads
		// the normal breeze style does it properly:
		// https://invent.kde.org/plasma/qqc2-breeze-style/-/blob/master/style/qtquickcontrols/Button.qml?ref_type=heads
		//background: Rectangle {
			//implicitWidth: Kirigami.Units.gridUnit * 1.2
			//implicitHeight: field.height
			//color: Kirigami.Theme.backgroundColor
			//bottomRightRadius: Kirigami.Units.cornerRadius
			//topRightRadius: Kirigami.Units.cornerRadius
			//height: field.height
		//}

		onClicked: {
			popup.hours = root.hours
			popup.minutes = root.minutes
			popup.open()
		}
	}
}

