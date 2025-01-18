/*
    SPDX-FileCopyrightText: 2024 Tino Lorenz <tilrnz@gmx.net>
    SPDX-License-Identifier:  GPL-3.0-or-later
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

// for TimeProgressBar
import ".."

KCM.SimpleKCM {
	id: layoutGeneralRoot

	property int cfg_rotation
	property alias cfg_showText: showTextBox.checked
	property alias cfg_showBar: showBarBox.checked
	property alias cfg_textTemplate: textTemplateField.text

	Kirigami.FormLayout {
		id: layoutGeneral

		ButtonGroup {
			id: rotationGroup

			onCheckedButtonChanged: {
				if (checkedButton) {
					cfg_rotation = checkedButton._rotation
				}
			}
		}

		Row {
			Kirigami.FormData.label: "Rotation"
			topPadding: 25
			Repeater {
				model: 4
				ColumnLayout {
					implicitWidth: 80
					required property int index
					Rectangle {
						id: tpBar
						radius: 8
						color: "transparent"
						height: 20
						width: 60
						rotation: parent.index * 90

						Rectangle {
							id: progressIndicator
							anchors.left: parent.left
							anchors.top: parent.top
							anchors.bottom: parent.bottom
							anchors.margins: 1
							width: parent.width * 0.35
							radius: parent.radius
							color: Kirigami.Theme.highlightColor
						}
						Rectangle {
							id: borderRect
							anchors.fill: parent
							color: "transparent"
							z: 1
							radius: parent.radius
							border.color: Kirigami.Theme.textColor
							border.width: 1
						}
					}
					RadioButton {
						checked: cfg_rotation === _rotation
						Layout.topMargin: 25
						Layout.alignment: Qt.AlignHCenter
						property real _rotation: parent.index * 90
						ButtonGroup.group: rotationGroup
					}
				}
			}
		}

		CheckBox {
			id: showBarBox
			Kirigami.FormData.label: "Show the bar"
		}

		CheckBox {
			id: showTextBox
			Kirigami.FormData.label: "Show text"
		}
		TextField {
			id: textTemplateField
			Kirigami.FormData.label: "Text Template"
			enabled: showTextBox.checked
		}
		Label {
			id: textTemplateExplaination
			wrapMode: Text.Wrap
			text: "% works as control character, the following character will be replaced by this scheme:\n\
p → completed percentage\n\
r → remaining percentage\n\
d/D → passed/remaining days\n\
h/H → passed/remaining hours\n\
j/J → passed/remaining hours in the day\n\
n/N → passed/remaining minutes in the hour\n\
% → a literal % character (so if you want a % character in the output, use %%)\n\
\n\
Example: 'Week progress: %p%%' expands to 'Week progress: 20%'."
		}
	}
}

