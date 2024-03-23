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

	property real value: 0
	property real interval: 0

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
		var val = 0
		switch (Plasmoid.configuration.timeMode) {
			case 0: // Calendar
			var calendarFunctions = [getYearProgress, getMonthProgress, getWeekProgress, getDayProgress]
			val = calendarFunctions[Plasmoid.configuration.calendarInterval]()
			break
			case 1: // Custom
			val = getCustomTimeProgress()
			break
		}
		root.value = Math.min(1, Math.max(0, val))
	}

	function getCustomTimeProgress() {
		var now = new Date()
		var start = new Date(Plasmoid.configuration.customTimeStart)
		var end = new Date(Plasmoid.configuration.customTimeEnd)
		//console.log("now:", now.toString(), ", start:", start.toString(), ", end:", end.toString())
		return (now - start) / (end - start)
	}

	function getYearProgress() {
		var now = new Date()
		var start = new Date(now.getFullYear(), 0)
		var end = new Date(now.getFullYear() + 1, 0)
		//console.log("now:", now.toString(), ", start:", start.toString(), ", end:", end.toString())
		return (now - start) / (end - start)
	}
	function getMonthProgress() {
		var now = new Date()
		var start = new Date(now.getFullYear(), now.getMonth())
		var end = new Date(now.getFullYear(), now.getMonth() + 1)
		//console.log("now:", now.toString(), ", start:", start.toString(), ", end:", end.toString())
		return (now - start) / (end - start)
	}

	function getWeekProgress() { // this one's a little different...
		var now = new Date()
		var weekDay = now.getDay()
		if (Plasmoid.configuration.weekStartsOnMonday) {
			if (weekDay === 0) { // sunday is the last day...
				weekDay = 6
			} else { // monday is the first day, so 1->0, tuesday 2->1...
				weekDay -= 1
			}
		}
		var start = new Date(now.getFullYear(), now.getMonth(), now.getDate() - weekDay)
		var end = new Date(now.getFullYear(), now.getMonth(), now.getDate() - weekDay + 7)
		//console.log("now:", now.toString(), ", start:", start.toString(), ", end:", end.toString())
		return (now - start) / (end - start)
	}

	function getDayProgress() {
		var now = new Date()
		var start = new Date(now.getFullYear(), now.getMonth(), now.getDate())
		var end = new Date(now.getFullYear(), now.getMonth(), now.getDate() + 1)
		//console.log("now:", now.toString(), ", start:", start.toString(), ", end:", end.toString())
		return (now - start) / (end - start)
	}

	fullRepresentation: TimeProgressBar {
		value: root.value
		rotation: Plasmoid.configuration.rotation
		Layout.fillWidth: true
		Layout.fillHeight: true
	}
}
