//
//  FavoritesView.swift
//  Blue Wave Radio Roatan
//
//  Unified favorites view for restaurants and music events
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var dineOutManager: DineOutManager
    @EnvironmentObject var musicSceneManager: MusicSceneManager
    @State private var selectedCategory: FavoriteCategory = .all

    enum FavoriteCategory: String, CaseIterable, Identifiable {
        case all = "All"
        case restaurants = "Restaurants"
        case music = "Music"

        var id: String { rawValue }

        var icon: String {
            switch self {
            case .all: return "heart.fill"
            case .restaurants: return "fork.knife"
            case .music: return "music.note"
            }
        }
    }

    var favoriteRestaurants: [Restaurant] {
        dineOutManager.favoriteRestaurants()
    }

    var favoriteEvents: [MusicEvent] {
        musicSceneManager.favoriteEvents()
    }

    var hasFavorites: Bool {
        !favoriteRestaurants.isEmpty || !favoriteEvents.isEmpty
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Category Picker
                if hasFavorites {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(FavoriteCategory.allCases) { category in
                            Label(category.rawValue, systemImage: category.icon)
                                .tag(category)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    .background(Color(.systemBackground))
                }

                // Content
                if !hasFavorites {
                    ContentUnavailableView(
                        "No Favorites Yet",
                        systemImage: "heart.slash",
                        description: Text("Tap the ♡ icon on restaurants or music events to add them to your favorites")
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            // Restaurants Section
                            if (selectedCategory == .all || selectedCategory == .restaurants) && !favoriteRestaurants.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    if selectedCategory == .all {
                                        SectionHeader(
                                            title: "Restaurants",
                                            icon: "fork.knife",
                                            count: favoriteRestaurants.count
                                        )
                                    }

                                    ForEach(favoriteRestaurants) { restaurant in
                                        FavoriteRestaurantCard(restaurant: restaurant)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.top)
                            }

                            // Music Events Section
                            if (selectedCategory == .all || selectedCategory == .music) && !favoriteEvents.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    if selectedCategory == .all {
                                        SectionHeader(
                                            title: "Music Events",
                                            icon: "music.note",
                                            count: favoriteEvents.count
                                        )
                                    }

                                    ForEach(favoriteEvents) { event in
                                        FavoriteMusicEventCard(event: event)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.top)
                            }
                        }
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("Favorites")
        }
    }
}

// MARK: - Section Header
struct SectionHeader: View {
    let title: String
    let icon: String
    let count: Int

    var body: some View {
        HStack {
            Label(title, systemImage: icon)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            Spacer()

            Text("\(count)")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(Color.accentTurquoise)
                )
        }
        .padding(.horizontal, 4)
    }
}

// MARK: - Favorite Restaurant Card
struct FavoriteRestaurantCard: View {
    @EnvironmentObject var dineOutManager: DineOutManager
    @State private var showDetail = false
    let restaurant: Restaurant

    var body: some View {
        Button(action: {
            showDetail = true
        }) {
            HStack(spacing: 12) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.primaryBlue.opacity(0.15))
                        .frame(width: 60, height: 60)

                    Image(systemName: "fork.knife")
                        .font(.title2)
                        .foregroundColor(.primaryBlue)
                }

                // Info
                VStack(alignment: .leading, spacing: 6) {
                    Text(restaurant.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(1)

                    Text(restaurant.cuisineString)
                        .font(.subheadline)
                        .foregroundColor(.accentTurquoise)
                        .lineLimit(1)

                    HStack(spacing: 4) {
                        Image(systemName: "map.fill")
                            .font(.caption2)
                        Text(restaurant.area.displayName)
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                }

                Spacer()

                // Unfavorite button
                Button(action: {
                    withAnimation {
                        dineOutManager.toggleFavorite(restaurant)
                    }
                }) {
                    Image(systemName: "heart.fill")
                        .font(.title3)
                        .foregroundColor(.red)
                }
                .buttonStyle(.plain)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showDetail) {
            RestaurantDetailView(restaurant: restaurant)
        }
    }
}

// MARK: - Favorite Music Event Card
struct FavoriteMusicEventCard: View {
    @EnvironmentObject var musicSceneManager: MusicSceneManager
    @State private var showDetail = false
    let event: MusicEvent

    var body: some View {
        Button(action: {
            showDetail = true
        }) {
            HStack(spacing: 12) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.accentTurquoise.opacity(0.15))
                        .frame(width: 60, height: 60)

                    Image(systemName: "music.note")
                        .font(.title2)
                        .foregroundColor(.accentTurquoise)
                }

                // Info
                VStack(alignment: .leading, spacing: 6) {
                    Text(event.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(1)

                    HStack(spacing: 4) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.caption)
                        Text(event.venue)
                            .font(.subheadline)
                    }
                    .foregroundColor(.accentTurquoise)
                    .lineLimit(1)

                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.caption2)
                        Text(event.formattedDate)
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                }

                Spacer()

                // Unfavorite button
                Button(action: {
                    withAnimation {
                        musicSceneManager.toggleFavorite(event)
                    }
                }) {
                    Image(systemName: "heart.fill")
                        .font(.title3)
                        .foregroundColor(.red)
                }
                .buttonStyle(.plain)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showDetail) {
            EventDetailView(event: event)
        }
    }
}

#Preview {
    FavoritesView()
        .environmentObject(DineOutManager())
        .environmentObject(MusicSceneManager())
}
