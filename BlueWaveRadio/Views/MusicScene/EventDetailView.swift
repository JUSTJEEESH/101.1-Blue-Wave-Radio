//
//  EventDetailView.swift
//  Blue Wave Radio Roatan
//
//  Detailed view for a music event
//

import SwiftUI
import EventKit

struct EventDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var musicSceneManager: MusicSceneManager
    @EnvironmentObject var notificationManager: NotificationManager
    @State private var showingAddToCalendar = false
    @State private var showingShareSheet = false
    @State private var showingNotificationAlert = false

    let event: MusicEvent

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header Image
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: [Color.primaryBlue, Color.accentTurquoise],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(height: 200)

                        VStack(spacing: 12) {
                            Image(systemName: "music.note.list")
                                .font(.system(size: 60))
                                .foregroundColor(.white)

                            Text(event.title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                    }

                    // Event Details
                    VStack(alignment: .leading, spacing: 16) {
                        // Venue
                        DetailRow(
                            icon: "location.fill",
                            title: "Venue",
                            value: event.venue
                        )

                        Divider()

                        // Date & Time
                        DetailRow(
                            icon: "calendar",
                            title: "Date & Time",
                            value: event.formattedDate
                        )

                        Divider()

                        // Day
                        DetailRow(
                            icon: "clock.fill",
                            title: "Day",
                            value: event.dayOfWeek
                        )

                        Divider()

                        // Description
                        VStack(alignment: .leading, spacing: 8) {
                            Label("About", systemImage: "text.alignleft")
                                .font(.headline)
                                .foregroundColor(.primary)

                            Text(event.description)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)

                    // Action Buttons
                    VStack(spacing: 12) {
                        // Add to Calendar
                        Button(action: {
                            addToCalendar()
                        }) {
                            Label("Add to Calendar", systemImage: "calendar.badge.plus")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.accentTurquoise)
                                .cornerRadius(10)
                        }

                        // Set Reminder
                        Button(action: {
                            setReminder()
                        }) {
                            Label("Set Reminder", systemImage: "bell.fill")
                                .font(.headline)
                                .foregroundColor(.primaryBlue)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.primaryBlue.opacity(0.1))
                                .cornerRadius(10)
                        }

                        // Share
                        Button(action: {
                            showingShareSheet = true
                        }) {
                            Label("Share Event", systemImage: "square.and.arrow.up")
                                .font(.headline)
                                .foregroundColor(.primaryBlue)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.primaryBlue.opacity(0.1))
                                .cornerRadius(10)
                        }

                        // Favorite
                        Button(action: {
                            musicSceneManager.toggleFavorite(event)
                        }) {
                            Label(
                                event.isFavorite ? "Remove from Favorites" : "Add to Favorites",
                                systemImage: event.isFavorite ? "heart.fill" : "heart"
                            )
                            .font(.headline)
                            .foregroundColor(event.isFavorite ? .red : .gray)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                    }

                    Spacer(minLength: 40)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                ShareSheet(items: [createShareText()])
            }
            .alert("Reminder Set", isPresented: $showingNotificationAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("You'll be notified 1 hour before the event starts.")
            }
        }
    }

    private func addToCalendar() {
        let eventStore = EKEventStore()

        eventStore.requestFullAccessToEvents { granted, error in
            if granted {
                let calendarEvent = EKEvent(eventStore: eventStore)
                calendarEvent.title = event.title
                calendarEvent.location = event.venue
                calendarEvent.notes = event.description
                calendarEvent.startDate = event.dateTime
                calendarEvent.endDate = event.dateTime.addingTimeInterval(2 * 60 * 60) // 2 hours
                calendarEvent.calendar = eventStore.defaultCalendarForNewEvents

                do {
                    try eventStore.save(calendarEvent, span: .thisEvent)
                    DispatchQueue.main.async {
                        showingAddToCalendar = true
                    }
                } catch {
                    print("Error saving event to calendar: \(error)")
                }
            }
        }
    }

    private func setReminder() {
        Task {
            await notificationManager.scheduleEventReminder(for: event, minutesBefore: 60)
            await MainActor.run {
                showingNotificationAlert = true
            }
        }
    }

    private func createShareText() -> String {
        return """
        \(event.title)
        \(event.venue)
        \(event.formattedDate)

        \(event.description)

        Shared from Blue Wave Radio Roatan
        """
    }
}

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.accentTurquoise)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(value)
                    .font(.body)
                    .foregroundColor(.primary)
            }
        }
    }
}

// Share Sheet for iOS
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    EventDetailView(
        event: MusicEvent(
            title: "Live Reggae Night",
            venue: "Paradise Beach Hotel",
            dateTime: Date(),
            description: "Join us for a night of authentic reggae rhythms by the beach."
        )
    )
    .environmentObject(MusicSceneManager())
    .environmentObject(NotificationManager())
}
