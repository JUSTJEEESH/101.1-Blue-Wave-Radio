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

    // MARK: - Real Events from Blue Wave Radio Music Scene

    private func createPlaceholderEvents() -> [MusicEvent] {
        let calendar = Calendar.current
        let today = Date()

        // Helper to get next occurrence of a weekday (1=Sunday, 2=Monday, etc.)
        func nextDate(for weekday: Int, at hour: Int, minute: Int = 0) -> Date {
            let currentWeekday = calendar.component(.weekday, from: today)
            var daysToAdd = weekday - currentWeekday
            if daysToAdd <= 0 {
                daysToAdd += 7
            }

            var components = calendar.dateComponents([.year, .month, .day], from: calendar.date(byAdding: .day, value: daysToAdd, to: today) ?? today)
            components.hour = hour
            components.minute = minute
            return calendar.date(from: components) ?? today
        }

        return [
            // MONDAY EVENTS
            MusicEvent(
                title: "Movie Night",
                venue: "Bananarama",
                dateTime: nextDate(for: 2, at: 18, minute: 0),
                description: "Call for details",
                area: "West Bay",
                musicGenre: "Movie Night",
                performer: ""
            ),
            MusicEvent(
                title: "Live Music",
                venue: "Beachers",
                dateTime: nextDate(for: 2, at: 17, minute: 30),
                description: "American, British, & Canadian classics & contemporary songs",
                area: "West Bay",
                musicGenre: "Classics/Contemporary",
                performer: "Tommy Morris"
            ),
            MusicEvent(
                title: "Bingo Night",
                venue: "Blue Bahia Beach Grill",
                dateTime: nextDate(for: 2, at: 18, minute: 0),
                description: "Every Monday",
                area: "Sandy Bay",
                musicGenre: "Bingo",
                performer: ""
            ),
            MusicEvent(
                title: "Live Music",
                venue: "Brisas del Mar / Tequila Jack's Cantina",
                dateTime: nextDate(for: 2, at: 18, minute: 0),
                description: "Rock, Blues, Classics - Every other Monday",
                area: "West End",
                musicGenre: "Rock/Blues",
                performer: "Luis de la Rosa & Maia Karagozlu"
            ),
            MusicEvent(
                title: "Live Music - Gypsy Jazz",
                venue: "Brisas del Mar / Tequila Jack's Cantina",
                dateTime: nextDate(for: 2, at: 18, minute: 0),
                description: "Every other Monday",
                area: "West End",
                musicGenre: "Gypsy Jazz",
                performer: "Marea Baja"
            ),
            MusicEvent(
                title: "Live Music",
                venue: "Sundowners",
                dateTime: nextDate(for: 2, at: 17, minute: 0),
                description: "Pop and variety, vocals, guitar, sax",
                area: "West End",
                musicGenre: "Pop/Variety",
                performer: "The Londoners"
            ),

            // TUESDAY EVENTS
            MusicEvent(
                title: "Live DJ",
                venue: "Fat Tuesday",
                dateTime: nextDate(for: 3, at: 12, minute: 0),
                description: "Cruise ship days only",
                area: "Mahogany Bay",
                musicGenre: "DJ",
                performer: "DJ Tigerson"
            ),
            MusicEvent(
                title: "Live Music",
                venue: "Sol y Mar Beach Club",
                dateTime: nextDate(for: 3, at: 11, minute: 0),
                description: "Guitar, vocals, keyboards - Island music, country, soca. Cruise ship days only",
                area: "Sandy Bay",
                musicGenre: "Island/Country/Soca",
                performer: "The Happy Boys"
            ),
            MusicEvent(
                title: "Taco Tunesday with Will & Co.",
                venue: "Sundowners",
                dateTime: nextDate(for: 3, at: 17, minute: 0),
                description: "Returns November 18",
                area: "West End",
                musicGenre: "Live Music",
                performer: "Will & Co."
            ),
            MusicEvent(
                title: "Trivia Night",
                venue: "Sundowners",
                dateTime: nextDate(for: 3, at: 19, minute: 0),
                description: "Hosted by Sean - Upstairs every Tuesday",
                area: "West End",
                musicGenre: "Trivia",
                performer: "Sean"
            ),
            MusicEvent(
                title: "Live Music - Guitar, Rock, Latin",
                venue: "Xbalanque",
                dateTime: nextDate(for: 3, at: 18, minute: 0),
                description: "Guitar, Rock, Latin",
                area: "West Bay",
                musicGenre: "Rock/Latin",
                performer: "Luis de la Rosa"
            ),

            // WEDNESDAY EVENTS
            MusicEvent(
                title: "Fiesta Night with The Happy Boys",
                venue: "Anthony's Key Resort",
                dateTime: nextDate(for: 4, at: 17, minute: 0),
                description: "Island music, country, soca - Crab races, limbo dance, dance competition",
                area: "Sandy Bay",
                musicGenre: "Island/Country/Soca",
                performer: "The Happy Boys"
            ),
            MusicEvent(
                title: "Live Music",
                venue: "Bananarama",
                dateTime: nextDate(for: 4, at: 10, minute: 30),
                description: "Island music, band dance & soca",
                area: "West Bay",
                musicGenre: "Island/Dance/Soca",
                performer: "Jensen Grant"
            ),
            MusicEvent(
                title: "Karaoke Night",
                venue: "Bananarama",
                dateTime: nextDate(for: 4, at: 17, minute: 0),
                description: "Karaoke with DJ Tigerson",
                area: "West Bay",
                musicGenre: "Karaoke",
                performer: "DJ Tigerson"
            ),
            MusicEvent(
                title: "Karaoke Night",
                venue: "Beachers",
                dateTime: nextDate(for: 4, at: 18, minute: 0),
                description: "Come out and sing",
                area: "West Bay",
                musicGenre: "Karaoke",
                performer: ""
            ),
            MusicEvent(
                title: "Guitar Duo",
                venue: "Blue Marlin",
                dateTime: nextDate(for: 4, at: 16, minute: 30),
                description: "Come out and support José and Michael for happy hour",
                area: "West End",
                musicGenre: "Guitar Duo",
                performer: "Jose & Michael"
            ),
            MusicEvent(
                title: "Live Music - Pop and Variety",
                venue: "Brisas del Mar / Tequila Jack's Cantina",
                dateTime: nextDate(for: 4, at: 17, minute: 0),
                description: "Pop and variety, vocals, guitar, sax - Every other Wednesday",
                area: "West End",
                musicGenre: "Pop/Variety",
                performer: "The Londoners"
            ),
            MusicEvent(
                title: "Live DJ",
                venue: "Fat Tuesday",
                dateTime: nextDate(for: 4, at: 11, minute: 0),
                description: "",
                area: "Mahogany Bay",
                musicGenre: "DJ",
                performer: "DJ Tigerson"
            ),
            MusicEvent(
                title: "Karaoke Night",
                venue: "Herby's Sports Bar",
                dateTime: nextDate(for: 4, at: 19, minute: 0),
                description: "Come out and sing",
                area: "French Harbour",
                musicGenre: "Karaoke",
                performer: "MC Lobo"
            ),
            MusicEvent(
                title: "Karaoke Night",
                venue: "Paradise Beach Resort, Cayuco Bar",
                dateTime: nextDate(for: 4, at: 19, minute: 0),
                description: "Every Wednesday",
                area: "West Bay",
                musicGenre: "Karaoke",
                performer: ""
            ),
            MusicEvent(
                title: "Cruise Ship Day Jam",
                venue: "Sol y Mar Beach Club",
                dateTime: nextDate(for: 4, at: 11, minute: 0),
                description: "Guitar, vocals, keyboards - Island music, country, soca",
                area: "Sandy Bay",
                musicGenre: "Island/Country/Soca",
                performer: "The Happy Boys"
            ),
            MusicEvent(
                title: "Live Music - Guitar, Rock, Latin",
                venue: "Sundowners",
                dateTime: nextDate(for: 4, at: 19, minute: 0),
                description: "Guitar, Rock, Latin",
                area: "West End",
                musicGenre: "Rock/Latin",
                performer: "Luis de la Rosa"
            ),
            MusicEvent(
                title: "LCR",
                venue: "Tita's Pink Seahorse",
                dateTime: nextDate(for: 4, at: 19, minute: 0),
                description: "",
                area: "West End",
                musicGenre: "Event",
                performer: ""
            ),

            // THURSDAY EVENTS
            MusicEvent(
                title: "Live Music - Acoustic Latin, Rock & Reggae",
                venue: "Arca Roatan - Ahari",
                dateTime: nextDate(for: 5, at: 17, minute: 30),
                description: "Acoustic Latin, Rock, & Reggae",
                area: "West Bay",
                musicGenre: "Latin/Rock/Reggae",
                performer: "Lisandro Cabrera"
            ),
            MusicEvent(
                title: "Live Music",
                venue: "Bananarama",
                dateTime: nextDate(for: 5, at: 17, minute: 30),
                description: "Country, Rock, Top 40 - Returns December 11",
                area: "West Bay",
                musicGenre: "Country/Rock",
                performer: "Ryan Ruin"
            ),
            MusicEvent(
                title: "Morning Live Music",
                venue: "Bean Crazy",
                dateTime: nextDate(for: 5, at: 9, minute: 0),
                description: "American, British, & Canadian classics & contemporary songs",
                area: "West End",
                musicGenre: "Classics/Contemporary",
                performer: "Tommy Morris"
            ),
            MusicEvent(
                title: "Karaoke Night",
                venue: "Bodega22",
                dateTime: nextDate(for: 5, at: 19, minute: 0),
                description: "",
                area: "Airport Area",
                musicGenre: "Karaoke",
                performer: ""
            ),
            MusicEvent(
                title: "Karaoke Night",
                venue: "Booty Bar",
                dateTime: nextDate(for: 5, at: 19, minute: 0),
                description: "",
                area: "West End",
                musicGenre: "Karaoke",
                performer: ""
            ),
            MusicEvent(
                title: "Live Music - IMOX",
                venue: "Brisas del Mar / Tequila Jack's Cantina",
                dateTime: nextDate(for: 5, at: 19, minute: 0),
                description: "",
                area: "West End",
                musicGenre: "Live Music",
                performer: "IMOX"
            ),
            MusicEvent(
                title: "Movie Night",
                venue: "Paradise Beach Resort, Cayuco Bar",
                dateTime: nextDate(for: 5, at: 20, minute: 0),
                description: "If raining, call to confirm",
                area: "West Bay",
                musicGenre: "Movie Night",
                performer: ""
            ),
            MusicEvent(
                title: "Live Music",
                venue: "Pazzo",
                dateTime: nextDate(for: 5, at: 17, minute: 30),
                description: "American, British, & Canadian classics & contemporary songs - Returns Dec 4th",
                area: "West End",
                musicGenre: "Classics/Contemporary",
                performer: "Tommy Morris"
            ),
            MusicEvent(
                title: "Cruise Ship Jam",
                venue: "Sol y Mar Beach Club",
                dateTime: nextDate(for: 5, at: 11, minute: 0),
                description: "Guitar, vocals, keyboards - Island music, country, soca",
                area: "Sandy Bay",
                musicGenre: "Island/Country/Soca",
                performer: "The Happy Boys"
            ),
            MusicEvent(
                title: "Swing Jazz",
                venue: "Sundowners",
                dateTime: nextDate(for: 5, at: 17, minute: 0),
                description: "Gypsy Jazz with Al Londoner - vocals, jazz, pop",
                area: "West End",
                musicGenre: "Swing/Jazz",
                performer: "Marea Baja & Al Londoner"
            ),
            MusicEvent(
                title: "Music Trivia Night",
                venue: "Sundowners",
                dateTime: nextDate(for: 5, at: 19, minute: 0),
                description: "Hosted by Eddie Nakada - Upstairs",
                area: "West End",
                musicGenre: "Trivia",
                performer: "Eddie Nakada"
            ),
            MusicEvent(
                title: "Movie Night",
                venue: "The Beach Club San Simon",
                dateTime: nextDate(for: 5, at: 19, minute: 30),
                description: "Call to confirm",
                area: "West Bay",
                musicGenre: "Movie Night",
                performer: ""
            ),

            // FRIDAY EVENTS
            MusicEvent(
                title: "Island Music Night",
                venue: "Anthony's Key Resort",
                dateTime: nextDate(for: 6, at: 17, minute: 0),
                description: "Island music, country, soca",
                area: "Sandy Bay",
                musicGenre: "Island/Country/Soca",
                performer: "The Happy Boys"
            ),
            MusicEvent(
                title: "Live Music - Bossa, Latin, Soul",
                venue: "Arca Roatan - Ahari",
                dateTime: nextDate(for: 6, at: 17, minute: 30),
                description: "Bossa, Latin, Soul",
                area: "West Bay",
                musicGenre: "Bossa/Latin/Soul",
                performer: "Maia Karagozlu"
            ),
            MusicEvent(
                title: "Live Music",
                venue: "Bananarama",
                dateTime: nextDate(for: 6, at: 17, minute: 30),
                description: "Rock, Pop, Country, Acoustic - Call to confirm",
                area: "West Bay",
                musicGenre: "Rock/Pop/Country",
                performer: "Mike Maguire"
            ),
            MusicEvent(
                title: "Karaoke Night",
                venue: "Blue Marlin",
                dateTime: nextDate(for: 6, at: 21, minute: 0),
                description: "Come out and sing",
                area: "West End",
                musicGenre: "Karaoke",
                performer: ""
            ),
            MusicEvent(
                title: "DJ Dance Party",
                venue: "Booty Bar",
                dateTime: nextDate(for: 6, at: 20, minute: 0),
                description: "",
                area: "West End",
                musicGenre: "DJ/Dance",
                performer: ""
            ),
            MusicEvent(
                title: "Bingo Night",
                venue: "Brisas del Mar / Tequila Jack's Cantina",
                dateTime: nextDate(for: 6, at: 19, minute: 0),
                description: "Get lucky at Brisas...Bingo night",
                area: "West End",
                musicGenre: "Bingo",
                performer: ""
            ),
            MusicEvent(
                title: "Karaoke Night",
                venue: "Cal's Cantina",
                dateTime: nextDate(for: 6, at: 17, minute: 0),
                description: "Returns week of December 1",
                area: "East End",
                musicGenre: "Karaoke",
                performer: ""
            ),
            MusicEvent(
                title: "Swim Up Live Music Lunch",
                venue: "Guava Grill Swim-up Pool Bar",
                dateTime: nextDate(for: 6, at: 13, minute: 0),
                description: "Pop, island, reggae acoustic",
                area: "Sandy Bay",
                musicGenre: "Pop/Island/Reggae",
                performer: "Zozeny"
            ),
            MusicEvent(
                title: "Live Music",
                venue: "Herby's Sports Bar",
                dateTime: nextDate(for: 6, at: 19, minute: 0),
                description: "",
                area: "French Harbour",
                musicGenre: "Live Music",
                performer: "Muddy"
            ),
            MusicEvent(
                title: "Garifuna Show",
                venue: "Ibagari",
                dateTime: nextDate(for: 6, at: 19, minute: 0),
                description: "Traditional Garifuna dance - Call to confirm schedule",
                area: "West Bay",
                musicGenre: "Garifuna",
                performer: ""
            ),
            MusicEvent(
                title: "Live Latin Music",
                venue: "Kimpton Grand Roatan - Vos Cafe & Bar",
                dateTime: nextDate(for: 6, at: 19, minute: 0),
                description: "Cumbia, Latin dance, love songs",
                area: "West Bay",
                musicGenre: "Latin/Cumbia",
                performer: "Maria Jose"
            ),
            MusicEvent(
                title: "Live Music",
                venue: "Kristi's Island Kitchen",
                dateTime: nextDate(for: 6, at: 17, minute: 30),
                description: "American, British, & Canadian classics & contemporary songs",
                area: "West Bay",
                musicGenre: "Classics/Contemporary",
                performer: "Tommy Morris"
            ),
            MusicEvent(
                title: "Live Music - Percussion",
                venue: "Paradise Beach Resort, Cayuco Bar",
                dateTime: nextDate(for: 6, at: 19, minute: 0),
                description: "Percussion with DJ tracks - Call to confirm",
                area: "West Bay",
                musicGenre: "Percussion/DJ",
                performer: "Kilombeats"
            ),
            MusicEvent(
                title: "Live Music",
                venue: "Roatan Yacht Club",
                dateTime: nextDate(for: 6, at: 19, minute: 0),
                description: "Pop, island, reggae acoustic",
                area: "French Harbour",
                musicGenre: "Pop/Island/Reggae",
                performer: "Zozeny"
            ),
            MusicEvent(
                title: "Live Music",
                venue: "Salty Dawg",
                dateTime: nextDate(for: 6, at: 13, minute: 0),
                description: "A rotating group of musicians each Friday",
                area: "East End",
                musicGenre: "Live Music",
                performer: ""
            ),
            MusicEvent(
                title: "Live DJ",
                venue: "Seawiches",
                dateTime: nextDate(for: 6, at: 19, minute: 0),
                description: "",
                area: "West End",
                musicGenre: "DJ",
                performer: ""
            ),
            MusicEvent(
                title: "Live Music",
                venue: "Sundowners",
                dateTime: nextDate(for: 6, at: 19, minute: 0),
                description: "Pop, rock, acoustic with Harmony Storms",
                area: "West End",
                musicGenre: "Pop/Rock/Acoustic",
                performer: "Scotty C"
            ),

            // SATURDAY EVENTS
            MusicEvent(
                title: "Live Music - Gypsy Jazz",
                venue: "Arca Roatan - Ahari",
                dateTime: nextDate(for: 7, at: 16, minute: 30),
                description: "Gypsy Jazz",
                area: "West Bay",
                musicGenre: "Gypsy Jazz",
                performer: "Marea Baja"
            ),
            MusicEvent(
                title: "Live Percussion with DJ",
                venue: "Bananarama",
                dateTime: nextDate(for: 7, at: 18, minute: 0),
                description: "Live percussion with DJ tracks",
                area: "West Bay",
                musicGenre: "Percussion/DJ",
                performer: "Kilombeats"
            ),
            MusicEvent(
                title: "Live DJ",
                venue: "Bodega22",
                dateTime: nextDate(for: 7, at: 21, minute: 0),
                description: "Call to confirm",
                area: "Airport Area",
                musicGenre: "DJ",
                performer: ""
            ),
            MusicEvent(
                title: "Live DJ",
                venue: "Booty Bar",
                dateTime: nextDate(for: 7, at: 19, minute: 0),
                description: "Call to confirm",
                area: "West End",
                musicGenre: "DJ",
                performer: ""
            ),
            MusicEvent(
                title: "Live Music",
                venue: "Herby's Sports Bar",
                dateTime: nextDate(for: 7, at: 19, minute: 0),
                description: "Island music, soca, pop",
                area: "French Harbour",
                musicGenre: "Island/Soca/Pop",
                performer: "Muddy"
            ),
            MusicEvent(
                title: "Live Music - Guitar",
                venue: "Infinity Bay",
                dateTime: nextDate(for: 7, at: 19, minute: 0),
                description: "Acoustic Latin, rock, & reggae",
                area: "West Bay",
                musicGenre: "Latin/Rock/Reggae",
                performer: "Lisandro Cabrera"
            ),
            MusicEvent(
                title: "Live Music",
                venue: "Kristi's Island Kitchen",
                dateTime: nextDate(for: 7, at: 17, minute: 30),
                description: "American, British, & Canadian classics & contemporary songs",
                area: "West Bay",
                musicGenre: "Classics/Contemporary",
                performer: "Tommy Morris"
            ),
            MusicEvent(
                title: "Live DJ",
                venue: "La Placita Inn",
                dateTime: nextDate(for: 7, at: 18, minute: 30),
                description: "Call to confirm",
                area: "West Bay",
                musicGenre: "DJ",
                performer: "DJ Gerson"
            ),
            MusicEvent(
                title: "Live Music",
                venue: "Mayan Princess Resorts, Calketts Bar",
                dateTime: nextDate(for: 7, at: 18, minute: 30),
                description: "Guitar, vocals, keyboards - Island music, country, soca",
                area: "West Bay",
                musicGenre: "Island/Country/Soca",
                performer: "The Happy Boys"
            ),
            MusicEvent(
                title: "Garifuna Show & After Party",
                venue: "Paradise Beach Resort, Cayuco Bar",
                dateTime: nextDate(for: 7, at: 19, minute: 30),
                description: "Garifuna show and after party on the beach",
                area: "West Bay",
                musicGenre: "Garifuna",
                performer: ""
            ),
            MusicEvent(
                title: "Live DJ - Electronika",
                venue: "Seawiches",
                dateTime: nextDate(for: 7, at: 20, minute: 0),
                description: "Electronika until late - Come and enjoy",
                area: "West End",
                musicGenre: "Electronika",
                performer: ""
            ),
            MusicEvent(
                title: "Live Music",
                venue: "Sundowners",
                dateTime: nextDate(for: 7, at: 19, minute: 0),
                description: "Country, blues, & 90s rock - Filling in for Ryan Ruin through Dec 6",
                area: "West End",
                musicGenre: "Country/Blues/Rock",
                performer: "Josh Green"
            ),
            MusicEvent(
                title: "Movie Night on the Dock",
                venue: "The Beach House",
                dateTime: nextDate(for: 7, at: 18, minute: 30),
                description: "Call to confirm",
                area: "West End",
                musicGenre: "Movie Night",
                performer: ""
            ),

            // SUNDAY EVENTS
            MusicEvent(
                title: "Family Night",
                venue: "Bananarama",
                dateTime: nextDate(for: 1, at: 17, minute: 0),
                description: "Live music, fire show, charity crab races",
                area: "West Bay",
                musicGenre: "Family Event",
                performer: ""
            ),
            MusicEvent(
                title: "Sunday Funday - Jammin' Around the Classics",
                venue: "Blue Bahia Beach Grill",
                dateTime: nextDate(for: 1, at: 17, minute: 30),
                description: "Multiple artists jamming classics",
                area: "Sandy Bay",
                musicGenre: "Classics Jam",
                performer: "Tommy Morris, Lisandro Cabrera, Zozeny, Steve Campbell"
            ),
            MusicEvent(
                title: "Guitar Duo",
                venue: "Blue Marlin",
                dateTime: nextDate(for: 1, at: 16, minute: 30),
                description: "Come out and support José and Michael for happy hour",
                area: "West End",
                musicGenre: "Guitar Duo",
                performer: "Jose & Michael"
            ),
            MusicEvent(
                title: "Live Music",
                venue: "Booty Bar",
                dateTime: nextDate(for: 1, at: 17, minute: 30),
                description: "Call to confirm",
                area: "West End",
                musicGenre: "Live Music",
                performer: ""
            ),
            MusicEvent(
                title: "Live Music",
                venue: "Ginger's",
                dateTime: nextDate(for: 1, at: 12, minute: 30),
                description: "American, British, & Canadian classics & contemporary songs",
                area: "West End",
                musicGenre: "Classics/Contemporary",
                performer: "Tommy Morris"
            ),
            MusicEvent(
                title: "Live Music",
                venue: "La Placita Inn",
                dateTime: nextDate(for: 1, at: 18, minute: 30),
                description: "Island music and favorites",
                area: "West Bay",
                musicGenre: "Island Music",
                performer: "Speedy James"
            ),
            MusicEvent(
                title: "Live Music",
                venue: "Paradise Beach Resort, Cayuco Bar",
                dateTime: nextDate(for: 1, at: 14, minute: 0),
                description: "Island music, soca, pop",
                area: "West Bay",
                musicGenre: "Island/Soca/Pop",
                performer: "Muddy"
            ),
            MusicEvent(
                title: "Sunday Funday",
                venue: "Sundowners",
                dateTime: nextDate(for: 1, at: 14, minute: 0),
                description: "DJ spinning reggae, funk, & soul",
                area: "West End",
                musicGenre: "Reggae/Funk/Soul",
                performer: "DJ Al Londoner"
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
