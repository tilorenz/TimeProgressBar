/*
    SPDX-FileCopyrightText: 2024 Tino Lorenz <tilrnz@gmx.net>
    SPDX-License-Identifier:  GPL-3.0-or-later
*/

// The normal breeze-styled progress bar is just a thin line, so we need something custom.

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

Rectangle {
	id: frBackground

	readonly property real one_minute: 60 * 1000
	readonly property real one_hour: 60 * 60 * 1000
	readonly property real one_day: 24 * one_hour

	enum ProgressInterval {
		Year = 0,
		Month = 1,
		Week = 2,
		Day = 3,
		Custom = 4
	}

	required property var value

	radius: 8
	color: Kirigami.Theme.backgroundColor
	Layout.preferredWidth: Math.max(60,
		(rotation === 0 || rotation === 180) && barText.visible ? barText.implicitWidth + 10 : 0
	)

	//Layout.preferredHeight: (rotation === 0 || rotation === 180) ? 30 : 60

	Rectangle {
		id: progressIndicator
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		anchors.margins: 1
		width: parent.width * (Plasmoid.configuration.showRemainingTime ?
			(1 - frBackground.value[0]) : frBackground.value[0])

		radius: parent.radius
		color: Kirigami.Theme.highlightColor
	}

	// time_values are [fraction of time passed, ms passed, ms total]
	function fillTemplateText(text, time_values) {
		let [frac_time_passed, abs_time_passed, abs_time_total] = time_values
		let abs_time_remaining = abs_time_total - abs_time_passed

		let outText = ''
		let isReplacing = false
		for (let c of text) {
			if (isReplacing) {
				switch (c) {
					case '%':
						outText += '%'
						break
					case 'p':
						outText += Math.round(frac_time_passed * 100)
						break
					case 'r':
						outText += Math.round((1 - frac_time_passed) * 100)
						break
					case 'd':
						outText += Math.floor(abs_time_passed / one_day)
						break
					case 'D':
						outText += Math.floor(abs_time_remaining / one_day)
						break
					case 'h':
						outText += Math.floor(abs_time_passed / one_hour)
						break
					case 'H':
						outText += Math.floor(abs_time_remaining / one_hour)
						break
					case 'm':
						outText += Math.floor(abs_time_passed / one_minute)
						break
					case 'M':
						outText += Math.floor(abs_time_remaining / one_minute)
						break
					case 'j':
						outText += Math.floor((abs_time_passed % one_day) / one_hour)
						break
					case 'J':
						outText += Math.floor((abs_time_remaining % one_day) / one_hour)
						break
					case 'n':
						outText += Math.floor((abs_time_passed % one_hour) / one_minute)
						break
					case 'N':
						outText += Math.floor((abs_time_remaining % one_hour) / one_minute)
						break
					default:
						break
				}
				isReplacing = false
			} else {
				if (c == '%') {
					isReplacing = true
				} else {
					outText += c
				}
			}
		}
		return outText
	}

	Text {
		id: barText
		color: Kirigami.Theme.textColor
		text: fillTemplateText(Plasmoid.configuration.textTemplate, parent.value)
		anchors.centerIn: parent
		visible: Plasmoid.configuration.showText
		// offset the parent's rotation so the text is always readable
		rotation: -parent.rotation
	}

	Rectangle {
		// this only draws the border over the background and progressIndicator.
		// setting the border on the parent hides it under the progressIndicator.
		// making the indicator smaller (by setting the anchor margins)
		// leads to the background shining through in the corners.
		id: borderRect
		anchors.fill: parent
		color: "transparent"
		z: 1
		radius: parent.radius
		border.color: Kirigami.Theme.textColor
		border.width: 1
	}
}

