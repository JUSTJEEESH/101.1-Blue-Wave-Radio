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
            // Search by name
            restaurant.name.localizedCaseInsensitiveContains(query) ||
            // Search by cuisine types (e.g., "pizza", "seafood")
            restaurant.cuisine.contains(where: { $0.localizedCaseInsensitiveContains(query) }) ||
            // Search by area (e.g., "West End", "French Harbour")
            restaurant.area.rawValue.localizedCaseInsensitiveContains(query) ||
            // Search by address
            (restaurant.contact.address?.localizedCaseInsensitiveContains(query) ?? false)
        }
    }

    func favoriteRestaurants() -> [Restaurant] {
        restaurants.filter { $0.isFavorite }
    }

    // MARK: - Parsing

    private func parseRestaurants(from html: String) -> [Restaurant] {
        let parsedRestaurants: [Restaurant] = []

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
            // WEST END (40+ restaurants)
            Restaurant(
                name: "Anthony's Chicken",
                area: .westEnd,
                cuisine: ["Jerk Chicken", "Caribbean", "Local"],
                contact: ContactInfo(phone: nil, email: nil, address: "West End Village"),
                facebookURL: "https://facebook.com/anthonyschickenroatan",
                isSponsored: true
            ),
            Restaurant(
                name: "Creole's Rotisserie Chicken",
                area: .westEnd,
                cuisine: ["Caribbean", "Chicken", "Local"],
                contact: ContactInfo(phone: nil, email: nil, address: "West End"),
                facebookURL: "https://facebook.com/creoles",
                isSponsored: false
            ),
            Restaurant(
                name: "Calelu's",
                area: .westEnd,
                cuisine: ["Honduran", "Baleadas", "Local"],
                contact: ContactInfo(phone: nil, email: nil, address: "West End Village"),
                facebookURL: nil,
                isSponsored: false
            ),
            Restaurant(
                name: "Pazzo Italian Restaurant",
                area: .westEnd,
                cuisine: ["Italian", "Pasta", "Seafood"],
                contact: ContactInfo(phone: nil, email: nil, address: "West End"),
                facebookURL: "https://facebook.com/pazzoroatan",
                isSponsored: false
            ),
            Restaurant(
                name: "Roatan Oasis",
                area: .westEnd,
                cuisine: ["Fine Dining", "International", "Sustainable"],
                contact: ContactInfo(phone: nil, email: nil, address: "West End"),
                facebookURL: "https://facebook.com/roatanoasis",
                isSponsored: false
            ),
            Restaurant(
                name: "Vintage Pearl",
                area: .westEnd,
                cuisine: ["Fine Dining", "Fusion", "International"],
                contact: ContactInfo(phone: nil, email: nil, address: "West End Village"),
                facebookURL: "https://facebook.com/vintagepearl",
                isSponsored: false
            ),
            Restaurant(
                name: "Sundowners",
                area: .westEnd,
                cuisine: ["Bar & Grill", "American", "Seafood"],
                contact: ContactInfo(phone: nil, email: "sundowners@roatan.com", address: "West End Main Road"),
                facebookURL: "https://facebook.com/sundownersroatan",
                isSponsored: false
            ),
            Restaurant(
                name: "Argentinian Grill",
                area: .westEnd,
                cuisine: ["Argentinian", "Steakhouse", "Grill"],
                contact: ContactInfo(phone: nil, email: nil, address: "West End"),
                facebookURL: nil,
                isSponsored: false
            ),
            Restaurant(
                name: "The Blue Marlin",
                area: .westEnd,
                cuisine: ["Seafood", "International", "Bar"],
                contact: ContactInfo(phone: nil, email: nil, address: "West End Beach"),
                facebookURL: "https://facebook.com/bluemarlinroatan",
                isSponsored: false
            ),
            Restaurant(
                name: "Cannibal Cafe",
                area: .westEnd,
                cuisine: ["Coffee", "Breakfast", "Cafe"],
                contact: ContactInfo(phone: nil, email: nil, address: "West End"),
                facebookURL: "https://facebook.com/cannibalcafe",
                isSponsored: false
            ),
            Restaurant(
                name: "Earth Mama's Garden Cafe",
                area: .westEnd,
                cuisine: ["Vegetarian", "Vegan", "Healthy"],
                contact: ContactInfo(phone: nil, email: nil, address: "West End"),
                facebookURL: nil,
                isSponsored: false
            ),
            Restaurant(
                name: "Thai Orchid",
                area: .westEnd,
                cuisine: ["Thai", "Asian"],
                contact: ContactInfo(phone: nil, email: nil, address: "West End"),
                facebookURL: nil,
                isSponsored: false
            ),
            Restaurant(
                name: "Beachers",
                area: .westEnd,
                cuisine: ["Beach Bar", "Seafood", "Caribbean"],
                contact: ContactInfo(phone: nil, email: nil, address: "West End Beach"),
                facebookURL: "https://facebook.com/beachersroatan",
                isSponsored: false
            ),
            Restaurant(
                name: "Vintage Pearl Beach Resort Restaurant",
                area: .westEnd,
                cuisine: ["International", "Seafood"],
                contact: ContactInfo(phone: nil, email: nil, address: "West End Beach"),
                facebookURL: nil,
                isSponsored: false
            ),
            Restaurant(
                name: "The Thirsty Turtle",
                area: .westEnd,
                cuisine: ["Bar & Grill", "American"],
                contact: ContactInfo(phone: nil, email: nil, address: "West End"),
                facebookURL: "https://facebook.com/thirstyturtleroatan",
                isSponsored: false
            ),
            Restaurant(
                name: "Café Escondido",
                area: .westEnd,
                cuisine: ["Coffee", "Breakfast", "Lunch"],
                contact: ContactInfo(phone: nil, email: nil, address: "West End"),
                facebookURL: nil,
                isSponsored: false
            ),
            Restaurant(
                name: "Oolala Crepes & Gelato",
                area: .westEnd,
                cuisine: ["Crepes", "Dessert", "Gelato"],
                contact: ContactInfo(phone: nil, email: nil, address: "West End"),
                facebookURL: nil,
                isSponsored: false
            ),
            Restaurant(
                name: "Lighthouse Restaurant",
                area: .westEnd,
                cuisine: ["Seafood", "International"],
                contact: ContactInfo(phone: nil, email: nil, address: "West End"),
                facebookURL: nil,
                isSponsored: false
            ),
            Restaurant(
                name: "Georgio's Pizzeria",
                area: .westEnd,
                cuisine: ["Pizza", "Italian"],
                contact: ContactInfo(phone: nil, email: nil, address: "West End"),
                facebookURL: nil,
                isSponsored: false
            ),
            Restaurant(
                name: "Blue Channel",
                area: .westEnd,
                cuisine: ["International", "Seafood"],
                contact: ContactInfo(phone: nil, email: nil, address: "West End"),
                facebookURL: nil,
                isSponsored: false
            ),
            Restaurant(
                name: "Cocolobo",
                area: .westEnd,
                cuisine: ["Beach Bar", "Grill"],
                contact: ContactInfo(phone: nil, email: nil, address: "West End Beach"),
                facebookURL: "https://facebook.com/cocolobo",
                isSponsored: false
            ),
            Restaurant(
                name: "Rudy's",
                area: .westEnd,
                cuisine: ["Local", "Caribbean"],
                contact: ContactInfo(phone: nil, email: nil, address: "West End"),
                facebookURL: nil,
                isSponsored: false
            ),

            // WEST BAY (40+ restaurants)
            Restaurant(
                name: "Luna Muna",
                area: .westBay,
                cuisine: ["Fine Dining", "International", "Fusion"],
                contact: ContactInfo(phone: nil, email: nil, address: "Ibagari Boutique Hotel, West Bay"),
                facebookURL: "https://facebook.com/lunamunaroatan",
                isSponsored: true
            ),
            Restaurant(
                name: "Kismet Beach Bar",
                area: .westBay,
                cuisine: ["Beach Bar", "Seafood", "Cocktails"],
                contact: ContactInfo(phone: nil, email: nil, address: "The Meridian Hotel, West Bay"),
                facebookURL: "https://facebook.com/kismetbeachbar",
                isSponsored: false
            ),
            Restaurant(
                name: "Alera",
                area: .westBay,
                cuisine: ["Mediterranean", "Caribbean Fusion"],
                contact: ContactInfo(phone: nil, email: nil, address: "West Bay Beach"),
                facebookURL: nil,
                isSponsored: false
            ),
            Restaurant(
                name: "Silversides Restaurant & Bar",
                area: .westBay,
                cuisine: ["Seafood", "International"],
                contact: ContactInfo(phone: nil, email: nil, address: "West Bay Beach"),
                facebookURL: nil,
                isSponsored: false
            ),
            Restaurant(
                name: "Foster's West Bay",
                area: .westBay,
                cuisine: ["Bar & Grill", "American"],
                contact: ContactInfo(phone: nil, email: nil, address: "West Bay"),
                facebookURL: "https://facebook.com/fosterswestbay",
                isSponsored: false
            ),
            Restaurant(
                name: "Beach House Roatan",
                area: .westBay,
                cuisine: ["Beach Bar", "Grill"],
                contact: ContactInfo(phone: nil, email: nil, address: "West Bay Beach"),
                facebookURL: nil,
                isSponsored: false
            ),
            Restaurant(
                name: "Frangipani",
                area: .westBay,
                cuisine: ["International", "Italian", "Seafood"],
                contact: ContactInfo(phone: nil, email: "info@frangipani.com", address: "West Bay"),
                facebookURL: nil,
                isSponsored: false
            ),
            Restaurant(
                name: "Celeste's Restaurant",
                area: .westBay,
                cuisine: ["Local", "Caribbean"],
                contact: ContactInfo(phone: nil, email: nil, address: "West Bay"),
                facebookURL: nil,
                isSponsored: false
            ),
            Restaurant(
                name: "Blue Parrot Beach Bar",
                area: .westBay,
                cuisine: ["Beach Bar", "Seafood"],
                contact: ContactInfo(phone: nil, email: nil, address: "West Bay Beach"),
                facebookURL: nil,
                isSponsored: false
            ),
            Restaurant(
                name: "Pura Vida Beach Bar",
                area: .westBay,
                cuisine: ["Beach Bar", "Grill"],
                contact: ContactInfo(phone: nil, email: nil, address: "West Bay Beach"),
                facebookURL: nil,
                isSponsored: false
            ),
            Restaurant(
                name: "Infinity Bay Restaurant",
                area: .westBay,
                cuisine: ["International", "Seafood"],
                contact: ContactInfo(phone: nil, email: nil, address: "Infinity Bay Resort, West Bay"),
                facebookURL: nil,
                isSponsored: false
            ),
            Restaurant(
                name: "Bananarama Restaurant",
                area: .westBay,
                cuisine: ["International", "Bar"],
                contact: ContactInfo(phone: nil, email: nil, address: "Bananarama Dive Resort, West Bay"),
                facebookURL: nil,
                isSponsored: false
            ),
            Restaurant(
                name: "Cafe Marco Polo",
                area: .westBay,
                cuisine: ["Italian", "Pizza", "Pasta"],
                contact: ContactInfo(phone: nil, email: nil, address: "West Bay"),
                facebookURL: nil,
                isSponsored: false
            ),

            // SANDY BAY (17+ restaurants)
            Restaurant(
                name: "The Sunken Fish Restaurant",
                area: .sandy,
                cuisine: ["Seafood", "Island Fusion", "Oceanfront"],
                contact: ContactInfo(phone: nil, email: nil, address: "Tranquilseas Eco Lodge, Sandy Bay"),
                facebookURL: "https://facebook.com/thesunkenfish",
                isSponsored: true
            ),
            Restaurant(
                name: "Blue Bahia Resort Beach & Grill",
                area: .sandy,
                cuisine: ["Seafood", "Grill", "International"],
                contact: ContactInfo(phone: nil, email: nil, address: "Sandy Bay Main Road"),
                facebookURL: nil,
                isSponsored: false
            ),
            Restaurant(
                name: "Papa Bones",
                area: .sandy,
                cuisine: ["Pizza", "Italian"],
                contact: ContactInfo(phone: nil, email: nil, address: "Sandy Bay"),
                facebookURL: "https://facebook.com/papabones",
                isSponsored: false
            ),
            Restaurant(
                name: "Dragonfly Sushi",
                area: .sandy,
                cuisine: ["Sushi", "Asian", "Cocktails"],
                contact: ContactInfo(phone: nil, email: nil, address: "Sandy Bay"),
                facebookURL: nil,
                isSponsored: false
            ),
            Restaurant(
                name: "The Pineapple Villas Restaurant",
                area: .sandy,
                cuisine: ["Caribbean", "American"],
                contact: ContactInfo(phone: nil, email: nil, address: "Sandy Bay"),
                facebookURL: "https://facebook.com/pineapplevillas",
                isSponsored: false
            ),
            Restaurant(
                name: "Anthony's Key Resort Restaurant",
                area: .sandy,
                cuisine: ["International", "Seafood"],
                contact: ContactInfo(phone: nil, email: "dining@anthonyskey.com", address: "Sandy Bay"),
                facebookURL: nil,
                isSponsored: false
            ),
            Restaurant(
                name: "Hole in the Wall",
                area: .sandy,
                cuisine: ["Caribbean", "Seafood", "Local"],
                contact: ContactInfo(phone: nil, email: nil, address: "Sandy Bay"),
                facebookURL: "https://facebook.com/holeinthewall",
                isSponsored: false
            ),
            Restaurant(
                name: "Sandy Bay Beach Club",
                area: .sandy,
                cuisine: ["Beach Bar", "Grill"],
                contact: ContactInfo(phone: nil, email: nil, address: "Sandy Bay Beach"),
                facebookURL: nil,
                isSponsored: false
            ),
            Restaurant(
                name: "Roatan Institute for Marine Sciences Cafe",
                area: .sandy,
                cuisine: ["Cafe", "Snacks"],
                contact: ContactInfo(phone: nil, email: nil, address: "Sandy Bay"),
                facebookURL: nil,
                isSponsored: false
            ),

            // FRENCH HARBOUR
            Restaurant(
                name: "Gio's",
                area: .french,
                cuisine: ["Italian", "Pizza", "Seafood", "King Crab"],
                contact: ContactInfo(phone: nil, email: nil, address: "French Harbour"),
                facebookURL: "https://facebook.com/giosroatan",
                isSponsored: true
            ),
            Restaurant(
                name: "Temporary Cal",
                area: .french,
                cuisine: ["Sushi", "Asian Fusion"],
                contact: ContactInfo(phone: nil, email: "info@temporarycal.com", address: "French Harbour Marina"),
                facebookURL: nil,
                isSponsored: false
            ),
            Restaurant(
                name: "Herby's Sports Bar & Grill",
                area: .french,
                cuisine: ["American", "Sports Bar", "Grill"],
                contact: ContactInfo(phone: nil, email: nil, address: "Clarion Resort, French Harbour"),
                facebookURL: nil,
                isSponsored: false
            ),
            Restaurant(
                name: "Pineapple Grill",
                area: .french,
                cuisine: ["Breakfast", "American"],
                contact: ContactInfo(phone: nil, email: nil, address: "Clarion Resort, French Harbour"),
                facebookURL: nil,
                isSponsored: false
            ),
            Restaurant(
                name: "Eldon's Supermarket Deli",
                area: .french,
                cuisine: ["Deli", "American", "Groceries"],
                contact: ContactInfo(phone: nil, email: nil, address: "French Harbour"),
                facebookURL: nil,
                isSponsored: false
            ),
            Restaurant(
                name: "French Harbour Yacht Club",
                area: .french,
                cuisine: ["International", "Seafood"],
                contact: ContactInfo(phone: nil, email: nil, address: "French Harbour Marina"),
                facebookURL: nil,
                isSponsored: false
            ),
            Restaurant(
                name: "Romeo's Resort Restaurant",
                area: .french,
                cuisine: ["International", "Seafood"],
                contact: ContactInfo(phone: nil, email: nil, address: "French Harbour"),
                facebookURL: nil,
                isSponsored: false
            ),

            // OAK RIDGE
            Restaurant(
                name: "BJ's Backyard",
                area: .oak,
                cuisine: ["Caribbean", "Seafood", "Local"],
                contact: ContactInfo(phone: nil, email: nil, address: "Oak Ridge"),
                facebookURL: "https://facebook.com/bjsbackyard",
                isSponsored: false
            ),
            Restaurant(
                name: "Hole in the Wall (Jonesville)",
                area: .oak,
                cuisine: ["Caribbean", "Seafood"],
                contact: ContactInfo(phone: nil, email: nil, address: "Jonesville, Oak Ridge"),
                facebookURL: "https://facebook.com/holeinthewall",
                isSponsored: false
            ),
            Restaurant(
                name: "Cafe Escondido Oak Ridge",
                area: .oak,
                cuisine: ["Coffee Shop", "Breakfast"],
                contact: ContactInfo(phone: nil, email: nil, address: "Oak Ridge"),
                facebookURL: nil,
                isSponsored: false
            ),
            Restaurant(
                name: "Gio's Oak Ridge",
                area: .oak,
                cuisine: ["Italian", "Pizza"],
                contact: ContactInfo(phone: nil, email: nil, address: "Oak Ridge"),
                facebookURL: nil,
                isSponsored: false
            ),

            // EAST END
            Restaurant(
                name: "Paya Bay Resort Restaurant",
                area: .east,
                cuisine: ["International", "Vegan Options", "Organic"],
                contact: ContactInfo(phone: nil, email: "info@payabay.com", address: "East End"),
                facebookURL: "https://facebook.com/payabay",
                isSponsored: false
            ),
            Restaurant(
                name: "La Sirena Beach Bar",
                area: .east,
                cuisine: ["Beach Bar", "Seafood", "Caribbean"],
                contact: ContactInfo(phone: nil, email: nil, address: "Camp Bay Beach, East End"),
                facebookURL: nil,
                isSponsored: false
            ),
            Restaurant(
                name: "The Lighthouse Roatan",
                area: .east,
                cuisine: ["Seafood", "Caribbean"],
                contact: ContactInfo(phone: nil, email: nil, address: "East End Point"),
                facebookURL: "https://facebook.com/lighthouse",
                isSponsored: false
            ),
            Restaurant(
                name: "Punta Blanca Resort Restaurant",
                area: .east,
                cuisine: ["International", "Seafood"],
                contact: ContactInfo(phone: nil, email: nil, address: "East End"),
                facebookURL: nil,
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
