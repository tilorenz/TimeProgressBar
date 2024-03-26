/*
    SPDX-FileCopyrightText: 2024 Tino Lorenz <tilrnz@gmx.net>
    SPDX-License-Identifier:  GPL-3.0-or-later
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
	id: layoutGeneralRoot

	property int cfg_timeMode
	property int cfg_calendarInterval
	property real cfg_customTimeStart
	property real cfg_customTimeEnd
	property alias cfg_weekStartsOnMonday: weekStartsOnMondayBox.checked
	property alias cfg_showRemainingTime: showRemainingTimeBox.checked

	Kirigami.FormLayout {
		id: layoutGeneral

		ButtonGroup {
			id: timeModeGroup

			onCheckedButtonChanged: {
				if (checkedButton) {
					cfg_timeMode = checkedButton.index
				}
			}
		}

		RadioButton {
			id: timeModeCalendarBtn
			text: "Progress by calendar"
			ButtonGroup.group: timeModeGroup
			property int index: 0
			checked: cfg_timeMode === index
		}

		RowLayout {
			id: calendarIntervalRow
			enabled: cfg_timeMode === 0

			ButtonGroup {
				id: calendarIntervalGroup

				onCheckedButtonChanged: {
					if (checkedButton) {
						cfg_calendarInterval = checkedButton.index
					}
				}
			}

			RadioButton {
				id: calendarIntervalYearBtn
				text: "Year"
				ButtonGroup.group: calendarIntervalGroup
				property int index: 0
				checked: cfg_calendarInterval === index
			}
			RadioButton {
				id: calendarIntervalMonthBtn
				text: "Month"
				ButtonGroup.group: calendarIntervalGroup
				property int index: 1
				checked: cfg_calendarInterval === index
			}
			RadioButton {
				id: calendarIntervalWeekBtn
				text: "Week"
				ButtonGroup.group: calendarIntervalGroup
				property int index: 2
				checked: cfg_calendarInterval === index
			}
			RadioButton {
				id: calendarIntervalDayBtn
				text: "Day"
				ButtonGroup.group: calendarIntervalGroup
				property int index: 3
				checked: cfg_calendarInterval === index
			}

		}

		CheckBox {
			id: weekStartsOnMondayBox
			text: "Week starts on monday"
		}

		Kirigami.Separator {
			Kirigami.FormData.isSection: true
		}

		RadioButton {
			id: timeModeCustomBtn
			text: "Progress by custom dates"
			ButtonGroup.group: timeModeGroup
			property int index: 1
			checked: cfg_timeMode === index
		}

		TextField {
			id: customTimeStartField
			text: new Date(plasmoid.configuration.customTimeStart).toISOString()
			enabled: cfg_timeMode === 1
			onTextChanged: {
				var d = Date.parse(text)
				if (d != Number.NaN) {
					cfg_customTimeStart = d
				}
			}
		}
		TextField {
			id: customTimeEndField
			text: new Date(plasmoid.configuration.customTimeEnd).toISOString()
			enabled: cfg_timeMode === 1
			onTextChanged: {
				var d = Date.parse(text)
				if (d != Number.NaN) {
					cfg_customTimeEnd = d
				}
			}
		}

		CheckBox {
			id: showRemainingTimeBox
			text: "Show remaining rather than passed time"
		}
	}
}

