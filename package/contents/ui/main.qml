/*
    SPDX-FileCopyrightText: 2024 Tino Lorenz <tilrnz@gmx.net>
    SPDX-License-Identifier:  GPL-3.0-or-later
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

PlasmoidItem {
	id: root

    preferredRepresentation: fullRepresentation

	property var value: [0,0,0]
	property real interval: 0 // TODO what does this do again?

	// QML doesn't automatically update the bindings that depend on the current date, so just binding
	// value to getYearProgress() wouldn't work.
	// it would also waste resources since Date() changes every milisecond.
	Timer {
		id: timeUpdater
		repeat: true
		interval: 5000
		running: true
		triggeredOnStart: true
		onTriggered: {
			updateProgress()
		}
	}

	// immediately update progress on config change
	Component.onCompleted: {
		Plasmoid.configuration.valueChanged.connect((key, value) => {
			updateProgress()
		});
	}

	function updateProgress() {
		switch (Plasmoid.configuration.timeMode) {
			case 0: // Calendar
			root.value = getTimeProgress( Plasmoid.configuration.calendarInterval)
				break
			case 1: // Custom
				root.value = getTimeProgress(TimeProgressBar.ProgressInterval.Custom)
				break
		}
	}

	// returns [fraction of time passed, ms passed, ms total]
	function getTimeProgress(interval) {
		var start = 0
		var end = 0
		var now = new Date()

		switch (interval) {
			case TimeProgressBar.ProgressInterval.Year: {
				start = new Date(now.getFullYear(), 0)
				end = new Date(now.getFullYear() + 1, 0)
				start = start.getTime()
				end = end.getTime()
				break
			}
			case TimeProgressBar.ProgressInterval.Month: {
				start = new Date(now.getFullYear(), now.getMonth())
				end = new Date(now.getFullYear(), now.getMonth() + 1)
				start = start.getTime()
				end = end.getTime()
				break
			}
			case TimeProgressBar.ProgressInterval.Week: {
				var weekDay = now.getDay()
				// we subtract weekDay days from the date to get to the start of the week.
				// for JS, the week starts on sunday.
				// if we want it to start on monday (like reasonable people), we need to subtract 1 day less,
				// unless we're on a sunday, then the new week hasn't begun yet so we need to subtract 6 days.
				//
				// | one week for JS  |
				// Su Mo Tu We Th Fr Sa Su Mo
				//  ___<----------<
				//
				// | one week for JS  |
				// Su Mo Tu We Th Fr Sa Su Mo
				//     <===============-<
				if (Plasmoid.configuration.weekStartsOnMonday) {
					weekDay = (weekDay + 6) % 7
				}
				start = new Date(now.getFullYear(), now.getMonth(), now.getDate() - weekDay)
				end = new Date(now.getFullYear(), now.getMonth(), now.getDate() - weekDay)

				start = start.getTime()
				end = end.getTime()

				start += Plasmoid.configuration.weekStartsAt
				end += Plasmoid.configuration.weekEndsAt
				start += Plasmoid.configuration.dayStartsAt
				end += Plasmoid.configuration.dayEndsAt
				break
			}
			case TimeProgressBar.ProgressInterval.Day: {
				start = new Date(now.getFullYear(), now.getMonth(), now.getDate())
				end = new Date(now.getFullYear(), now.getMonth(), now.getDate())

				start = start.getTime()
				end = end.getTime()

				start += Plasmoid.configuration.dayStartsAt
				end += Plasmoid.configuration.dayEndsAt
				break
			}
			case TimeProgressBar.ProgressInterval.Custom: {
				start = new Date(Plasmoid.configuration.customTimeStart)
				end = new Date(Plasmoid.configuration.customTimeEnd)
				start = start.getTime()
				end = end.getTime()
				break
			}
		}

		now = now.getTime()
		if (start >= end) {
			return [0, 0, 0]
		}

		var frac_passed = (now - start) / (end - start)
		frac_passed = Math.min(1, Math.max(0, frac_passed))
		return [frac_passed, Math.max(0, (now - start)), (end - start)]
	}

	fullRepresentation: TimeProgressBar {
		value: root.value
		Layout.fillWidth: Plasmoid.configuration.fillSpace
		Layout.fillHeight: Plasmoid.configuration.fillSpace
	}
}

