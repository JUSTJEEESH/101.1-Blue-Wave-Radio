//
//  DineOutView.swift
//  Blue Wave Radio Roatan
//
//  Restaurant listings view
//

import SwiftUI

struct DineOutView: View {
    @EnvironmentObject var dineOutManager: DineOutManager
    @State private var selectedArea: IslandArea = .westEnd
    @State private var searchText = ""
    @State private var selectedRestaurant: Restaurant?

    var displayedRestaurants: [Restaurant] {
        let baseList = searchText.isEmpty ?
            dineOutManager.restaurantsByArea(selectedArea) :
            dineOutManager.searchRestaurants(query: searchText)

        return baseList.sorted { lhs, rhs in
            // Sponsored restaurants first
            if lhs.isSponsored != rhs.isSponsored {
                return lhs.isSponsored
            }
            return lhs.name < rhs.name
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search Bar
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)

                        TextField("Search cuisine or name...", text: $searchText)
                            .textFieldStyle(.plain)

                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)

                // Area Grid
                if searchText.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(IslandArea.allCases) { area in
                                AreaCard(
                                    area: area,
                                    isSelected: selectedArea == area,
                                    restaurantCount: dineOutManager.restaurantsByArea(area).count
                                )
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedArea = area
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                    }
                    .background(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
                }

                // Restaurant List
                if dineOutManager.isLoading && dineOutManager.restaurants.isEmpty {
                    VStack(spacing: 16) {
                        ProgressView()
                        Text("Loading restaurants...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxHeight: .infinity)
                } else if displayedRestaurants.isEmpty {
                    ContentUnavailableView(
                        "No Restaurants Found",
                        systemImage: "fork.knife",
                        description: Text(searchText.isEmpty ?
                            "No restaurants in this area" :
                            "No restaurants match your search")
                    )
                } else {
                    List {
                        // Sponsored section
                        let sponsored = displayedRestaurants.filter { $0.isSponsored }
                        if !sponsored.isEmpty {
                            Section {
                                ForEach(sponsored) { restaurant in
                                    RestaurantRow(restaurant: restaurant)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            selectedRestaurant = restaurant
                                        }
                                }
                            } header: {
                                Label("Featured Partners", systemImage: "star.fill")
                                    .foregroundColor(.accentTurquoise)
                            }
                        }

                        // Regular restaurants
                        let regular = displayedRestaurants.filter { !$0.isSponsored }
                        if !regular.isEmpty {
                            Section {
                                ForEach(regular) { restaurant in
                                    RestaurantRow(restaurant: restaurant)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            selectedRestaurant = restaurant
                                        }
                                }
                            } header: {
                                if !sponsored.isEmpty {
                                    Text("All Restaurants")
                                }
                            }
                        }
                    }
                    .refreshable {
                        await dineOutManager.fetchRestaurants()
                    }
                }
            }
            .navigationTitle("Dine Out Roatan")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if let lastUpdated = dineOutManager.lastUpdated {
                        Text("Updated \(lastUpdated.formatted(.relative(presentation: .numeric)))")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .sheet(item: $selectedRestaurant) { restaurant in
                RestaurantDetailView(restaurant: restaurant)
            }
            .task {
                if dineOutManager.restaurants.isEmpty {
                    await dineOutManager.fetchRestaurants()
                }
            }
        }
    }
}

// MARK: - Area Card
struct AreaCard: View {
    let area: IslandArea
    let isSelected: Bool
    let restaurantCount: Int

    var areaIcon: String {
        switch area {
        case .westEnd: return "sunset.fill"
        case .westBay: return "water.waves"
        case .sandy: return "beach.umbrella.fill"
        case .french: return "ferry.fill"
        case .oak: return "tree.fill"
        case .east: return "sunrise.fill"
        }
    }

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(isSelected ? Color.primaryBlue : Color.primaryBlue.opacity(0.1))
                    .frame(width: 50, height: 50)

                Image(systemName: areaIcon)
                    .font(.title3)
                    .foregroundColor(isSelected ? .white : .primaryBlue)
            }

            Text(area.displayName)
                .font(.system(size: 13, weight: isSelected ? .semibold : .medium))
                .foregroundColor(isSelected ? .primary : .secondary)
                .lineLimit(2)
                .multilineTextAlignment(.center)

            Text("\(restaurantCount)")
                .font(.caption2)
                .foregroundColor(isSelected ? .accentTurquoise : .secondary)
                .fontWeight(.medium)
        }
        .frame(width: 85)
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? Color.primaryBlue.opacity(0.08) : Color(.systemGray6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(isSelected ? Color.primaryBlue : Color.clear, lineWidth: 2)
        )
    }
}

struct RestaurantRow: View {
    @EnvironmentObject var dineOutManager: DineOutManager
    let restaurant: Restaurant

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.primaryBlue.opacity(0.2))
                    .frame(width: 50, height: 50)

                Image(systemName: "fork.knife")
                    .font(.title3)
                    .foregroundColor(.primaryBlue)

                if restaurant.isSponsored {
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundColor(.accentTurquoise)
                        .offset(x: 18, y: -18)
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                // Restaurant name
                Text(restaurant.name)
                    .font(.headline)
                    .foregroundColor(.primary)

                // Cuisine
                Text(restaurant.cuisineString)
                    .font(.subheadline)
                    .foregroundColor(.accentTurquoise)

                // Area
                HStack(spacing: 4) {
                    Image(systemName: "map.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(restaurant.area.displayName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                // Contact
                if restaurant.contact.hasContact {
                    HStack(spacing: 8) {
                        if restaurant.contact.phone != nil {
                            Label("Call", systemImage: "phone.fill")
                                .font(.caption2)
                                .foregroundColor(.green)
                        }
                        if restaurant.facebookURL != nil {
                            Label("Facebook", systemImage: "link")
                                .font(.caption2)
                                .foregroundColor(.blue)
                        }
                    }
                }
            }

            Spacer()

            // Favorite button
            Button(action: {
                dineOutManager.toggleFavorite(restaurant)
            }) {
                Image(systemName: restaurant.isFavorite ? "heart.fill" : "heart")
                    .font(.title3)
                    .foregroundColor(restaurant.isFavorite ? .red : .gray)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    DineOutView()
        .environmentObject(DineOutManager())
}
