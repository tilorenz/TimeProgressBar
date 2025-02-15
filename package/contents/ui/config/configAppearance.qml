/*
    SPDX-FileCopyrightText: 2024 Tino Lorenz <tilrnz@gmx.net>
    SPDX-License-Identifier:  GPL-3.0-or-later
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs as QtDialogs
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

// for TimeProgressBar
import ".."

KCM.SimpleKCM {
	id: layoutAppearanceRoot

	property int cfg_rotation
	property alias cfg_fillSpace: fillSpaceBox.checked
	property alias cfg_showText: showTextBox.checked
	property alias cfg_showBar: showBarBox.checked
	property alias cfg_textTemplate: textTemplateField.text

	// Font. This part is mostly taken from Plasma's digital clock
	// (https://invent.kde.org/plasma/plasma-workspace/-/tree/master/applets/digital-clock)
	property alias cfg_useCustomFont: useCustomFontRadioButton.checked
	property alias cfg_fontFamily: fontDialog.fontChosen.family
	property alias cfg_boldText: fontDialog.fontChosen.bold
	property alias cfg_italicText: fontDialog.fontChosen.italic
	property alias cfg_fontWeight: fontDialog.fontChosen.weight
	property alias cfg_fontStyleName: fontDialog.fontChosen.styleName
	property alias cfg_fontSize: fontDialog.fontChosen.pointSize

	Kirigami.FormLayout {
		id: layoutAppearance

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
			id: fillSpaceBox
			Kirigami.FormData.label: "Fill free space on panel"
		}

		CheckBox {
			id: showBarBox
			Kirigami.FormData.label: "Show the bar"
		}

		CheckBox {
			id: showTextBox
			Kirigami.FormData.label: "Show text"
		}

		// Text Config
		// ============================================================ //
		Kirigami.Separator {
			Kirigami.FormData.isSection: true
		}

		ButtonGroup {
			buttons: [useDefaultFontRadioButton, useCustomFontRadioButton]
		}

		RadioButton {
			id: useDefaultFontRadioButton
			Kirigami.FormData.label: "Text style:"
			text: "Follow system theme"
			checked: !cfg_useCustomFont
		}

		Row {
			RadioButton {
				id: useCustomFontRadioButton
				text: "Custom"
				onClicked: {
                    if (cfg_fontFamily === "") {
                        fontDialog.fontChosen = Kirigami.Theme.defaultFont
                    }
				}
				anchors.verticalCenter: chooseFontButton.verticalCenter
			}
			Item {
				height: 1
				width: Kirigami.Units.smallSpacing
			}
			Button {
				id: chooseFontButton
                text: "Choose Style…"
                icon.name: "settings-configure"
                enabled: useCustomFontRadioButton.checked
                onClicked: {
                    fontDialog.selectedFont = fontDialog.fontChosen
                    fontDialog.open()
                }
            }
		}

		QtDialogs.FontDialog {
			id: fontDialog
			title: "Choose a Font"
			modality: Qt.WindowModal
			parentWindow: layoutAppearanceRoot.Window.window

			property font fontChosen: Qt.font()

			onAccepted: {
				fontChosen = selectedFont
			}
		}

		TextField {
			id: textTemplateField
			Kirigami.FormData.label: "Text Template"
			enabled: showTextBox.checked
		}
		Label {
			id: textTemplateExplaination
			wrapMode: Text.Wrap
			onLinkActivated: (link) => Qt.openUrlExternally(link)
			// this is a bit horrible, but it seems to be the only way to get a "clickable" cursor when
			// hovering a link
			onHoveredLinkChanged: {
				if (hoveredLink == "") {
					cursorChangeMouseArea.cursorShape = Qt.ArrowCursor
				} else {
					cursorChangeMouseArea.cursorShape = Qt.PointingHandCursor
				}
			}
			MouseArea {
				id: cursorChangeMouseArea
				anchors.fill: parent
				acceptedButtons: Qt.NoButton
			}
			text: "You can use tags from <a href=\"https://doc.qt.io/qt-6/richtext-html-subset.html\">Qt's supported HTML subset</a><br><br>\
% works as control character, the following character will be replaced by this scheme:<br>\
p → completed percentage<br>\
r → remaining percentage<br>\
d/D → passed/remaining days<br>\
h/H → passed/remaining hours<br>\
j/J → passed/remaining hours in the day<br>\
n/N → passed/remaining minutes in the hour<br>\
% → a literal % character (so if you want a % character in the output, use %%)<br>\
<br>\
Example: 'Week progress: %p%%' expands to 'Week progress: 20%'."
		}
	}
}

