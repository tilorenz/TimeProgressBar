/*
    SPDX-FileCopyrightText: 2024 Tino Lorenz <tilrnz@gmx.net>
    SPDX-License-Identifier:  GPL-3.0-or-later
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM
import org.kde.kirigamiaddons.dateandtime
import org.kde.kirigamiaddons.components as Components

Column {
	id: root
	property int hours
	property int minutes
	// an item has been double clicked.
	// in the popup, this is treated the same as clicking the accept button
	signal doubleClicked

	ListModel {
		id: hoursModel
		ListElement { value: 0 }
		ListElement { value: 1 }
		ListElement { value: 2 }
		ListElement { value: 3 }
		ListElement { value: 4 }
		ListElement { value: 5 }
		ListElement { value: 6 }
		ListElement { value: 7 }
		ListElement { value: 8 }
		ListElement { value: 9 }
		ListElement { value: 10 }
		ListElement { value: 11 }
		ListElement { value: 12 }
		ListElement { value: 13 }
		ListElement { value: 14 }
		ListElement { value: 15 }
		ListElement { value: 16 }
		ListElement { value: 17 }
		ListElement { value: 18 }
		ListElement { value: 19 }
		ListElement { value: 20 }
		ListElement { value: 21 }
		ListElement { value: 22 }
		ListElement { value: 23 }
	}

	ListModel {
		id: minutesModel
		ListElement { value: 0 }
		ListElement { value: 5 }
		ListElement { value: 10 }
		ListElement { value: 15 }
		ListElement { value: 20 }
		ListElement { value: 25 }
		ListElement { value: 30 }
		ListElement { value: 35 }
		ListElement { value: 40 }
		ListElement { value: 45 }
		ListElement { value: 50 }
		ListElement { value: 55 }
	}

	ListModel {
		id: minutesModelLong
		ListElement { value: 0 }
		ListElement { value: 1 }
		ListElement { value: 2 }
		ListElement { value: 3 }
		ListElement { value: 4 }
		ListElement { value: 5 }
		ListElement { value: 6 }
		ListElement { value: 7 }
		ListElement { value: 8 }
		ListElement { value: 9 }
		ListElement { value: 10 }
		ListElement { value: 11 }
		ListElement { value: 12 }
		ListElement { value: 13 }
		ListElement { value: 14 }
		ListElement { value: 15 }
		ListElement { value: 16 }
		ListElement { value: 17 }
		ListElement { value: 18 }
		ListElement { value: 19 }
		ListElement { value: 20 }
		ListElement { value: 21 }
		ListElement { value: 22 }
		ListElement { value: 23 }
		ListElement { value: 24 }
		ListElement { value: 25 }
		ListElement { value: 26 }
		ListElement { value: 27 }
		ListElement { value: 28 }
		ListElement { value: 29 }
		ListElement { value: 30 }
		ListElement { value: 31 }
		ListElement { value: 32 }
		ListElement { value: 33 }
		ListElement { value: 34 }
		ListElement { value: 35 }
		ListElement { value: 36 }
		ListElement { value: 37 }
		ListElement { value: 38 }
		ListElement { value: 39 }
		ListElement { value: 40 }
		ListElement { value: 41 }
		ListElement { value: 42 }
		ListElement { value: 43 }
		ListElement { value: 44 }
		ListElement { value: 45 }
		ListElement { value: 46 }
		ListElement { value: 47 }
		ListElement { value: 48 }
		ListElement { value: 49 }
		ListElement { value: 50 }
		ListElement { value: 51 }
		ListElement { value: 52 }
		ListElement { value: 53 }
		ListElement { value: 54 }
		ListElement { value: 55 }
		ListElement { value: 56 }
		ListElement { value: 57 }
		ListElement { value: 58 }
		ListElement { value: 59 }
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
				onClicked: root.hours = value
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

