//
//  ContentView.swift
//  Blue Wave Radio Roatan
//
//  Main tab navigation view
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            StreamingView()
                .tabItem {
                    Label("Radio", systemImage: "radio")
                }
                .tag(0)

            MusicSceneView()
                .tabItem {
                    Label("Music Scene", systemImage: "music.note")
                }
                .tag(1)

            DineOutView()
                .tabItem {
                    Label("Dine Out", systemImage: "fork.knife")
                }
                .tag(2)
        }
        .tint(Color.accentTurquoise)
    }
}

#Preview {
    ContentView()
        .environmentObject(AudioStreamManager.shared)
        .environmentObject(MusicSceneManager())
        .environmentObject(DineOutManager())
        .environmentObject(NotificationManager())
}
