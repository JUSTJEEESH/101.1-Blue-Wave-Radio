//
//  MusicSceneManager.swift
//  Blue Wave Radio Roatan
//
//  Service for fetching and parsing music events
//

import Foundation
import Combine

@MainActor
class MusicSceneManager: ObservableObject {
    private let musicSceneURL = URL(string: "https://www.bluewaveradio.live/roatanmusicscene")!
    private let cacheKey = "cached_music_events"
    private let lastUpdateKey = "music_events_last_update"

    @Published var events: [MusicEvent] = []
    @Published var isLoading = false
    @Published var lastUpdated: Date?
    @Published var errorMessage: String?

    init() {
        loadCachedEvents()
    }

    // MARK: - Public Methods

    func fetchEvents() async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: musicSceneURL)
            let htmlString = String(data: data, encoding: .utf8) ?? ""

            let parsedEvents = parseEvents(from: htmlString)

            await MainActor.run {
                if parsedEvents.isEmpty {
                    // Use fallback/placeholder
                    self.events = self.createPlaceholderEvents()
                } else {
                    self.events = parsedEvents
                }
                self.isLoading = false
                self.lastUpdated = Date()
                self.cacheEvents()
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to fetch music events: \(error.localizedDescription)"
                self.isLoading = false
                // Use cached data if available
                if self.events.isEmpty {
                    self.events = self.createPlaceholderEvents()
                }
            }
        }
    }

    func toggleFavorite(_ event: MusicEvent) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events[index].isFavorite.toggle()
            cacheEvents()
        }
    }

    func favoriteEvents() -> [MusicEvent] {
        events.filter { $0.isFavorite }
    }

    // MARK: - Parsing

    private func parseEvents(from html: String) -> [MusicEvent] {
        var parsedEvents: [MusicEvent] = []

        // Look for the schedule content after "Loading Schedule . . ."
        // This is a simplified parser - in production you'd use a proper HTML parser

        // Split by common event delimiters
        let lines = html.components(separatedBy: .newlines)
        var currentEvent: (title: String?, venue: String?, time: String?, date: String?)? = nil

        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)

            // Skip empty lines
            if trimmed.isEmpty { continue }

            // Look for patterns that might indicate event information
            // This is a basic implementation - customize based on actual HTML structure

            if trimmed.contains("<h3") || trimmed.contains("<h4") {
                // Likely a title
                let title = stripHTMLTags(from: trimmed)
                if !title.isEmpty {
                    currentEvent?.title = title
                }
            } else if trimmed.contains("venue") || trimmed.contains("location") {
                let venue = stripHTMLTags(from: trimmed)
                if !venue.isEmpty {
                    currentEvent?.venue = venue
                }
            } else if trimmed.contains("time") || trimmed.contains("pm") || trimmed.contains("am") {
                let time = stripHTMLTags(from: trimmed)
                if !time.isEmpty {
                    currentEvent?.time = time
                }
            }

            // When we have enough info, create an event
            if let event = currentEvent,
               let title = event.title,
               let venue = event.venue {

                let dateTime = parseDateTime(from: event.date ?? "", time: event.time ?? "")

                let musicEvent = MusicEvent(
                    title: title,
                    venue: venue,
                    dateTime: dateTime,
                    description: "Live music at \(venue)",
                    imageURL: nil,
                    area: "West End", // Default, would be parsed from HTML in production
                    musicGenre: "Live Music", // Default, would be parsed from HTML in production
                    performer: "" // Default, would be parsed from HTML in production
                )
                parsedEvents.append(musicEvent)
                currentEvent = nil
            }
        }

        return parsedEvents
    }

    private func stripHTMLTags(from html: String) -> String {
        var result = html
        // Remove HTML tags
        result = result.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
        // Decode HTML entities
        result = result.replacingOccurrences(of: "&nbsp;", with: " ")
        result = result.replacingOccurrences(of: "&amp;", with: "&")
        result = result.replacingOccurrences(of: "&quot;", with: "\"")
        result = result.replacingOccurrences(of: "&#39;", with: "'")
        result = result.replacingOccurrences(of: "&lt;", with: "<")
        result = result.replacingOccurrences(of: "&gt;", with: ">")
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func parseDateTime(from dateString: String, time timeString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d"

        if let date = dateFormatter.date(from: dateString) {
            // Adjust to current year
            var components = Calendar.current.dateComponents([.month, .day], from: date)
            components.year = Calendar.current.component(.year, from: Date())

            if let fullDate = Calendar.current.date(from: components) {
                return fullDate
            }
        }

        // Default to next Saturday
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        let daysUntilSaturday = (7 - weekday + 7) % 7
        return calendar.date(byAdding: .day, value: daysUntilSaturday, to: today) ?? today
    }

    // MARK: - Placeholder Events

    private func createPlaceholderEvents() -> [MusicEvent] {
        let calendar = Calendar.current
        let today = Date()

        // Helper to create date at specific hour
        func dateAt(daysFromToday: Int, hour: Int = 19) -> Date {
            var components = calendar.dateComponents([.year, .month, .day], from: calendar.date(byAdding: .day, value: daysFromToday, to: today) ?? today)
            components.hour = hour
            components.minute = 0
            return calendar.date(from: components) ?? today
        }

        return [
            // TODAY - Various Areas
            MusicEvent(
                title: "Acoustic Sunset",
                venue: "Sundowners",
                dateTime: dateAt(daysFromToday: 0, hour: 17),
                description: "Enjoy acoustic guitar and vocals as the sun sets over the Caribbean.",
                area: "West End",
                musicGenre: "Acoustic",
                performer: "Mike Thompson"
            ),
            MusicEvent(
                title: "Jazz Night",
                venue: "The Blue Marlin",
                dateTime: dateAt(daysFromToday: 0, hour: 19),
                description: "Smooth jazz and cocktails in an intimate waterfront setting.",
                area: "West End",
                musicGenre: "Jazz",
                performer: "Island Jazz Trio"
            ),
            MusicEvent(
                title: "Reggae Thursday",
                venue: "Half Moon Bay Resort",
                dateTime: dateAt(daysFromToday: 0, hour: 20),
                description: "Classic reggae vibes on the beach with local bands.",
                area: "West Bay",
                musicGenre: "Reggae",
                performer: "Roatan Roots Band"
            ),

            // TOMORROW - Weekend Kickoff
            MusicEvent(
                title: "Friday Night Live",
                venue: "Foster's West End",
                dateTime: dateAt(daysFromToday: 1, hour: 20),
                description: "Live rock and pop covers to kick off the weekend.",
                area: "West End",
                musicGenre: "Rock/Pop",
                performer: "The Island Rockers"
            ),
            MusicEvent(
                title: "Karaoke Night",
                venue: "Vintage Pearl",
                dateTime: dateAt(daysFromToday: 1, hour: 21),
                description: "Sing your heart out at the island's favorite karaoke spot.",
                area: "Sandy Bay",
                musicGenre: "Karaoke",
                performer: "DJ Carlos"
            ),
            MusicEvent(
                title: "Latin Dance Party",
                venue: "Temporary Cal's Cantina",
                dateTime: dateAt(daysFromToday: 1, hour: 22),
                description: "Salsa, merengue, and bachata with live Latin band.",
                area: "West Bay",
                musicGenre: "Latin",
                performer: "Los Caribenos"
            ),

            // SATURDAY - Full Weekend
            MusicEvent(
                title: "Beach BBQ & Blues",
                venue: "Infinity Bay Resort",
                dateTime: dateAt(daysFromToday: 2, hour: 18),
                description: "Beachfront BBQ with live blues music and ocean views.",
                area: "West Bay",
                musicGenre: "Blues",
                performer: "Blue Wave Blues Band"
            ),
            MusicEvent(
                title: "DJ Night at Sundowners",
                venue: "Sundowners",
                dateTime: dateAt(daysFromToday: 2, hour: 21),
                description: "Dance the night away with top island DJs spinning house and electronic.",
                area: "West End",
                musicGenre: "Electronic/House",
                performer: "DJ Tropix"
            ),
            MusicEvent(
                title: "Live Band Saturdays",
                venue: "Barefoot Cay Resort",
                dateTime: dateAt(daysFromToday: 2, hour: 19),
                description: "Weekly live band featuring classic rock, country, and island favorites.",
                area: "French Harbour",
                musicGenre: "Rock/Country",
                performer: "Barefoot Band"
            ),
            MusicEvent(
                title: "Reggae & Rum",
                venue: "West Bay Beach Bar",
                dateTime: dateAt(daysFromToday: 2, hour: 17),
                description: "Reggae rhythms and rum cocktails on the beach.",
                area: "West Bay",
                musicGenre: "Reggae",
                performer: "Island Vibe Collective"
            ),
            MusicEvent(
                title: "Acoustic Sessions",
                venue: "Beso del Sol",
                dateTime: dateAt(daysFromToday: 2, hour: 18),
                description: "Intimate acoustic performances with talented local musicians.",
                area: "Oak Ridge",
                musicGenre: "Acoustic",
                performer: "Sarah Williams"
            ),

            // SUNDAY - Weekend Wrap
            MusicEvent(
                title: "Sunday Funday",
                venue: "Sundowners",
                dateTime: dateAt(daysFromToday: 3, hour: 15),
                description: "Afternoon party with DJ, beach games, and island vibes.",
                area: "West End",
                musicGenre: "Variety/DJ",
                performer: "DJ Island Mike"
            ),
            MusicEvent(
                title: "Sunday Sunset Serenade",
                venue: "The Blue Marlin",
                dateTime: dateAt(daysFromToday: 3, hour: 17),
                description: "Mellow acoustic tunes as you watch the sunset.",
                area: "West End",
                musicGenre: "Acoustic",
                performer: "Tom & Friends"
            ),
            MusicEvent(
                title: "Beach Bonfire Jam",
                venue: "Bananarama Resort",
                dateTime: dateAt(daysFromToday: 3, hour: 19),
                description: "Beach bonfire with live music and s'mores.",
                area: "West Bay",
                musicGenre: "Folk/Island",
                performer: "Open Mic Night"
            ),

            // MONDAY
            MusicEvent(
                title: "Monday Night Blues",
                venue: "Foster's West End",
                dateTime: dateAt(daysFromToday: 4, hour: 19),
                description: "Start your week with soulful blues music.",
                area: "West End",
                musicGenre: "Blues",
                performer: "The Monday Blues Band"
            ),
            MusicEvent(
                title: "Trivia & Tunes",
                venue: "Vintage Pearl",
                dateTime: dateAt(daysFromToday: 4, hour: 20),
                description: "Test your knowledge with live music breaks.",
                area: "Sandy Bay",
                musicGenre: "Variety",
                performer: "DJ Quiz Master"
            ),

            // TUESDAY
            MusicEvent(
                title: "Taco Tuesday Live",
                venue: "Temporary Cal's Cantina",
                dateTime: dateAt(daysFromToday: 5, hour: 18),
                description: "Tacos and live mariachi music.",
                area: "West Bay",
                musicGenre: "Mariachi/Latin",
                performer: "Mariachi Roatan"
            ),
            MusicEvent(
                title: "Open Mic Night",
                venue: "Sundowners",
                dateTime: dateAt(daysFromToday: 5, hour: 20),
                description: "Show off your talent or just enjoy the performances.",
                area: "West End",
                musicGenre: "Variety/Open Mic",
                performer: "Various Artists"
            ),

            // WEDNESDAY
            MusicEvent(
                title: "Wine & Jazz Wednesday",
                venue: "The Blue Marlin",
                dateTime: dateAt(daysFromToday: 6, hour: 19),
                description: "Sophisticated evening of wine tasting and smooth jazz.",
                area: "West End",
                musicGenre: "Jazz",
                performer: "The Smooth Cats"
            ),
            MusicEvent(
                title: "Reggae Midweek",
                venue: "Beachers",
                dateTime: dateAt(daysFromToday: 6, hour: 20),
                description: "Midweek reggae to get you through to the weekend.",
                area: "Sandy Bay",
                musicGenre: "Reggae",
                performer: "Irie Vibes"
            ),
            MusicEvent(
                title: "Acoustic Wednesday",
                venue: "Pura Vida",
                dateTime: dateAt(daysFromToday: 6, hour: 18),
                description: "Mellow acoustic music in a cozy atmosphere.",
                area: "Punta Gorda",
                musicGenre: "Acoustic",
                performer: "Local Legends"
            ),

            // ADDITIONAL WEEKLY EVENTS - Various Locations
            MusicEvent(
                title: "Caribbean Night",
                venue: "Hole in the Wall",
                dateTime: dateAt(daysFromToday: 0, hour: 19),
                description: "Authentic Caribbean music and cuisine on the east end.",
                area: "East End",
                musicGenre: "Caribbean/Soca",
                performer: "East End All-Stars"
            ),
            MusicEvent(
                title: "Country Night",
                venue: "The Rusty Fish",
                dateTime: dateAt(daysFromToday: 1, hour: 20),
                description: "Country music and line dancing.",
                area: "French Harbour",
                musicGenre: "Country",
                performer: "Island Cowboys"
            ),
            MusicEvent(
                title: "Island Classics",
                venue: "Herby's Sports Bar",
                dateTime: dateAt(daysFromToday: 2, hour: 19),
                description: "Classic island tunes and local favorites.",
                area: "French Harbour",
                musicGenre: "Island/Reggae",
                performer: "Herby's House Band"
            ),
            MusicEvent(
                title: "Beach Party Thursdays",
                venue: "Lost Paradise Inn",
                dateTime: dateAt(daysFromToday: 0, hour: 18),
                description: "Weekly beach party with DJ and dancing.",
                area: "Sandy Bay",
                musicGenre: "Dance/Electronic",
                performer: "DJ Sunset"
            ),
            MusicEvent(
                title: "Live Acoustic Fridays",
                venue: "Roatan Oasis",
                dateTime: dateAt(daysFromToday: 1, hour: 19),
                description: "Unplugged performances in a relaxed setting.",
                area: "Sandy Bay",
                musicGenre: "Acoustic/Folk",
                performer: "The Wanderers"
            ),
            MusicEvent(
                title: "Salsa Saturdays",
                venue: "Henry Morgan Resort",
                dateTime: dateAt(daysFromToday: 2, hour: 20),
                description: "Latin dance night with salsa lessons included.",
                area: "West End",
                musicGenre: "Latin/Salsa",
                performer: "Salsa Caliente Band"
            ),
            MusicEvent(
                title: "Sunday Brunch Jazz",
                venue: "Casa Romeo",
                dateTime: dateAt(daysFromToday: 3, hour: 11),
                description: "Elegant Sunday brunch with live jazz music.",
                area: "West Bay",
                musicGenre: "Jazz",
                performer: "Brunch Jazz Ensemble"
            )
        ]
    }

    // MARK: - Caching

    private func cacheEvents() {
        if let encoded = try? JSONEncoder().encode(events) {
            UserDefaults.standard.set(encoded, forKey: cacheKey)
            UserDefaults.standard.set(Date(), forKey: lastUpdateKey)
        }
    }

    private func loadCachedEvents() {
        if let data = UserDefaults.standard.data(forKey: cacheKey),
           let decoded = try? JSONDecoder().decode([MusicEvent].self, from: data) {
            self.events = decoded
            self.lastUpdated = UserDefaults.standard.object(forKey: lastUpdateKey) as? Date
        }
    }
}
