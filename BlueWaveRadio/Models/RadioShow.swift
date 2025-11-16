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
}

// Hardcoded programming schedule
extension RadioShow {
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
