//
//  Restaurant.swift
//  Blue Wave Radio Roatan
//
//  Model for restaurants
//

import Foundation

struct Restaurant: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let area: IslandArea
    let cuisine: [String]
    let contact: ContactInfo
    let facebookURL: String?
    let isSponsored: Bool
    var isFavorite: Bool = false

    init(
        id: UUID = UUID(),
        name: String,
        area: IslandArea,
        cuisine: [String],
        contact: ContactInfo,
        facebookURL: String? = nil,
        isSponsored: Bool = false,
        isFavorite: Bool = false
    ) {
        self.id = id
        self.name = name
        self.area = area
        self.cuisine = cuisine
        self.contact = contact
        self.facebookURL = facebookURL
        self.isSponsored = isSponsored
        self.isFavorite = isFavorite
    }

    var cuisineString: String {
        cuisine.joined(separator: ", ")
    }
}

struct ContactInfo: Codable, Hashable {
    let phone: String?
    let email: String?
    let address: String?

    var hasContact: Bool {
        phone != nil || email != nil
    }
}

enum IslandArea: String, Codable, CaseIterable, Identifiable {
    case westEnd = "West End"
    case westBay = "West Bay"
    case sandy = "Sandy Bay"
    case french = "French Harbour"
    case oak = "Oak Ridge"
    case east = "East End"

    var id: String { rawValue }

    var displayName: String {
        rawValue
    }
}
