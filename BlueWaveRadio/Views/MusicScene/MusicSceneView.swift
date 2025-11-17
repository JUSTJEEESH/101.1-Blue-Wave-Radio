//
//  MusicSceneView.swift
//  Blue Wave Radio Roatan
//
//  Music events listing view
//

import SwiftUI

struct MusicSceneView: View {
    @EnvironmentObject var musicSceneManager: MusicSceneManager
    @EnvironmentObject var notificationManager: NotificationManager
    @State private var searchText = ""
    @State private var selectedEvent: MusicEvent?
    @State private var selectedArea = "All Areas"

    let areas = ["All Areas", "West End", "West Bay", "Sandy Bay", "French Harbour", "Oak Ridge", "Punta Gorda", "East End"]

    var filteredEvents: [MusicEvent] {
        var events = musicSceneManager.events

        // Filter by area
        if selectedArea != "All Areas" {
            events = events.filter { $0.area == selectedArea }
        }

        // Filter by search text
        if !searchText.isEmpty {
            events = events.filter { event in
                event.title.localizedCaseInsensitiveContains(searchText) ||
                event.venue.localizedCaseInsensitiveContains(searchText) ||
                event.description.localizedCaseInsensitiveContains(searchText) ||
                event.area.localizedCaseInsensitiveContains(searchText) ||
                event.musicGenre.localizedCaseInsensitiveContains(searchText) ||
                event.performer.localizedCaseInsensitiveContains(searchText)
            }
        }

        return events.sorted { $0.dateTime < $1.dateTime }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Area Picker
                Picker("Area", selection: $selectedArea) {
                    ForEach(areas, id: \.self) { area in
                        Text(area).tag(area)
                    }
                }
                .pickerStyle(.menu)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(.systemGroupedBackground))

                ZStack {
                    if musicSceneManager.isLoading && musicSceneManager.events.isEmpty {
                        VStack(spacing: 16) {
                            ProgressView()
                            Text("Loading music events...")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    } else if filteredEvents.isEmpty {
                        ContentUnavailableView(
                            "No Events Found",
                            systemImage: "music.note.list",
                            description: Text(searchText.isEmpty && selectedArea == "All Areas" ?
                                "A snapshot of Roatan's Music Scene… Who's playing where and when…" :
                                "No events match your filters")
                        )
                    } else {
                        List {
                            ForEach(filteredEvents) { event in
                                EventRow(event: event)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        selectedEvent = event
                                    }
                            }

                            // Disclaimer at bottom
                            Section {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "info.circle")
                                            .foregroundColor(.secondary)
                                        Text("Disclaimer")
                                            .font(.headline)
                                            .foregroundColor(.secondary)
                                    }

                                    Text("Listings are submitted by venues/performers. Times & details may change without notice. Always confirm with the venue.")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .padding(.vertical, 8)
                            }
                        }
                        .refreshable {
                            await musicSceneManager.fetchEvents()
                        }
                    }
                }
            }
            .navigationTitle("Music Scene")
            .searchable(text: $searchText, prompt: "Search events, venues, performers, genres...")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if let lastUpdated = musicSceneManager.lastUpdated {
                        Text("Updated \(lastUpdated.formatted(.relative(presentation: .numeric)))")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .sheet(item: $selectedEvent) { event in
                EventDetailView(event: event)
            }
            .task {
                if musicSceneManager.events.isEmpty {
                    await musicSceneManager.fetchEvents()
                }
            }
        }
    }
}

struct EventRow: View {
    @EnvironmentObject var musicSceneManager: MusicSceneManager
    let event: MusicEvent

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.accentTurquoise.opacity(0.2))
                    .frame(width: 50, height: 50)

                Image(systemName: "music.note")
                    .font(.title3)
                    .foregroundColor(.accentTurquoise)
            }

            VStack(alignment: .leading, spacing: 6) {
                // Event title
                Text(event.title)
                    .font(.headline)
                    .foregroundColor(.primary)

                // Performer (if not empty)
                if !event.performer.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "person.fill")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(event.performer)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }

                // Venue & Area
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(event.venue) • \(event.area)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                // Date and time
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(event.formattedDate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                // Genre and day badges
                HStack(spacing: 6) {
                    Text(event.musicGenre)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.accentTurquoise)
                        .cornerRadius(6)

                    Text(event.dayOfWeek)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.primaryBlue)
                        .cornerRadius(6)
                }
            }

            Spacer()

            // Favorite button
            Button(action: {
                musicSceneManager.toggleFavorite(event)
            }) {
                Image(systemName: event.isFavorite ? "heart.fill" : "heart")
                    .font(.title3)
                    .foregroundColor(event.isFavorite ? .red : .gray)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    MusicSceneView()
        .environmentObject(MusicSceneManager())
        .environmentObject(NotificationManager())
}
