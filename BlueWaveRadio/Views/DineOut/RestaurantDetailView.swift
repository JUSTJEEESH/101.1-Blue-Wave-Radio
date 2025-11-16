//
//  RestaurantDetailView.swift
//  Blue Wave Radio Roatan
//
//  Detailed view for a restaurant
//

import SwiftUI
import SafariServices

struct RestaurantDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dineOutManager: DineOutManager
    @State private var showingSafari = false
    @State private var showingShareSheet = false

    let restaurant: Restaurant

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
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
                            Image(systemName: "fork.knife.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white)

                            Text(restaurant.name)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)

                            if restaurant.isSponsored {
                                Label("Featured Partner", systemImage: "star.fill")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(8)
                            }
                        }
                        .padding()
                    }

                    // Restaurant Details
                    VStack(alignment: .leading, spacing: 16) {
                        // Cuisine
                        DetailRow(
                            icon: "text.badge.checkmark",
                            title: "Cuisine",
                            value: restaurant.cuisineString
                        )

                        Divider()

                        // Location
                        DetailRow(
                            icon: "map.fill",
                            title: "Location",
                            value: restaurant.area.displayName
                        )

                        if let address = restaurant.contact.address {
                            Text(address)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.leading, 42)
                        }

                        Divider()

                        // Contact Info
                        if restaurant.contact.hasContact {
                            VStack(alignment: .leading, spacing: 12) {
                                Label("Contact Information", systemImage: "info.circle")
                                    .font(.headline)
                                    .foregroundColor(.primary)

                                if let phone = restaurant.contact.phone {
                                    Button(action: {
                                        if let url = URL(string: "tel://\(phone.filter { $0.isNumber || $0 == "+" })") {
                                            UIApplication.shared.open(url)
                                        }
                                    }) {
                                        HStack {
                                            Image(systemName: "phone.fill")
                                                .foregroundColor(.green)
                                            Text(phone)
                                                .foregroundColor(.primary)
                                            Spacer()
                                            Image(systemName: "arrow.up.right")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(8)
                                    }
                                }

                                if let email = restaurant.contact.email {
                                    Button(action: {
                                        if let url = URL(string: "mailto:\(email)") {
                                            UIApplication.shared.open(url)
                                        }
                                    }) {
                                        HStack {
                                            Image(systemName: "envelope.fill")
                                                .foregroundColor(.blue)
                                            Text(email)
                                                .foregroundColor(.primary)
                                            Spacer()
                                            Image(systemName: "arrow.up.right")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(8)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)

                    // Action Buttons
                    VStack(spacing: 12) {
                        // Facebook
                        if let facebookURL = restaurant.facebookURL {
                            Button(action: {
                                if let url = URL(string: facebookURL) {
                                    UIApplication.shared.open(url)
                                }
                            }) {
                                Label("View on Facebook", systemImage: "link")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                        }

                        // Share
                        Button(action: {
                            showingShareSheet = true
                        }) {
                            Label("Share Restaurant", systemImage: "square.and.arrow.up")
                                .font(.headline)
                                .foregroundColor(.primaryBlue)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.primaryBlue.opacity(0.1))
                                .cornerRadius(10)
                        }

                        // Favorite
                        Button(action: {
                            dineOutManager.toggleFavorite(restaurant)
                        }) {
                            Label(
                                restaurant.isFavorite ? "Remove from Favorites" : "Add to Favorites",
                                systemImage: restaurant.isFavorite ? "heart.fill" : "heart"
                            )
                            .font(.headline)
                            .foregroundColor(restaurant.isFavorite ? .red : .gray)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                    }

                    // Navigation hint
                    HStack {
                        Spacer()
                        Text("Swipe to browse other restaurants")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
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
        }
    }

    private func createShareText() -> String {
        var text = """
        \(restaurant.name)
        \(restaurant.cuisineString)
        \(restaurant.area.displayName)
        """

        if let phone = restaurant.contact.phone {
            text += "\nPhone: \(phone)"
        }

        if let email = restaurant.contact.email {
            text += "\nEmail: \(email)"
        }

        if let facebook = restaurant.facebookURL {
            text += "\n\(facebook)"
        }

        text += "\n\nShared from Blue Wave Radio Roatan"

        return text
    }
}

#Preview {
    RestaurantDetailView(
        restaurant: Restaurant(
            name: "The Blue Marlin",
            area: .westEnd,
            cuisine: ["Seafood", "International"],
            contact: ContactInfo(phone: "+504 9999-9999", email: "info@bluemarlin.com", address: "West End Beach"),
            facebookURL: "https://facebook.com/bluemarlin",
            isSponsored: true
        )
    )
    .environmentObject(DineOutManager())
}
