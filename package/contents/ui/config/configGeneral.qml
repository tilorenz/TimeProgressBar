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

	readonly property real one_minute: 60 * 1000
	readonly property real one_hour: 60 * 60 * 1000
	readonly property real one_day: 24 * one_hour
	//readonly property var week_days: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
	readonly property var week_days: cfg_weekStartsOnMonday ?
		["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"] :
		["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

	property int cfg_timeMode
	property int cfg_calendarInterval
	property real cfg_dayStartsAt
	property real cfg_dayEndsAt
	property real cfg_weekStartsAt
	property real cfg_weekEndsAt

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

		RangeSlider {
			id: dayOffsetSlider
			Kirigami.FormData.label: i18n("Day offset:")
			enabled: cfg_timeMode == 0 && (calendarIntervalWeekBtn.checked || calendarIntervalDayBtn.checked)
			from: 0
			to: one_day
			snapMode: RangeSlider.SnapAlways
			stepSize: one_minute * 5
			first.value: cfg_dayStartsAt
			second.value: cfg_dayEndsAt
			first.onValueChanged: {
				cfg_dayStartsAt = first.value
			}
			second.onValueChanged: {
				cfg_dayEndsAt = second.value
			}
		}

		Row {
			enabled: cfg_timeMode == 0 && (calendarIntervalWeekBtn.checked || calendarIntervalDayBtn.checked)
			Label {text: "Day starts at: "}

			SpinBox {
				id: dayStartOffsetHoursBox
				editable: true
				from: 0
				to: 24
				onValueModified: {
					var hours = dayStartOffsetHoursBox.value
					var minutes = dayStartOffsetMinutesBox.value
					if (!Number.isNaN(hours) && !Number.isNaN(minutes)) {
						cfg_dayStartsAt = hours * one_hour + minutes * one_minute
					}
				}
				// TODO floor sometimes goes to the last hour, but we need floor the hours,
				// otherwise the hour would jump at :30 (7h29 -> 8h30)...
				value: Math.floor(cfg_dayStartsAt / one_hour)
			}

			Label {text: " : "}

			SpinBox {
				id: dayStartOffsetMinutesBox
				editable: true
				from: 0
				to: 59
				onValueModified: {
					var hours = dayStartOffsetHoursBox.value
					var minutes = dayStartOffsetMinutesBox.value
					if (!Number.isNaN(hours) && !Number.isNaN(minutes)) {
						cfg_dayStartsAt = hours * one_hour + minutes * one_minute
					}
				}
				value: Math.floor((cfg_dayStartsAt % one_hour) / one_minute)
			}

			Label {text: " , ends at: "}

			SpinBox {
				id: dayEndOffsetHoursBox
				editable: true
				from: 0
				to: 24
				onValueModified: {
					var hours = dayEndOffsetHoursBox.value
					var minutes = dayEndOffsetMinutesBox.value
					if (!Number.isNaN(hours) && !Number.isNaN(minutes)) {
						cfg_dayEndsAt = hours * one_hour + minutes * one_minute
					}
				}
				value: Math.floor(cfg_dayEndsAt / one_hour)
			}

			Label {text: " : "}

			SpinBox {
				id: dayEndOffsetMinutesBox
				editable: true
				from: 0
				to: (dayEndOffsetHoursBox.value == 24) ? 0 : 59
				onValueModified: {
					var hours = dayEndOffsetHoursBox.value
					var minutes = dayEndOffsetMinutesBox.value
					if (!Number.isNaN(hours) && !Number.isNaN(minutes)) {
						cfg_dayEndsAt = hours * one_hour + minutes * one_minute
					}
				}
				value: Math.floor((cfg_dayEndsAt % one_hour) / one_minute)
			}
		}

		//Label {text: cfg_dayStartsAt}
		//Label {text: cfg_dayEndsAt}

		RangeSlider {
			id: weekOffsetSlider
			Kirigami.FormData.label: i18n("Week offset:")
			enabled: cfg_timeMode == 0 && calendarIntervalWeekBtn.checked
			from: 0
			to: one_day * 6
			snapMode: RangeSlider.SnapAlways
			stepSize: one_day
			first.value: cfg_weekStartsAt
			second.value: cfg_weekEndsAt
			first.onValueChanged: {
				cfg_weekStartsAt = first.value
			}
			second.onValueChanged: {
				cfg_weekEndsAt = second.value
			}
		}

		Row {
			id: weekOffsetRow
			enabled: cfg_timeMode == 0 && calendarIntervalWeekBtn.checked

			Label {text: "Week starts at: "}

			SpinBox {
				id: weekStartsAtBox
				from: 0
				to: 6
				editable: false

				textFromValue: function(value) {
					return week_days[value]
				}
				valueFromText: function(text) {
					var idx = week_days.indexOf(text)
					if (idx == -1) {
						return weekStartsAtBox.value
					}
					return idx
				}

				value: Math.round(cfg_weekStartsAt / one_day)
				onValueModified: {
					cfg_weekStartsAt = value * one_day
				}
			}

			Label {text: " , ends at: "}

			SpinBox {
				id: weekEndsAtBox
				from: 0
				to: 6
				editable: false

				textFromValue: function(value) {
					return week_days[value]
				}
				valueFromText: function(text) {
					var idx = week_days.indexOf(text)
					if (idx == -1) {
						return weekEndsAtBox.value
					}
					return idx
				}

				value: Math.round(cfg_weekEndsAt / one_day)
				onValueModified: {
					cfg_weekEndsAt = value * one_day
				}
			}
		}

		//Label {text: cfg_weekStartsAt / one_day}
		//Label {text: cfg_weekEndsAt / one_day}

		CheckBox {
			id: weekStartsOnMondayBox
			text: "Week starts on monday"
			onToggled: {
				cfg_weekStartsAt = 0
				cfg_weekEndsAt = 6 * one_day
			}
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

