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

    var filteredEvents: [MusicEvent] {
        if searchText.isEmpty {
            return musicSceneManager.events
        } else {
            return musicSceneManager.events.filter { event in
                event.title.localizedCaseInsensitiveContains(searchText) ||
                event.venue.localizedCaseInsensitiveContains(searchText) ||
                event.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
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
                        description: Text(searchText.isEmpty ?
                            "A snapshot of Roatan's Music Scene… Who's playing where and when…" :
                            "No events match your search")
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
                    }
                    .refreshable {
                        await musicSceneManager.fetchEvents()
                    }
                }
            }
            .navigationTitle("Music Scene")
            .searchable(text: $searchText, prompt: "Search events...")
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

                // Venue
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(event.venue)
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

                // Day of week badge
                Text(event.dayOfWeek)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.primaryBlue)
                    .cornerRadius(6)
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
