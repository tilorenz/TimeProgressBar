/*
    SPDX-FileCopyrightText: 2024 Tino Lorenz <tilrnz@gmx.net>
    SPDX-License-Identifier:  GPL-3.0-or-later
*/

import QtQuick
import QtQuick.Controls
import org.kde.kirigami as Kirigami

Column {
	id: root
	property int hours
	property int minutes
	// an item has been double clicked.
	// in the popup, this is treated the same as clicking the accept button
	signal doubleClicked
	property bool show24

	ListModel {
		id: hoursModel
	}
	ListModel {
		id: minutesModel
	}
	ListModel {
		id: minutesModelLong
	}

	Component.onCompleted: {
		var hoursLimit = root.show24 ? 25 : 24
		for (var i = 0; i < hoursLimit; i++) {
			hoursModel.append({value: i})
		}

		for (var i = 0; i < 60; i += 5) {
			minutesModel.append({value: i})
		}

		for (var i = 0; i < 60; i ++) {
			minutesModelLong.append({value: i})
		}
	}

	Component {
		id: hoursDelegate
		Rectangle {
			height: Kirigami.Units.gridUnit * 1.2
			width: Kirigami.Units.gridUnit * 2
			color: numberMouseArea.containsMouse ? Kirigami.Theme.hoverColor :
			(root.hours == value ? Kirigami.Theme.highlightColor : Kirigami.Theme.backgroundColor)
			border.color: Kirigami.Theme.textColor
			border.width: root.hours == value ? 1 : 0

			Label {
				id: numberLbl
				text: value
				anchors.centerIn: parent
			}

			MouseArea {
				id: numberMouseArea
				anchors.fill: parent
				hoverEnabled: true
				onClicked: {
					root.hours = value
					if (value == 24) {
						root.minutes = 0
					}
				}
				onDoubleClicked: root.doubleClicked()
			}
		}
	}

	Component {
		id: minutesDelegate
		Rectangle {
			height: Kirigami.Units.gridUnit * 1.2
			width: Kirigami.Units.gridUnit * 2
			color: numberMouseArea.containsMouse ? Kirigami.Theme.hoverColor :
			(root.minutes == value ? Kirigami.Theme.highlightColor : Kirigami.Theme.backgroundColor)
			border.color: Kirigami.Theme.textColor
			border.width: root.minutes == value ? 1 : 0

			Label {
				id: numberLbl
				text: ":" + value
				anchors.centerIn: parent
			}

			MouseArea {
				id: numberMouseArea
				anchors.fill: parent
				hoverEnabled: true
				onClicked: root.minutes = value
				onDoubleClicked: root.doubleClicked()
			}
		}
	}

	Grid {
		Repeater{
			model: hoursModel
			delegate: hoursDelegate
		}
		columns: 12
	}

	Item {
		height: Kirigami.Units.gridUnit
		width: 1
	}

	Row {
		Grid {
			Repeater{
				model: longMinutesToggleBtn.expanded ? minutesModelLong : minutesModel
				delegate: minutesDelegate
			}
			columns: 12
		}

		Button {
			id: longMinutesToggleBtn
			property bool expanded
			icon.name: expanded ? "collapse-symbolic" : "expand-symbolic"
			onClicked: expanded = !expanded
		}
	}
}

