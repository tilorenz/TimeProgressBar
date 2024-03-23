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

	required property real value

	radius: 8
	color: Kirigami.Theme.backgroundColor

	Rectangle {
		id: progressIndicator
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		anchors.margins: 1
		width: parent.width * frBackground.value

		radius: parent.radius
		color: Kirigami.Theme.highlightColor
	}

	function fillTemplateText(text, percent) {
		let outText = ''
		let isReplacing = false
		for (let c of text) {
			if (isReplacing) {
				switch (c) {
					case '%':
						outText += '%'
						break
					case 'p':
						outText += percent
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
		color: Kirigami.Theme.textColor
		text: fillTemplateText(Plasmoid.configuration.textTemplate, Math.round(parent.value * 100))
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

