//
//  MusicSceneManager.swift
//  Blue Wave Radio Roatan
//
//  Service for fetching and parsing music events
//

import Foundation
import Observation

@Observable
class MusicSceneManager {
    private let musicSceneURL = URL(string: "https://www.bluewaveradio.live/roatanmusicscene")!
    private let cacheKey = "cached_music_events"
    private let lastUpdateKey = "music_events_last_update"

    var events: [MusicEvent] = []
    var isLoading = false
    var lastUpdated: Date?
    var errorMessage: String?

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
                    imageURL: nil
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

        return [
            MusicEvent(
                title: "Live Reggae Night",
                venue: "Paradise Beach Hotel",
                dateTime: calendar.date(byAdding: .day, value: 1, to: today) ?? today,
                description: "Join us for a night of authentic reggae rhythms by the beach. Local and visiting artists perform classic reggae hits and original compositions.",
                imageURL: nil
            ),
            MusicEvent(
                title: "Acoustic Sunset Sessions",
                venue: "The Blue Marlin",
                dateTime: calendar.date(byAdding: .day, value: 2, to: today) ?? today,
                description: "Intimate acoustic performances as the sun sets over the Caribbean. Featuring local singer-songwriters.",
                imageURL: nil
            ),
            MusicEvent(
                title: "Latin Jazz Fusion",
                venue: "Vintage Pearl",
                dateTime: calendar.date(byAdding: .day, value: 3, to: today) ?? today,
                description: "Experience the fusion of Latin rhythms and smooth jazz in an elegant waterfront setting.",
                imageURL: nil
            ),
            MusicEvent(
                title: "Island Vibes DJ Night",
                venue: "Sundowners",
                dateTime: calendar.date(byAdding: .day, value: 4, to: today) ?? today,
                description: "Dance the night away with resident and guest DJs spinning Caribbean beats, dancehall, and island favorites.",
                imageURL: nil
            ),
            MusicEvent(
                title: "Classic Rock Tribute",
                venue: "Foster's West End",
                dateTime: calendar.date(byAdding: .day, value: 5, to: today) ?? today,
                description: "Rock out to classic hits from the 70s, 80s, and 90s performed by talented island musicians.",
                imageURL: nil
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
