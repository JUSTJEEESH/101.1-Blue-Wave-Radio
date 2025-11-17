//
//  MusicEvent.swift
//  Blue Wave Radio Roatan
//
//  Model for music events
//

import Foundation

struct MusicEvent: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let venue: String
    let dateTime: Date
    let description: String
    let imageURL: String?
    let area: String
    let musicGenre: String
    let performer: String
    var isFavorite: Bool = false

    init(
        id: UUID = UUID(),
        title: String,
        venue: String,
        dateTime: Date,
        description: String,
        imageURL: String? = nil,
        area: String = "West End",
        musicGenre: String = "Live Music",
        performer: String = "",
        isFavorite: Bool = false
    ) {
        self.id = id
        self.title = title
        self.venue = venue
        self.dateTime = dateTime
        self.description = description
        self.imageURL = imageURL
        self.area = area
        self.musicGenre = musicGenre
        self.performer = performer
        self.isFavorite = isFavorite
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: dateTime)
    }

    var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: dateTime)
    }
}
