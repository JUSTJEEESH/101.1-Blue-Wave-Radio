//
//  ProgrammingScheduleView.swift
//  Blue Wave Radio Roatan
//
//  View displaying the radio programming schedule
//

import SwiftUI

struct ProgrammingScheduleView: View {
    @Environment(\.dismiss) var dismiss
    @State private var expandedSections: Set<String> = ["Monday-Friday"] // Start with weekday expanded

    // Group shows by day category
    private var showsByDay: [(day: String, shows: [RadioShow])] {
        let days = ["Monday-Friday", "Saturday", "Sunday"]
        return days.compactMap { day in
            let showsForDay = RadioShow.schedule
                .filter { show in
                    if day == "Monday-Friday" {
                        return show.dayOfWeek == "Monday-Friday"
                    } else {
                        return show.dayOfWeek == day
                    }
                }
                .sorted { show1, show2 in
                    // Sort by start time
                    parseTime(show1.startTime) < parseTime(show2.startTime)
                }

            return showsForDay.isEmpty ? nil : (day: day, shows: showsForDay)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(showsByDay, id: \.day) { dayGroup in
                    Section {
                        DisclosureGroup(
                            isExpanded: Binding(
                                get: { expandedSections.contains(dayGroup.day) },
                                set: { isExpanded in
                                    if isExpanded {
                                        expandedSections.insert(dayGroup.day)
                                    } else {
                                        expandedSections.remove(dayGroup.day)
                                    }
                                }
                            )
                        ) {
                            ForEach(dayGroup.shows) { show in
                                ShowRow(show: show)
                                    .padding(.vertical, 4)
                            }
                        } label: {
                            HStack {
                                Image(systemName: dayIconName(for: dayGroup.day))
                                    .font(.title3)
                                    .foregroundColor(.accentTurquoise)
                                    .frame(width: 30)

                                Text(dayGroup.day)
                                    .font(.headline)
                                    .foregroundColor(.primary)

                                Spacer()

                                Text("\(dayGroup.shows.count) shows")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Programming Schedule")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    // Helper function to parse time string to minutes for sorting
    private func parseTime(_ timeString: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = formatter.date(from: timeString) else {
            return 0
        }

        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)

        return hour * 60 + minute
    }

    // Helper function to get appropriate icon for each day
    private func dayIconName(for day: String) -> String {
        switch day {
        case "Monday-Friday":
            return "briefcase.fill"
        case "Saturday":
            return "star.fill"
        case "Sunday":
            return "sun.max.fill"
        default:
            return "calendar"
        }
    }
}

struct ShowRow: View {
    let show: RadioShow

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Icon
            Image(systemName: show.iconName)
                .font(.title3)
                .foregroundColor(.accentTurquoise)
                .frame(width: 35)

            VStack(alignment: .leading, spacing: 6) {
                // Show name and time on same line for better readability
                HStack(alignment: .firstTextBaseline) {
                    Text(show.name)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Spacer()

                    Text(show.timeRange)
                        .font(.subheadline)
                        .foregroundColor(.accentGold)
                        .fontWeight(.medium)
                }

                // Description
                Text(show.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(3)

                // Sponsor
                if let sponsor = show.sponsor {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                        Text(sponsor)
                            .font(.caption2)
                    }
                    .foregroundColor(.accentTurquoise)
                    .padding(.top, 2)
                }
            }
        }
    }
}

#Preview {
    ProgrammingScheduleView()
}
