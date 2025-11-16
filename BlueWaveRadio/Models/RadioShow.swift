//
//  RadioShow.swift
//  Blue Wave Radio Roatan
//
//  Model for radio shows
//

import Foundation

struct RadioShow: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let startTime: String
    let endTime: String
    let description: String
    let sponsor: String?
    let dayOfWeek: String
    let iconName: String

    init(
        id: UUID = UUID(),
        name: String,
        startTime: String,
        endTime: String,
        description: String,
        sponsor: String? = nil,
        dayOfWeek: String,
        iconName: String = "radio"
    ) {
        self.id = id
        self.name = name
        self.startTime = startTime
        self.endTime = endTime
        self.description = description
        self.sponsor = sponsor
        self.dayOfWeek = dayOfWeek
        self.iconName = iconName
    }

    var timeRange: String {
        "\(startTime) - \(endTime)"
    }

    // Check if this show is currently airing
    func isCurrentlyAiring() -> Bool {
        let now = Date()
        let calendar = Calendar.current
        let currentDay = calendar.component(.weekday, from: now)

        // Check if today matches the show's day of week
        let showDays = parseDayOfWeek()
        guard showDays.contains(currentDay) else {
            return false
        }

        // Parse times and check if current time is within the show's time range
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        guard let startDate = formatter.date(from: startTime),
              let endDate = formatter.date(from: endTime) else {
            return false
        }

        // Get current time components
        let currentHour = calendar.component(.hour, from: now)
        let currentMinute = calendar.component(.minute, from: now)

        // Get show time components
        let startHour = calendar.component(.hour, from: startDate)
        let startMinute = calendar.component(.minute, from: startDate)
        let endHour = calendar.component(.hour, from: endDate)
        let endMinute = calendar.component(.minute, from: endDate)

        // Create comparable time values (minutes since midnight)
        let currentTimeInMinutes = currentHour * 60 + currentMinute
        let startTimeInMinutes = startHour * 60 + startMinute
        let endTimeInMinutes = endHour * 60 + endMinute

        return currentTimeInMinutes >= startTimeInMinutes && currentTimeInMinutes < endTimeInMinutes
    }

    // Parse dayOfWeek string to weekday numbers (1 = Sunday, 2 = Monday, etc.)
    private func parseDayOfWeek() -> [Int] {
        let lowercased = dayOfWeek.lowercased()

        if lowercased.contains("daily") || lowercased.contains("every day") {
            return [1, 2, 3, 4, 5, 6, 7] // All days
        } else if lowercased.contains("monday-friday") || lowercased.contains("weekday") {
            return [2, 3, 4, 5, 6] // Monday through Friday
        } else if lowercased.contains("weekend") {
            return [1, 7] // Saturday and Sunday
        } else {
            // Parse individual days
            var days: [Int] = []
            if lowercased.contains("sunday") { days.append(1) }
            if lowercased.contains("monday") { days.append(2) }
            if lowercased.contains("tuesday") { days.append(3) }
            if lowercased.contains("wednesday") { days.append(4) }
            if lowercased.contains("thursday") { days.append(5) }
            if lowercased.contains("friday") { days.append(6) }
            if lowercased.contains("saturday") { days.append(7) }
            return days
        }
    }
}

// Hardcoded programming schedule
extension RadioShow {
    // Get the currently airing show
    static func getCurrentShow() -> RadioShow? {
        return schedule.first { $0.isCurrentlyAiring() }
    }

    static let schedule: [RadioShow] = [
        RadioShow(
            name: "Madison and Martina por la Manana",
            startTime: "7:00 AM",
            endTime: "11:00 AM",
            description: "Wake up with Madison and Martina! Morning talk, island news, and great music.",
            sponsor: nil,
            dayOfWeek: "Monday-Friday",
            iconName: "sunrise"
        ),
        RadioShow(
            name: "Mandatory Marley at 4:20",
            startTime: "4:20 PM",
            endTime: "4:30 PM",
            description: "Your daily dose of reggae legend Bob Marley.",
            sponsor: nil,
            dayOfWeek: "Daily",
            iconName: "leaf"
        ),
        RadioShow(
            name: "Five Decades at 5",
            startTime: "5:00 PM",
            endTime: "6:00 PM",
            description: "Classic hits spanning five decades of music.",
            sponsor: nil,
            dayOfWeek: "Daily",
            iconName: "music.note"
        ),
        RadioShow(
            name: "Salsa at Sunset",
            startTime: "6:00 PM",
            endTime: "8:00 PM",
            description: "Spice up your evening with Latin rhythms as the sun sets over the Caribbean.",
            sponsor: "Umbul Umbul",
            dayOfWeek: "Daily",
            iconName: "sunset"
        ),
        RadioShow(
            name: "Deep Tracks",
            startTime: "9:00 PM",
            endTime: "11:00 PM",
            description: "Dive deep into album cuts and lesser-known gems.",
            sponsor: nil,
            dayOfWeek: "Monday-Friday",
            iconName: "waveform"
        )
    ]
}
