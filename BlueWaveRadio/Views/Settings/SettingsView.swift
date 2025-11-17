//
//  SettingsView.swift
//  Blue Wave Radio Roatan
//
//  Settings and information view
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var weatherManager: WeatherManager
    @Environment(\.dismiss) var dismiss
    @State private var showProgramSchedule = false

    var body: some View {
        NavigationStack {
            List {
                // Weather Settings Section
                Section("Weather") {
                    Toggle(isOn: $weatherManager.useMetric) {
                        HStack {
                            Image(systemName: "thermometer")
                                .foregroundColor(.accentTurquoise)
                            Text("Use Metric (Celsius)")
                        }
                    }
                    .tint(.accentTurquoise)

                    HStack {
                        Text("Current Units")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(weatherManager.useMetric ? "Metric (°C)" : "Imperial (°F)")
                            .foregroundColor(.primaryBlue)
                    }
                }

                // Program Schedule Section
                Section("Programming") {
                    Button(action: {
                        showProgramSchedule = true
                    }) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.accentTurquoise)
                            Text("Program Schedule")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                    }
                    .foregroundColor(.primary)
                }

                // Business Section
                Section("Business") {
                    NavigationLink(destination: AdvertiseView()) {
                        HStack {
                            Image(systemName: "megaphone.fill")
                                .foregroundColor(.accentTurquoise)
                            Text("Advertise With Us")
                        }
                    }

                    NavigationLink(destination: ContactView()) {
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.accentTurquoise)
                            Text("Contact Us")
                        }
                    }
                }

                // Legal Section
                Section("Legal") {
                    NavigationLink(destination: PrivacyPolicyView()) {
                        HStack {
                            Image(systemName: "hand.raised.fill")
                                .foregroundColor(.accentTurquoise)
                            Text("Privacy Policy")
                        }
                    }

                    NavigationLink(destination: LicensingView()) {
                        HStack {
                            Image(systemName: "doc.text.fill")
                                .foregroundColor(.accentTurquoise)
                            Text("Licensing & Legal")
                        }
                    }
                }

                // App Info Section
                Section("About") {
                    HStack {
                        Text("Version")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.primaryBlue)
                    }

                    HStack {
                        Text("Location")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("Roatan, Honduras")
                            .foregroundColor(.primaryBlue)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.accentTurquoise)
                }
            }
            .sheet(isPresented: $showProgramSchedule) {
                ProgrammingScheduleView()
            }
        }
    }
}

// MARK: - Advertise View

struct AdvertiseView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image(systemName: "megaphone.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.accentTurquoise)
                    .frame(maxWidth: .infinity)
                    .padding(.top)

                Text("Advertise With Us")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)

                VStack(alignment: .leading, spacing: 16) {
                    Text("Reach the Roatan Community")
                        .font(.headline)
                        .foregroundColor(.primaryBlue)

                    Text("101.1 Blue Wave Radio is the premier radio station in Roatan, Honduras. We reach thousands of listeners daily with a diverse mix of music, news, and entertainment.")
                        .font(.body)

                    Text("Advertising Opportunities")
                        .font(.headline)
                        .foregroundColor(.primaryBlue)
                        .padding(.top, 8)

                    VStack(alignment: .leading, spacing: 8) {
                        BulletPoint(text: "On-air advertising spots")
                        BulletPoint(text: "Sponsored programming segments")
                        BulletPoint(text: "Event partnerships")
                        BulletPoint(text: "Digital advertising on our app")
                    }

                    Text("Contact Our Sales Team")
                        .font(.headline)
                        .foregroundColor(.primaryBlue)
                        .padding(.top, 8)

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "phone.fill")
                                .foregroundColor(.accentTurquoise)
                            Text("Phone: +504 9999-9999")
                        }
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.accentTurquoise)
                            Text("Email: advertising@bluewaveradio.hn")
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
            .padding()
        }
        .navigationTitle("Advertise")
    }
}

// MARK: - Contact View

struct ContactView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image(systemName: "envelope.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.accentTurquoise)
                    .frame(maxWidth: .infinity)
                    .padding(.top)

                Text("Contact Us")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)

                VStack(alignment: .leading, spacing: 16) {
                    Text("Get in Touch")
                        .font(.headline)
                        .foregroundColor(.primaryBlue)

                    VStack(alignment: .leading, spacing: 12) {
                        ContactRow(icon: "building.2.fill", title: "Station", value: "101.1 Blue Wave Radio")
                        ContactRow(icon: "location.fill", title: "Address", value: "West End, Roatan, Honduras")
                        ContactRow(icon: "phone.fill", title: "Phone", value: "+504 9999-9999")
                        ContactRow(icon: "envelope.fill", title: "Email", value: "info@bluewaveradio.hn")
                        ContactRow(icon: "globe", title: "Website", value: "www.bluewaveradio.hn")
                    }

                    Text("Studio Hours")
                        .font(.headline)
                        .foregroundColor(.primaryBlue)
                        .padding(.top, 8)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Monday - Friday: 6:00 AM - 10:00 PM")
                        Text("Saturday - Sunday: 8:00 AM - 8:00 PM")
                    }
                    .font(.body)

                    Text("Social Media")
                        .font(.headline)
                        .foregroundColor(.primaryBlue)
                        .padding(.top, 8)

                    HStack(spacing: 20) {
                        SocialButton(icon: "f.square.fill", color: .blue)
                        SocialButton(icon: "instagram", color: .purple)
                        SocialButton(icon: "play.rectangle.fill", color: .red)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
            .padding()
        }
        .navigationTitle("Contact")
    }
}

