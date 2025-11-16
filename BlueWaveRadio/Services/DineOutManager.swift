//
//  DineOutManager.swift
//  Blue Wave Radio Roatan
//
//  Service for fetching and parsing restaurant data
//

import Foundation
import Combine

@MainActor
class DineOutManager: ObservableObject {
    private let dineOutURL = URL(string: "https://www.dineoutroatan.com/")!
    private let cacheKey = "cached_restaurants"
    private let lastUpdateKey = "restaurants_last_update"

    @Published var restaurants: [Restaurant] = []
    @Published var isLoading = false
    @Published var lastUpdated: Date?
    @Published var errorMessage: String?

    init() {
        loadCachedRestaurants()
    }

    // MARK: - Public Methods

    func fetchRestaurants() async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: dineOutURL)
            let htmlString = String(data: data, encoding: .utf8) ?? ""

            let parsedRestaurants = parseRestaurants(from: htmlString)

            await MainActor.run {
                if parsedRestaurants.isEmpty {
                    self.restaurants = self.createPlaceholderRestaurants()
                } else {
                    self.restaurants = parsedRestaurants
                }
                self.isLoading = false
                self.lastUpdated = Date()
                self.cacheRestaurants()
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to fetch restaurants: \(error.localizedDescription)"
                self.isLoading = false
                if self.restaurants.isEmpty {
                    self.restaurants = self.createPlaceholderRestaurants()
                }
            }
        }
    }

    func toggleFavorite(_ restaurant: Restaurant) {
        if let index = restaurants.firstIndex(where: { $0.id == restaurant.id }) {
            restaurants[index].isFavorite.toggle()
            cacheRestaurants()
        }
    }

    func restaurantsByArea(_ area: IslandArea) -> [Restaurant] {
        restaurants.filter { $0.area == area }
    }

    func searchRestaurants(query: String) -> [Restaurant] {
        guard !query.isEmpty else { return restaurants }

        return restaurants.filter { restaurant in
            restaurant.name.localizedCaseInsensitiveContains(query) ||
            restaurant.cuisine.contains(where: { $0.localizedCaseInsensitiveContains(query) }) ||
            restaurant.area.rawValue.localizedCaseInsensitiveContains(query)
        }
    }

    // MARK: - Parsing

    private func parseRestaurants(from html: String) -> [Restaurant] {
        var parsedRestaurants: [Restaurant] = []

        // This is a simplified parser for demonstration
        // In production, you'd want a proper HTML parser library

        let lines = html.components(separatedBy: .newlines)

        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)

            // Look for restaurant entries - customize based on actual HTML structure
            if trimmed.contains("restaurant") || trimmed.contains("dining") {
                // Extract restaurant information
                // This is placeholder logic - actual implementation would parse the HTML structure
            }
        }

        return parsedRestaurants
    }

    // MARK: - Placeholder Restaurants

    private func createPlaceholderRestaurants() -> [Restaurant] {
        return [
            // West End
            Restaurant(
                name: "The Blue Marlin",
                area: .westEnd,
                cuisine: ["Seafood", "International"],
                contact: ContactInfo(phone: "+504 9999-9999", email: "info@bluemarlin.com", address: "West End Beach"),
                facebookURL: "https://facebook.com/bluemarlin",
                isSponsored: true
            ),
            Restaurant(
                name: "Vintage Pearl",
                area: .westEnd,
                cuisine: ["Fine Dining", "Fusion"],
                contact: ContactInfo(phone: "+504 9999-9998", email: nil, address: "West End Village"),
                facebookURL: "https://facebook.com/vintagepearl",
                isSponsored: false
            ),
            Restaurant(
                name: "Sundowners",
                area: .westEnd,
                cuisine: ["Bar & Grill", "American"],
                contact: ContactInfo(phone: "+504 9999-9997", email: "sundowners@roatan.com", address: "West End Main Road"),
                facebookURL: nil,
                isSponsored: false
            ),

            // West Bay
            Restaurant(
                name: "Beachers",
                area: .westBay,
                cuisine: ["Caribbean", "Seafood"],
                contact: ContactInfo(phone: "+504 9999-9996", email: nil, address: "West Bay Beach"),
                facebookURL: "https://facebook.com/beachers",
                isSponsored: false
            ),
            Restaurant(
                name: "Frangipani",
                area: .westBay,
                cuisine: ["International", "Italian"],
                contact: ContactInfo(phone: "+504 9999-9995", email: "info@frangipani.com", address: "West Bay"),
                facebookURL: nil,
                isSponsored: true
            ),

            // Sandy Bay
            Restaurant(
                name: "The Pineapple Villas Restaurant",
                area: .sandy,
                cuisine: ["Caribbean", "American"],
                contact: ContactInfo(phone: "+504 9999-9994", email: nil, address: "Sandy Bay"),
                facebookURL: "https://facebook.com/pineapplevillas",
                isSponsored: false
            ),
            Restaurant(
                name: "Anthony's Key Resort",
                area: .sandy,
                cuisine: ["International", "Seafood"],
                contact: ContactInfo(phone: "+504 9999-9993", email: "dining@anthonyskey.com", address: "Sandy Bay"),
                facebookURL: nil,
                isSponsored: false
            ),

            // French Harbour
            Restaurant(
                name: "Gio's",
                area: .french,
                cuisine: ["Italian", "Pizza"],
                contact: ContactInfo(phone: "+504 9999-9992", email: nil, address: "French Harbour"),
                facebookURL: "https://facebook.com/giosroatan",
                isSponsored: false
            ),
            Restaurant(
                name: "Temporary Cal",
                area: .french,
                cuisine: ["Sushi", "Asian Fusion"],
                contact: ContactInfo(phone: "+504 9999-9991", email: "info@temporarycal.com", address: "French Harbour Marina"),
                facebookURL: nil,
                isSponsored: true
            ),
            Restaurant(
                name: "Eldon's Supermarket Deli",
                area: .french,
                cuisine: ["Deli", "American"],
                contact: ContactInfo(phone: "+504 9999-9990", email: nil, address: "French Harbour"),
                facebookURL: nil,
                isSponsored: false
            ),

            // Oak Ridge
            Restaurant(
                name: "Hole in the Wall",
                area: .oak,
                cuisine: ["Caribbean", "Seafood"],
                contact: ContactInfo(phone: "+504 9999-9989", email: nil, address: "Oak Ridge"),
                facebookURL: "https://facebook.com/holeinthewall",
                isSponsored: false
            ),
            Restaurant(
                name: "Café Escondido",
                area: .oak,
                cuisine: ["Coffee Shop", "Breakfast"],
                contact: ContactInfo(phone: "+504 9999-9988", email: nil, address: "Oak Ridge"),
                facebookURL: nil,
                isSponsored: false
            ),

            // East End
            Restaurant(
                name: "Paya Bay Resort",
                area: .east,
                cuisine: ["International", "Vegan Options"],
                contact: ContactInfo(phone: "+504 9999-9987", email: "info@payabay.com", address: "East End"),
                facebookURL: nil,
                isSponsored: false
            ),
            Restaurant(
                name: "The Lighthouse",
                area: .east,
                cuisine: ["Seafood", "Caribbean"],
                contact: ContactInfo(phone: "+504 9999-9986", email: nil, address: "East End Point"),
                facebookURL: "https://facebook.com/lighthouse",
                isSponsored: false
            )
        ]
    }

    // MARK: - Caching

    private func cacheRestaurants() {
        if let encoded = try? JSONEncoder().encode(restaurants) {
            UserDefaults.standard.set(encoded, forKey: cacheKey)
            UserDefaults.standard.set(Date(), forKey: lastUpdateKey)
        }
    }

    private func loadCachedRestaurants() {
        if let data = UserDefaults.standard.data(forKey: cacheKey),
           let decoded = try? JSONDecoder().decode([Restaurant].self, from: data) {
            self.restaurants = decoded
            self.lastUpdated = UserDefaults.standard.object(forKey: lastUpdateKey) as? Date
        }
    }
}
