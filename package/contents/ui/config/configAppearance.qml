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
					TimeProgressBar {
						id: tpBar
						height: 20
						width: 60
						value: [0.35, 0, 0]
						rotation: parent.index * 90
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
			id: showTextBox
			Kirigami.FormData.label: "Show text on the bar"
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

