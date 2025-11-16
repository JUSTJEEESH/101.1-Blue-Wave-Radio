//
//  ProgrammingScheduleView.swift
//  Blue Wave Radio Roatan
//
//  View displaying the radio programming schedule
//

import SwiftUI

struct ProgrammingScheduleView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            List(RadioShow.schedule) { show in
                ShowRow(show: show)
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
}

struct ShowRow: View {
    let show: RadioShow

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Icon
            Image(systemName: show.iconName)
                .font(.title2)
                .foregroundColor(.accentTurquoise)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 4) {
                // Show name
                Text(show.name)
                    .font(.headline)
                    .foregroundColor(.primary)

                // Time
                Text(show.timeRange)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                // Day
                Text(show.dayOfWeek)
                    .font(.caption)
                    .foregroundColor(.secondary)

                // Description
                Text(show.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 2)

                // Sponsor
                if let sponsor = show.sponsor {
                    Label(sponsor, systemImage: "star.fill")
                        .font(.caption2)
                        .foregroundColor(.accentTurquoise)
                        .padding(.top, 4)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ProgrammingScheduleView()
}