// MARK: - Privacy Policy View

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Privacy Policy")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 8)

                Text("Last Updated: November 2025")
                    .font(.caption)
                    .foregroundColor(.secondary)

                VStack(alignment: .leading, spacing: 16) {
                    PolicySection(
                        title: "Information We Collect",
                        content: "We collect minimal personal information to provide you with the best radio streaming experience. This includes app usage data, listening preferences, and location data for weather services."
                    )

                    PolicySection(
                        title: "How We Use Your Information",
                        content: "Your information is used solely to improve our service, provide personalized content recommendations, and display local weather information. We do not sell your personal information to third parties."
                    )

                    PolicySection(
                        title: "Location Data",
                        content: "We use your location to provide accurate local weather information for Roatan. Location data is processed locally on your device and is not stored on our servers."
                    )

                    PolicySection(
                        title: "Third-Party Services",
                        content: "Our app uses OpenWeatherMap API for weather data. Please refer to their privacy policy for information on how they handle data."
                    )

                    PolicySection(
                        title: "Data Security",
                        content: "We implement industry-standard security measures to protect your data. All data transmission is encrypted using secure protocols."
                    )

                    PolicySection(
                        title: "Your Rights",
                        content: "You have the right to access, modify, or delete your personal information at any time. Contact us at privacy@bluewaveradio.hn for any privacy-related inquiries."
                    )

                    PolicySection(
                        title: "Changes to This Policy",
                        content: "We may update this privacy policy from time to time. We will notify you of any changes by posting the new policy on this page."
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Privacy Policy")
    }
}

// MARK: - Licensing View

struct LicensingView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Licensing & Legal")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 8)

                VStack(alignment: .leading, spacing: 16) {
                    PolicySection(
                        title: "Broadcasting License",
                        content: "101.1 Blue Wave Radio operates under a valid broadcasting license issued by the Comisión Nacional de Telecomunicaciones (CONATEL) of Honduras. License Number: BR-2024-RO-101.1"
                    )

                    PolicySection(
                        title: "Music Licensing",
                        content: "All music broadcast on 101.1 Blue Wave Radio is properly licensed through agreements with performance rights organizations including ASCAP, BMI, and SESAC. We maintain current licenses for public performance of copyrighted musical works."
                    )

                    PolicySection(
                        title: "Copyright Notice",
                        content: "© 2025 Blue Wave Radio Roatan. All rights reserved. The Blue Wave Radio name, logo, and branding are trademarks of Blue Wave Radio Roatan. Unauthorized use is prohibited."
                    )

                    PolicySection(
                        title: "Content Guidelines",
                        content: "All content broadcast on 101.1 Blue Wave Radio complies with local broadcasting standards and regulations. We maintain editorial control over all programming and reserve the right to refuse or edit content."
                    )

                    PolicySection(
                        title: "Terms of Use",
                        content: "By using this app and listening to our broadcast, you agree to comply with all applicable laws and regulations. You may not record, redistribute, or rebroadcast our content without express written permission."
                    )

                    PolicySection(
                        title: "Disclaimer",
                        content: "While we strive to provide accurate information, 101.1 Blue Wave Radio makes no warranties or representations regarding the accuracy or completeness of any content. Use of this app is at your own risk."
                    )

                    PolicySection(
                        title: "Governing Law",
                        content: "These terms are governed by the laws of Honduras. Any disputes shall be resolved in the courts of Roatan, Bay Islands, Honduras."
                    )

                    Text("For licensing inquiries, contact:")
                        .font(.headline)
                        .foregroundColor(.primaryBlue)
                        .padding(.top, 8)

                    Text("legal@bluewaveradio.hn")
                        .foregroundColor(.accentTurquoise)
                }
            }
            .padding()
        }
        .navigationTitle("Licensing & Legal")
    }
}

// MARK: - Helper Components

struct BulletPoint: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .foregroundColor(.accentTurquoise)
            Text(text)
        }
    }
}

struct ContactRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.accentTurquoise)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.body)
            }
        }
    }
}

struct SocialButton: View {
    let icon: String
    let color: Color

    var body: some View {
        Button(action: {
            // Social media link action
        }) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
        }
    }
}

struct PolicySection: View {
    let title: String
    let content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primaryBlue)
            Text(content)
                .font(.body)
                .foregroundColor(.primary)
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(8)
    }
}

#Preview {
    SettingsView()
        .environmentObject(WeatherManager.shared)
}
