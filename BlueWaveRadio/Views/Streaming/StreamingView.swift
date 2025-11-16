//
//  StreamingView.swift
//  Blue Wave Radio Roatan
//
//  Main streaming view with player controls
//

import SwiftUI

struct StreamingView: View {
    @EnvironmentObject var audioManager: AudioStreamManager
    @State private var showSchedule = false
    @State private var showSleepTimer = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color.primaryBlue, Color.accentTurquoise],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 30) {
                    Spacer()

                    // Album Art / Station Logo
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 220, height: 220)

                        Image(systemName: "radiowaves.left.and.right")
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                            .symbolEffect(.variableColor.iterative, isActive: audioManager.isPlaying)
                    }
                    .accessibilityLabel("Radio station logo")

                    // Station Info
                    VStack(spacing: 8) {
                        Text("101.1 Blue Wave Radio")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text("Roatan, Honduras")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }

                    // Now Playing
                    VStack(spacing: 4) {
                        Text(audioManager.currentTrack)
                            .font(.headline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)

                        if !audioManager.currentArtist.isEmpty && audioManager.currentArtist != "Roatan" {
                            Text(audioManager.currentArtist)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                    .padding(.horizontal)

                    // Buffering Indicator
                    if audioManager.isBuffering {
                        HStack(spacing: 8) {
                            ProgressView()
                                .tint(.white)
                            Text("Buffering...")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 8)
                    }

                    // Main Play/Pause Button
                    Button(action: {
                        audioManager.togglePlayPause()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 80, height: 80)
                                .shadow(radius: 10)

                            Image(systemName: audioManager.isPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 35))
                                .foregroundColor(.primaryBlue)
                        }
                    }
                    .accessibilityLabel(audioManager.isPlaying ? "Pause" : "Play")

                    // Controls Row
                    HStack(spacing: 40) {
                        // Skip Back
                        Button(action: {
                            audioManager.skip(seconds: -10)
                        }) {
                            Image(systemName: "gobackward.10")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        .accessibilityLabel("Skip back 10 seconds")

                        // Schedule
                        Button(action: {
                            showSchedule = true
                        }) {
                            Image(systemName: "calendar")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        .accessibilityLabel("Show schedule")

                        // Sleep Timer
                        Button(action: {
                            showSleepTimer = true
                        }) {
                            ZStack {
                                Image(systemName: "bed.double.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)

                                if audioManager.sleepTimerMinutes > 0 {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 10, height: 10)
                                        .offset(x: 12, y: -12)
                                }
                            }
                        }
                        .accessibilityLabel("Sleep timer")

                        // Skip Forward
                        Button(action: {
                            audioManager.skip(seconds: 30)
                        }) {
                            Image(systemName: "goforward.30")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        .accessibilityLabel("Skip forward 30 seconds")
                    }
                    .padding(.vertical)

                    // Volume Control
                    VStack(spacing: 8) {
                        HStack {
                            Image(systemName: "speaker.fill")
                                .foregroundColor(.white)

                            Slider(value: Binding(
                                get: { Double(audioManager.volume) },
                                set: { audioManager.setVolume(Float($0)) }
                            ), in: 0...1)
                            .tint(.white)

                            Image(systemName: "speaker.wave.3.fill")
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Volume")
                    .accessibilityValue("\(Int(audioManager.volume * 100))%")

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Live Radio")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showSchedule) {
                ProgrammingScheduleView()
            }
            .sheet(isPresented: $showSleepTimer) {
                SleepTimerView(audioManager: audioManager, isPresented: $showSleepTimer)
            }
        }
    }
}

#Preview {
    StreamingView()
        .environmentObject(AudioStreamManager.shared)
}
