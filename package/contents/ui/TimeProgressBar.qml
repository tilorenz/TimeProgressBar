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

Item {
	id: frRoot
	property bool isVertical: Plasmoid.configuration.rotation == 90 || Plasmoid.configuration.rotation == 270
	property bool isInverted: Plasmoid.configuration.rotation == 180 || Plasmoid.configuration.rotation == 90

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

	Layout.preferredWidth: isVertical ? null : Math.max(
		Plasmoid.configuration.showBar ? 80 : 0,
		Plasmoid.configuration.showText ? barText.implicitWidth + 5 : 0
	)
	Layout.preferredHeight: isVertical ? Math.max(
		Plasmoid.configuration.showBar ? 80 : 0,
		Plasmoid.configuration.showText ? barText.implicitHeight + 5 : 0
	) : null

	Rectangle {
		id: frBackground
		visible: Plasmoid.configuration.showBar

		rotation: frRoot.isInverted ? 180 : 0
		radius: 8
		color: Kirigami.Theme.backgroundColor
		anchors.fill: parent


		Rectangle {
			id: progressIndicator
			property real barScale: Plasmoid.configuration.showRemainingTime
				? (1 - frRoot.value[0])
				: frRoot.value[0]

			anchors.left: parent.left
			anchors.bottom: parent.bottom
			anchors.margins: 1
			width:  (parent.width  - 2) * (frRoot.isVertical ? 1 : barScale)
			height: (parent.height - 2) * (frRoot.isVertical ? barScale : 1)

			radius: parent.radius
			color: Kirigami.Theme.highlightColor
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


	// time_values are [fraction of time passed, ms passed, ms total]
	function fillTemplateText(text, time_values) {
		let [frac_time_passed, abs_time_passed, abs_time_total] = time_values
		let abs_time_remaining = Math.max(0, abs_time_total - abs_time_passed)

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
		z: 1
		color: Kirigami.Theme.textColor
		text: fillTemplateText(Plasmoid.configuration.textTemplate, parent.value)
		anchors.centerIn: parent
		visible: Plasmoid.configuration.showText

		font.family: (!Plasmoid.configuration.useCustomFont || Plasmoid.configuration.fontFamily.length === 0)
			? Kirigami.Theme.defaultFont.family
			: Plasmoid.configuration.fontFamily
		font.weight: Plasmoid.configuration.useCustomFont
			? Plasmoid.configuration.fontWeight
			: Kirigami.Theme.defaultFont.weight
		font.italic: Plasmoid.configuration.useCustomFont
			? Plasmoid.configuration.italicText
			: Kirigami.Theme.defaultFont.italic
		font.pointSize: Plasmoid.configuration.useCustomFont
			? Plasmoid.configuration.fontSize
			: Kirigami.Theme.defaultFont.pointSize
	}
}

