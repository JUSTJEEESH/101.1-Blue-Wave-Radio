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
        // WEEKDAY SHOWS (Monday-Friday)
        RadioShow(
            name: "Madison and Martina por la Mañana",
            startTime: "6:00 AM",
            endTime: "10:00 AM",
            description: "Wake up your mornings with \"The Thought of the Day,\" \"Living Social in an Anti-Social World,\" \"Roatan Topix,\" \"Would YOU Rather,\" \"The Not Quite the News,\" and \"Roatan Horrible Scopes,\" plus a lighthearted look at island life. Hosted by Madison & Martina.",
            sponsor: nil,
            dayOfWeek: "Monday-Friday",
            iconName: "sunrise.fill"
        ),
        RadioShow(
            name: "Mandatory Marley at 4:20",
            startTime: "4:20 PM",
            endTime: "4:30 PM",
            description: "Two back-to-back reggae songs every weekday at 4:20.",
            sponsor: "Umbul Umbul – Fine Home Furnishings, Gifts, and More",
            dayOfWeek: "Monday-Friday",
            iconName: "leaf.fill"
        ),
        RadioShow(
            name: "Five Decades at 5",
            startTime: "5:00 PM",
            endTime: "6:00 PM",
            description: "An hour of the greatest rock ever made—from The Beatles to Led Zeppelin.",
            sponsor: "Sotheby's Roatan Island Real Estate",
            dayOfWeek: "Monday-Friday",
            iconName: "guitars"
        ),
        RadioShow(
            name: "Salsa at Sunset",
            startTime: "6:00 PM",
            endTime: "7:00 PM",
            description: "Salsa, Bachata, and Island vibes with Grammy-nominated host Joel Escalona.",
            sponsor: "Chin Chelete",
            dayOfWeek: "Monday-Friday",
            iconName: "sunset.fill"
        ),
        RadioShow(
            name: "Monsters of Rock – El Monstruos del Mundo",
            startTime: "7:00 PM",
            endTime: "8:00 PM",
            description: "R2 K2 (Russ Regentz & Kyle Kuhlmeyer) deliver hard-hitting rock with attitude—Metallica, Van Halen, Mötley Crüe and more.",
            sponsor: nil,
            dayOfWeek: "Monday-Friday",
            iconName: "bolt.fill"
        ),
        RadioShow(
            name: "LIVE in the Dragonfly Lounge",
            startTime: "8:00 PM",
            endTime: "10:00 PM",
            description: "Curated evening selections from the Dragonfly Lounge Collection.",
            sponsor: "Dragonfly Rolls Sushi",
            dayOfWeek: "Monday-Friday",
            iconName: "music.note.list"
        ),

        // SATURDAY SHOWS
        RadioShow(
            name: "Caribbean Castaway",
            startTime: "10:00 AM",
            endTime: "11:00 AM",
            description: "Inspired by Desert Island Discs—guests choose the 8 songs they'd take to a stranded Caribbean island. Archives available.",
            sponsor: nil,
            dayOfWeek: "Saturday",
            iconName: "figure.walk"
        ),
        RadioShow(
            name: "Caribbean Castaway",
            startTime: "5:00 PM",
            endTime: "6:00 PM",
            description: "Inspired by Desert Island Discs—guests choose the 8 songs they'd take to a stranded Caribbean island. Archives available.",
            sponsor: nil,
            dayOfWeek: "Saturday",
            iconName: "figure.walk"
        ),
        RadioShow(
            name: "Radio Reggae with Pete the Beat",
            startTime: "6:00 PM",
            endTime: "8:00 PM",
            description: "The most-listened-to reggae show in Latin America. Pete the Beat explores reggae from around the world.",
            sponsor: "Paradise Beach Hotel",
            dayOfWeek: "Saturday",
            iconName: "waveform.path"
        ),
        RadioShow(
            name: "LIVE in the Dragonfly Lounge",
            startTime: "8:00 PM",
            endTime: "9:00 PM",
            description: "Curated evening selections from the Dragonfly Lounge Collection.",
            sponsor: "Dragonfly Rolls Sushi",
            dayOfWeek: "Saturday",
            iconName: "music.note.list"
        ),
        RadioShow(
            name: "Caribbean Castaway",
            startTime: "9:00 PM",
            endTime: "10:00 PM",
            description: "Inspired by Desert Island Discs—guests choose the 8 songs they'd take to a stranded Caribbean island. Archives available.",
            sponsor: nil,
            dayOfWeek: "Saturday",
            iconName: "figure.walk"
        ),
        RadioShow(
            name: "Little Steven's Underground Garage",
            startTime: "10:00 PM",
            endTime: "12:00 AM",
            description: "Rock history through the lens of Steve Van Zandt of the E-Street Band—deep cuts, vinyl-era influences, and pure music geekdom.",
            sponsor: nil,
            dayOfWeek: "Saturday",
            iconName: "car.fill"
        ),

        // SUNDAY SHOWS
        RadioShow(
            name: "Acoustic Café",
            startTime: "8:00 AM",
            endTime: "10:00 AM",
            description: "Hosted by Rob Reinhart since 1995. A mix of rock, folk, blues, pop, and more.",
            sponsor: "Montecillo's Coffee",
            dayOfWeek: "Sunday",
            iconName: "cup.and.saucer.fill"
        ),
        RadioShow(
            name: "Cruisin' the Decades",
            startTime: "10:00 AM",
            endTime: "11:00 AM",
            description: "A 100-year journey through recorded music—one song per decade from the 1920s to the 2020s. Created by Brad Savage.",
            sponsor: nil,
            dayOfWeek: "Sunday",
            iconName: "calendar"
        ),
        RadioShow(
            name: "The Bay Islands Blues Hour",
            startTime: "11:00 AM",
            endTime: "12:00 PM",
            description: "Marco Trezza guides listeners through timeless blues, modern variations, and exclusive performances from the Marco de Sade Band.",
            sponsor: nil,
            dayOfWeek: "Sunday",
            iconName: "music.quarternote.3"
        ),
        RadioShow(
            name: "Radio Reggae with Pete the Beat",
            startTime: "6:00 PM",
            endTime: "8:00 PM",
            description: "The most-listened-to reggae show in Latin America. Pete the Beat explores reggae from around the world.",
            sponsor: "Paradise Beach Hotel",
            dayOfWeek: "Sunday",
            iconName: "waveform.path"
        ),
        RadioShow(
            name: "LIVE in the Dragonfly Lounge",
            startTime: "8:00 PM",
            endTime: "9:00 PM",
            description: "Curated evening selections from the Dragonfly Lounge Collection.",
            sponsor: "Dragonfly Rolls Sushi",
            dayOfWeek: "Sunday",
            iconName: "music.note.list"
        )
    ]
}
