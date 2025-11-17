//
//  BlueWaveRadioApp.swift
//  Blue Wave Radio Roatan
//
//  Main app entry point
//

import SwiftUI
import AVFoundation

@main
struct BlueWaveRadioApp: App {
    @StateObject private var audioManager = AudioStreamManager.shared
    @StateObject private var musicSceneManager = MusicSceneManager()
    @StateObject private var dineOutManager = DineOutManager()
    @StateObject private var notificationManager = NotificationManager()
    @StateObject private var weatherManager = WeatherManager.shared

    init() {
        // Configure audio session
        configureAudioSession()

        // Request notification permissions
        Task {
            await NotificationManager.shared.requestAuthorization()
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(audioManager)
                .environmentObject(musicSceneManager)
                .environmentObject(dineOutManager)
                .environmentObject(notificationManager)
                .environmentObject(weatherManager)
                .onAppear {
                    // Start background refresh tasks
                    Task {
                        await musicSceneManager.fetchEvents()
                        await dineOutManager.fetchRestaurants()
                    }
                }
        }
    }

    private func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [.allowAirPlay, .allowBluetoothA2DP])
            try audioSession.setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }
    }
}
